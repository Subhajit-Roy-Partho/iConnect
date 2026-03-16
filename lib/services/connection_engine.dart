import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:xterm/xterm.dart';

import '../app/theme.dart';
import '../data/repositories.dart';
import 'browser_launcher.dart';
import 'secure_storage_service.dart';

abstract class HostTrustDelegate {
  Future<bool> approveUnknownHost({
    required String host,
    required int port,
    required String keyType,
    required String fingerprint,
  });

  Future<bool> approveChangedHostKey({
    required String host,
    required int port,
    required String keyType,
    required String existingFingerprint,
    required String newFingerprint,
  });
}

class BrowserLaunchIntent {
  const BrowserLaunchIntent({
    required this.url,
    required this.reason,
  });

  final String url;
  final String reason;
}

sealed class SessionLaunchResult {
  const SessionLaunchResult();
}

class NativeSessionLaunchResult extends SessionLaunchResult {
  const NativeSessionLaunchResult(this.session);

  final ConnectedSession session;
}

class BrowserSessionLaunchResult extends SessionLaunchResult {
  const BrowserSessionLaunchResult(this.intent);

  final BrowserLaunchIntent intent;
}

class ConnectionEngine {
  const ConnectionEngine({
    required this.repository,
    required this.secureStorage,
    required this.biometricService,
    required this.browserLauncher,
  });

  final AppRepository repository;
  final SecureStorageService secureStorage;
  final BiometricService biometricService;
  final BrowserLauncher browserLauncher;

  Future<SessionLaunchResult> launch(
    ServerProfile profile, {
    required HostTrustDelegate hostTrustDelegate,
  }) async {
    if (profile.usesBrowserFallback) {
      final url = profile.managedAccessConfig.browserUrl;
      if (url == null || url.isEmpty) {
        throw StateError('Browser fallback requires a configured URL.');
      }
      return BrowserSessionLaunchResult(
        BrowserLaunchIntent(
          url: url,
          reason: profile.managedAccessConfig.targetHint ??
              'Managed access is handled in the browser for this profile.',
        ),
      );
    }

    final terminal = Terminal(maxLines: 5000);
    terminal.write('Opening ${profile.label}...\r\n');

    final routeProfiles =
        await repository.getProfilesByIds(profile.jumpRoute.hopProfileIds);

    final jumpClients = <SSHClient>[];
    SSHSocket socket = await SSHSocket.connect(routeProfiles.isEmpty ? profile.host : routeProfiles.first.host, routeProfiles.isEmpty ? profile.port : routeProfiles.first.port);

    for (var index = 0; index < routeProfiles.length; index++) {
      final routeProfile = routeProfiles[index];
      final client = await _connectClient(
        profile: routeProfile,
        socket: socket,
        hostTrustDelegate: hostTrustDelegate,
      );
      jumpClients.add(client);

      final nextHost = index == routeProfiles.length - 1
          ? profile.host
          : routeProfiles[index + 1].host;
      final nextPort = index == routeProfiles.length - 1
          ? profile.port
          : routeProfiles[index + 1].port;
      socket = await client.forwardLocal(nextHost, nextPort);
    }

    final client = await _connectClient(
      profile: profile,
      socket: socket,
      hostTrustDelegate: hostTrustDelegate,
    );
    final shell = await client.shell(
      pty: SSHPtyConfig(
        width: terminal.viewWidth,
        height: terminal.viewHeight,
      ),
    );

    return NativeSessionLaunchResult(
      ConnectedSession(
        profile: profile,
        client: client,
        shell: shell,
        terminal: terminal,
        jumpClients: jumpClients,
      ),
    );
  }

  Future<bool> openBrowser(BrowserLaunchIntent intent) {
    return browserLauncher.open(intent.url);
  }

  Future<SSHClient> _connectClient({
    required ServerProfile profile,
    required SSHSocket socket,
    required HostTrustDelegate hostTrustDelegate,
  }) async {
    final credential = profile.credentialRef;
    if (credential != null) {
      final unlocked = await biometricService.unlockIfNeeded(
        credential.requiresBiometric,
      );
      if (!unlocked) {
        throw StateError('Credential unlock was cancelled.');
      }
    }

    final secret = credential == null
        ? null
        : await secureStorage.readPrimarySecret(credential.id);
    final passphrase = credential == null
        ? null
        : await secureStorage.readPassphrase(credential.id);

    final identities = switch (profile.authMethod) {
      AuthMethod.privateKey when secret != null =>
        SSHKeyPair.fromPem(secret, passphrase),
      _ => null,
    };

    final client = SSHClient(
      socket,
      username: profile.username,
      identities: identities,
      onPasswordRequest: () => secret,
      onUserInfoRequest: (request) async {
        if (secret == null) {
          return null;
        }
        return List<String>.filled(request.prompts.length, secret);
      },
      onVerifyHostKey: (type, fingerprint) async {
        final fingerprintText = fingerprintHex(fingerprint);
        final existing = await repository.findKnownHost(
          profile.host,
          profile.port,
          type,
        );

        if (existing == null) {
          final approved = await hostTrustDelegate.approveUnknownHost(
            host: profile.host,
            port: profile.port,
            keyType: type,
            fingerprint: fingerprintText,
          );
          if (approved) {
            await repository.saveKnownHost(
              host: profile.host,
              port: profile.port,
              keyType: type,
              fingerprint: fingerprintText,
            );
          }
          return approved;
        }

        if (existing.fingerprintHex == fingerprintText) {
          return true;
        }

        final approved = await hostTrustDelegate.approveChangedHostKey(
          host: profile.host,
          port: profile.port,
          keyType: type,
          existingFingerprint: existing.fingerprintHex,
          newFingerprint: fingerprintText,
        );
        if (approved) {
          await repository.saveKnownHost(
            host: profile.host,
            port: profile.port,
            keyType: type,
            fingerprint: fingerprintText,
          );
        }
        return approved;
      },
    );
    await client.authenticated;
    return client;
  }
}

class RemoteFileEntry {
  const RemoteFileEntry({
    required this.name,
    required this.path,
    required this.isDirectory,
    required this.isSymbolicLink,
    this.size,
    this.modifiedAt,
  });

  final String name;
  final String path;
  final bool isDirectory;
  final bool isSymbolicLink;
  final int? size;
  final DateTime? modifiedAt;
}

class ConnectedSession {
  ConnectedSession({
    required this.profile,
    required this.client,
    required this.shell,
    required this.terminal,
    required this.jumpClients,
  }) {
    terminal.onOutput = (data) {
      shell.write(Uint8List.fromList(utf8.encode(data)));
    };
    terminal.onResize = (width, height, pixelWidth, pixelHeight) {
      shell.resizeTerminal(width, height, pixelWidth, pixelHeight);
    };

    _stdoutSub = shell.stdout.listen((data) {
      terminal.write(utf8.decode(data, allowMalformed: true));
    });
    _stderrSub = shell.stderr.listen((data) {
      terminal.write(utf8.decode(data, allowMalformed: true));
    });
  }

  final ServerProfile profile;
  final SSHClient client;
  final SSHSession shell;
  final Terminal terminal;
  final List<SSHClient> jumpClients;

  late final StreamSubscription<Uint8List> _stdoutSub;
  late final StreamSubscription<Uint8List> _stderrSub;

  SftpClient? _sftp;

  TerminalTheme get terminalTheme => terminalThemes[profile.terminalTheme]!;

  Future<List<RemoteFileEntry>> listDirectory([String? path]) async {
    final client = await _sftpClient();
    final absolutePath = await _normalizePath(path ?? startingDirectory);
    final entries = await client.listdir(absolutePath);
    return entries
        .where((entry) => entry.filename != '.' && entry.filename != '..')
        .map(
          (entry) => RemoteFileEntry(
            name: entry.filename,
            path: p.posix.join(absolutePath, entry.filename),
            isDirectory: entry.attr.isDirectory,
            isSymbolicLink: entry.attr.isSymbolicLink,
            size: entry.attr.size,
            modifiedAt: entry.attr.modifyTime == null
                ? null
                : DateTime.fromMillisecondsSinceEpoch(
                    entry.attr.modifyTime! * 1000,
                  ),
          ),
        )
        .sortedBy((entry) => entry.name.toLowerCase())
        .toList(growable: false);
  }

  String get startingDirectory => profile.defaultDirectory ?? '.';

  Future<String> resolveDirectory(String path) async {
    return _normalizePath(path);
  }

  Future<void> createDirectory(String path) async {
    await (await _sftpClient()).mkdir(path);
  }

  Future<void> deletePath(RemoteFileEntry entry) async {
    final client = await _sftpClient();
    if (entry.isDirectory) {
      await client.rmdir(entry.path);
    } else {
      await client.remove(entry.path);
    }
  }

  Future<void> renamePath(String oldPath, String newPath) async {
    await (await _sftpClient()).rename(oldPath, newPath);
  }

  Future<void> uploadIntoDirectory(String directoryPath) async {
    final picked = await FilePicker.platform.pickFiles(withData: true);
    if (picked == null || picked.files.isEmpty) {
      return;
    }
    final file = picked.files.single;
    final bytes = file.bytes;
    if (bytes == null) {
      return;
    }

    final remotePath = p.posix.join(directoryPath, file.name);
    final sftp = await _sftpClient();
    final remote = await sftp.open(
      remotePath,
      mode: SftpFileOpenMode.create |
          SftpFileOpenMode.write |
          SftpFileOpenMode.truncate,
    );
    await remote.writeBytes(bytes);
    await remote.close();
  }

  Future<File> downloadToDocuments(RemoteFileEntry entry) async {
    final sftp = await _sftpClient();
    final remote = await sftp.open(entry.path, mode: SftpFileOpenMode.read);
    final bytes = await remote.readBytes();
    await remote.close();

    final directory = await getApplicationDocumentsDirectory();
    final output = File(p.join(directory.path, entry.name));
    await output.writeAsBytes(bytes, flush: true);
    return output;
  }

  Future<Uint8List> readPreviewBytes(String remotePath, {int maxBytes = 32768}) async {
    final sftp = await _sftpClient();
    final remote = await sftp.open(remotePath, mode: SftpFileOpenMode.read);
    final bytes = await remote.readBytes(length: maxBytes);
    await remote.close();
    return bytes;
  }

  Future<void> runSnippet(String command) async {
    shell.write(Uint8List.fromList(utf8.encode('$command\n')));
  }

  Future<void> close() async {
    await _stdoutSub.cancel();
    await _stderrSub.cancel();
    _sftp?.close();
    shell.close();
    client.close();
    for (final jumpClient in jumpClients.reversed) {
      jumpClient.close();
    }
  }

  Future<SftpClient> _sftpClient() async {
    final current = _sftp;
    if (current != null) {
      return current;
    }
    final created = await client.sftp();
    _sftp = created;
    return created;
  }

  Future<String> _normalizePath(String path) async {
    return (await _sftpClient()).absolute(path);
  }
}
