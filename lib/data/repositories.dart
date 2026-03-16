import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'app_database.dart';

enum AuthMethod { password, privateKey, keyboardInteractive }

enum NetworkMode {
  direct,
  tailscaleNetwork,
  tailscaleConsole,
  cloudflareWarp,
  cloudflareBrowser,
}

enum CredentialKind { password, privateKey, passphrase }

enum PortForwardKind { local, remote }

enum TerminalThemePreset { midnight, glacier, daybreak }

enum PreflightRequirement {
  warpClient,
  tailscaleClient,
  browserSignIn,
  knownHostReview,
}

extension EnumStorageX on Enum {
  String get storageKey => name;
}

T enumByName<T extends Enum>(Iterable<T> values, String value, T fallback) {
  return values.firstWhere(
    (item) => item.name == value,
    orElse: () => fallback,
  );
}

String fingerprintHex(Uint8List bytes) {
  return bytes
      .map((value) => value.toRadixString(16).padLeft(2, '0'))
      .join(':');
}

class CredentialRef {
  const CredentialRef({
    required this.id,
    required this.label,
    required this.kind,
    this.usernameHint,
    this.requiresBiometric = false,
    this.publicKeyFingerprint,
    this.isEncrypted = false,
  });

  final String id;
  final String label;
  final CredentialKind kind;
  final String? usernameHint;
  final bool requiresBiometric;
  final String? publicKeyFingerprint;
  final bool isEncrypted;

  CredentialRef copyWith({
    String? id,
    String? label,
    CredentialKind? kind,
    String? usernameHint,
    bool? requiresBiometric,
    String? publicKeyFingerprint,
    bool? isEncrypted,
  }) {
    return CredentialRef(
      id: id ?? this.id,
      label: label ?? this.label,
      kind: kind ?? this.kind,
      usernameHint: usernameHint ?? this.usernameHint,
      requiresBiometric: requiresBiometric ?? this.requiresBiometric,
      publicKeyFingerprint: publicKeyFingerprint ?? this.publicKeyFingerprint,
      isEncrypted: isEncrypted ?? this.isEncrypted,
    );
  }
}

class ManagedAccessConfig {
  const ManagedAccessConfig({
    required this.mode,
    this.browserUrl,
    this.targetHint,
    this.preflightRequirements = const [],
  });

  final NetworkMode mode;
  final String? browserUrl;
  final String? targetHint;
  final List<PreflightRequirement> preflightRequirements;

  ManagedAccessConfig copyWith({
    NetworkMode? mode,
    String? browserUrl,
    String? targetHint,
    List<PreflightRequirement>? preflightRequirements,
  }) {
    return ManagedAccessConfig(
      mode: mode ?? this.mode,
      browserUrl: browserUrl ?? this.browserUrl,
      targetHint: targetHint ?? this.targetHint,
      preflightRequirements:
          preflightRequirements ?? this.preflightRequirements,
    );
  }
}

class JumpRoute {
  const JumpRoute({required this.profileId, required this.hopProfileIds});

  final String profileId;
  final List<String> hopProfileIds;

  JumpRoute copyWith({String? profileId, List<String>? hopProfileIds}) {
    return JumpRoute(
      profileId: profileId ?? this.profileId,
      hopProfileIds: hopProfileIds ?? this.hopProfileIds,
    );
  }
}

class PortForwardProfile {
  const PortForwardProfile({
    required this.id,
    required this.profileId,
    required this.kind,
    required this.bindHost,
    required this.bindPort,
    required this.targetHost,
    required this.targetPort,
    this.autoStart = false,
    this.label,
  });

  final String id;
  final String profileId;
  final PortForwardKind kind;
  final String bindHost;
  final int bindPort;
  final String targetHost;
  final int targetPort;
  final bool autoStart;
  final String? label;

  PortForwardProfile copyWith({
    String? id,
    String? profileId,
    PortForwardKind? kind,
    String? bindHost,
    int? bindPort,
    String? targetHost,
    int? targetPort,
    bool? autoStart,
    String? label,
  }) {
    return PortForwardProfile(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      kind: kind ?? this.kind,
      bindHost: bindHost ?? this.bindHost,
      bindPort: bindPort ?? this.bindPort,
      targetHost: targetHost ?? this.targetHost,
      targetPort: targetPort ?? this.targetPort,
      autoStart: autoStart ?? this.autoStart,
      label: label ?? this.label,
    );
  }
}

class Snippet {
  const Snippet({
    required this.id,
    required this.title,
    required this.shellText,
    this.placeholders = const [],
    this.workingDirectoryHint,
    this.isFavorite = false,
    this.lastUsedAt,
  });

  final String id;
  final String title;
  final String shellText;
  final List<String> placeholders;
  final String? workingDirectoryHint;
  final bool isFavorite;
  final DateTime? lastUsedAt;

  Snippet copyWith({
    String? id,
    String? title,
    String? shellText,
    List<String>? placeholders,
    String? workingDirectoryHint,
    bool? isFavorite,
    DateTime? lastUsedAt,
  }) {
    return Snippet(
      id: id ?? this.id,
      title: title ?? this.title,
      shellText: shellText ?? this.shellText,
      placeholders: placeholders ?? this.placeholders,
      workingDirectoryHint: workingDirectoryHint ?? this.workingDirectoryHint,
      isFavorite: isFavorite ?? this.isFavorite,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
    );
  }
}

class KnownHostEntry {
  const KnownHostEntry({
    required this.id,
    required this.host,
    required this.port,
    required this.keyType,
    required this.fingerprintHex,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String host;
  final int port;
  final String keyType;
  final String fingerprintHex;
  final DateTime createdAt;
  final DateTime updatedAt;
}

class ServerProfile {
  const ServerProfile({
    required this.id,
    required this.label,
    required this.host,
    required this.port,
    required this.username,
    this.tags = const [],
    this.defaultDirectory,
    this.terminalTheme = TerminalThemePreset.midnight,
    this.authMethod = AuthMethod.privateKey,
    this.credentialRef,
    this.networkMode = NetworkMode.direct,
    required this.managedAccessConfig,
    required this.jumpRoute,
    this.portForwards = const [],
  });

  final String id;
  final String label;
  final String host;
  final int port;
  final String username;
  final List<String> tags;
  final String? defaultDirectory;
  final TerminalThemePreset terminalTheme;
  final AuthMethod authMethod;
  final CredentialRef? credentialRef;
  final NetworkMode networkMode;
  final ManagedAccessConfig managedAccessConfig;
  final JumpRoute jumpRoute;
  final List<PortForwardProfile> portForwards;

  bool get usesBrowserFallback =>
      networkMode == NetworkMode.tailscaleConsole ||
      networkMode == NetworkMode.cloudflareBrowser;

  ServerProfile copyWith({
    String? id,
    String? label,
    String? host,
    int? port,
    String? username,
    List<String>? tags,
    String? defaultDirectory,
    TerminalThemePreset? terminalTheme,
    AuthMethod? authMethod,
    CredentialRef? credentialRef,
    NetworkMode? networkMode,
    ManagedAccessConfig? managedAccessConfig,
    JumpRoute? jumpRoute,
    List<PortForwardProfile>? portForwards,
  }) {
    return ServerProfile(
      id: id ?? this.id,
      label: label ?? this.label,
      host: host ?? this.host,
      port: port ?? this.port,
      username: username ?? this.username,
      tags: tags ?? this.tags,
      defaultDirectory: defaultDirectory ?? this.defaultDirectory,
      terminalTheme: terminalTheme ?? this.terminalTheme,
      authMethod: authMethod ?? this.authMethod,
      credentialRef: credentialRef ?? this.credentialRef,
      networkMode: networkMode ?? this.networkMode,
      managedAccessConfig: managedAccessConfig ?? this.managedAccessConfig,
      jumpRoute: jumpRoute ?? this.jumpRoute,
      portForwards: portForwards ?? this.portForwards,
    );
  }
}

class AppRepository {
  AppRepository(this.db, {this.seedDemoContent = true});

  final AppDatabase db;
  final bool seedDemoContent;

  final _profilesController = StreamController<List<ServerProfile>>.broadcast();
  final _snippetsController = StreamController<List<Snippet>>.broadcast();
  final _credentialsController =
      StreamController<List<CredentialRef>>.broadcast();
  final _knownHostsController =
      StreamController<List<KnownHostEntry>>.broadcast();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    _initialized = true;
    if (seedDemoContent) {
      await seedDemoData();
    }
    await _emitAll();
  }

  Stream<List<ServerProfile>> watchProfiles() async* {
    await initialize();
    yield await getProfiles();
    yield* _profilesController.stream;
  }

  Stream<List<Snippet>> watchSnippets() async* {
    await initialize();
    yield await getSnippets();
    yield* _snippetsController.stream;
  }

  Stream<List<CredentialRef>> watchSavedKeys() async* {
    await initialize();
    yield await getCredentials(kind: CredentialKind.privateKey);
    yield* _credentialsController.stream.map(
      (entries) => entries
          .where((entry) => entry.kind == CredentialKind.privateKey)
          .toList(growable: false),
    );
  }

  Stream<List<KnownHostEntry>> watchKnownHosts() async* {
    await initialize();
    yield await getKnownHosts();
    yield* _knownHostsController.stream;
  }

  Future<List<ServerProfile>> getProfiles() async {
    final profileRows = await (db.select(
      db.serverProfiles,
    )..orderBy([(tbl) => OrderingTerm.asc(tbl.label)])).get();
    final credentialRows = await db.select(db.credentialRefs).get();
    final jumpRows = await (db.select(
      db.jumpHops,
    )..orderBy([(tbl) => OrderingTerm.asc(tbl.hopOrder)])).get();
    final portForwardRows = await db.select(db.portForwardProfiles).get();

    final credentialsById = {
      for (final row in credentialRows) row.id: _mapCredential(row),
    };
    final jumpsByProfile = groupBy(
      jumpRows,
      (JumpHopRecord row) => row.profileId,
    );
    final forwardsByProfile = groupBy(
      portForwardRows,
      (PortForwardProfileRecord row) => row.profileId,
    );

    return profileRows
        .map((row) {
          final managedAccessConfig = ManagedAccessConfig(
            mode: enumByName(
              NetworkMode.values,
              row.networkMode,
              NetworkMode.direct,
            ),
            browserUrl: row.managedBrowserUrl,
            targetHint: row.managedTargetHint,
            preflightRequirements: _decodePreflightRequirements(
              row.preflightRequirementsJson,
            ),
          );

          return ServerProfile(
            id: row.id,
            label: row.label,
            host: row.host,
            port: row.port,
            username: row.username,
            tags: _decodeStringList(row.tagsJson),
            defaultDirectory: row.defaultDirectory,
            terminalTheme: enumByName(
              TerminalThemePreset.values,
              row.terminalTheme,
              TerminalThemePreset.midnight,
            ),
            authMethod: enumByName(
              AuthMethod.values,
              row.authMethod,
              AuthMethod.privateKey,
            ),
            credentialRef: row.credentialRefId == null
                ? null
                : credentialsById[row.credentialRefId],
            networkMode: enumByName(
              NetworkMode.values,
              row.networkMode,
              NetworkMode.direct,
            ),
            managedAccessConfig: managedAccessConfig,
            jumpRoute: JumpRoute(
              profileId: row.id,
              hopProfileIds: (jumpsByProfile[row.id] ?? const [])
                  .map((hop) => hop.hopProfileId)
                  .toList(growable: false),
            ),
            portForwards: (forwardsByProfile[row.id] ?? const [])
                .map(_mapForward)
                .toList(growable: false),
          );
        })
        .toList(growable: false);
  }

  Future<Map<String, ServerProfile>> getProfileMap() async {
    final profiles = await getProfiles();
    return {for (final profile in profiles) profile.id: profile};
  }

  Future<List<ServerProfile>> getProfilesByIds(List<String> ids) async {
    final profileMap = await getProfileMap();
    return ids
        .map((id) => profileMap[id])
        .whereType<ServerProfile>()
        .toList(growable: false);
  }

  Future<List<CredentialRef>> getCredentials({CredentialKind? kind}) async {
    await initialize();
    final query = db.select(db.credentialRefs)
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.label)]);
    if (kind != null) {
      query.where((tbl) => tbl.kind.equals(kind.storageKey));
    }
    final rows = await query.get();
    return rows.map(_mapCredential).toList(growable: false);
  }

  Future<CredentialRef?> getCredentialById(String id) async {
    await initialize();
    final row = await (db.select(
      db.credentialRefs,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    return row == null ? null : _mapCredential(row);
  }

  Future<void> saveCredential(CredentialRef credential) async {
    await initialize();
    await db
        .into(db.credentialRefs)
        .insertOnConflictUpdate(
          CredentialRefsCompanion.insert(
            id: credential.id,
            label: credential.label,
            kind: credential.kind.storageKey,
            usernameHint: Value(credential.usernameHint),
            requiresBiometric: Value(credential.requiresBiometric),
            publicKeyFingerprint: Value(credential.publicKeyFingerprint),
            isEncrypted: Value(credential.isEncrypted),
            createdAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );
    await _emitCredentials();
    await _emitProfiles();
  }

  Future<void> deleteCredentialRef(String id) async {
    await initialize();
    await (db.delete(
      db.credentialRefs,
    )..where((tbl) => tbl.id.equals(id))).go();
    await _emitCredentials();
    await _emitProfiles();
  }

  Future<void> saveProfile(ServerProfile profile) async {
    await initialize();
    await db.transaction(() async {
      if (profile.credentialRef != null) {
        await db
            .into(db.credentialRefs)
            .insertOnConflictUpdate(
              CredentialRefsCompanion.insert(
                id: profile.credentialRef!.id,
                label: profile.credentialRef!.label,
                kind: profile.credentialRef!.kind.storageKey,
                usernameHint: Value(profile.credentialRef!.usernameHint),
                requiresBiometric: Value(
                  profile.credentialRef!.requiresBiometric,
                ),
                publicKeyFingerprint: Value(
                  profile.credentialRef!.publicKeyFingerprint,
                ),
                isEncrypted: Value(profile.credentialRef!.isEncrypted),
                createdAt: DateTime.now().millisecondsSinceEpoch,
              ),
            );
      }

      await db
          .into(db.serverProfiles)
          .insertOnConflictUpdate(
            ServerProfilesCompanion.insert(
              id: profile.id,
              label: profile.label,
              host: profile.host,
              port: profile.port,
              username: profile.username,
              tagsJson: Value(_encodeStringList(profile.tags)),
              terminalTheme: profile.terminalTheme.storageKey,
              authMethod: profile.authMethod.storageKey,
              networkMode: profile.networkMode.storageKey,
              preflightRequirementsJson: Value(
                _encodePreflightRequirements(
                  profile.managedAccessConfig.preflightRequirements,
                ),
              ),
              createdAt: DateTime.now().millisecondsSinceEpoch,
              defaultDirectory: Value(profile.defaultDirectory),
              credentialRefId: Value(profile.credentialRef?.id),
              managedBrowserUrl: Value(profile.managedAccessConfig.browserUrl),
              managedTargetHint: Value(profile.managedAccessConfig.targetHint),
              updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
            ),
          );

      await (db.delete(
        db.jumpHops,
      )..where((tbl) => tbl.profileId.equals(profile.id))).go();
      for (final entry in profile.jumpRoute.hopProfileIds.indexed) {
        await db
            .into(db.jumpHops)
            .insert(
              JumpHopsCompanion.insert(
                id: const Uuid().v4(),
                profileId: profile.id,
                hopOrder: entry.$1,
                hopProfileId: entry.$2,
              ),
            );
      }

      await (db.delete(
        db.portForwardProfiles,
      )..where((tbl) => tbl.profileId.equals(profile.id))).go();
      for (final forward in profile.portForwards) {
        await db
            .into(db.portForwardProfiles)
            .insert(
              PortForwardProfilesCompanion.insert(
                id: forward.id,
                profileId: profile.id,
                kind: forward.kind.storageKey,
                bindHost: forward.bindHost,
                bindPort: forward.bindPort,
                targetHost: forward.targetHost,
                targetPort: forward.targetPort,
                autoStart: Value(forward.autoStart),
                label: Value(forward.label),
              ),
            );
      }
    });
    await Future.wait([_emitProfiles(), _emitCredentials()]);
  }

  Future<void> deleteProfile(ServerProfile profile) async {
    await initialize();
    await db.transaction(() async {
      await (db.delete(
        db.jumpHops,
      )..where((tbl) => tbl.profileId.equals(profile.id))).go();
      await (db.delete(
        db.portForwardProfiles,
      )..where((tbl) => tbl.profileId.equals(profile.id))).go();
      await (db.delete(
        db.serverProfiles,
      )..where((tbl) => tbl.id.equals(profile.id))).go();
    });
    await _emitProfiles();
  }

  Future<List<Snippet>> getSnippets() async {
    final rows =
        await (db.select(db.snippets)..orderBy([
              (tbl) => OrderingTerm.desc(tbl.isFavorite),
              (tbl) => OrderingTerm.asc(tbl.title),
            ]))
            .get();

    return rows
        .map(
          (row) => Snippet(
            id: row.id,
            title: row.title,
            shellText: row.shellText,
            placeholders: _decodeStringList(row.placeholdersJson),
            workingDirectoryHint: row.workingDirectoryHint,
            isFavorite: row.isFavorite,
            lastUsedAt: row.lastUsedAt == null
                ? null
                : DateTime.fromMillisecondsSinceEpoch(row.lastUsedAt!),
          ),
        )
        .toList(growable: false);
  }

  Future<void> saveSnippet(Snippet snippet) async {
    await initialize();
    await db
        .into(db.snippets)
        .insertOnConflictUpdate(
          SnippetsCompanion.insert(
            id: snippet.id,
            title: snippet.title,
            shellText: snippet.shellText,
            placeholdersJson: Value(_encodeStringList(snippet.placeholders)),
            isFavorite: Value(snippet.isFavorite),
            createdAt: DateTime.now().millisecondsSinceEpoch,
            lastUsedAt: Value(snippet.lastUsedAt?.millisecondsSinceEpoch),
            workingDirectoryHint: Value(snippet.workingDirectoryHint),
          ),
        );
    await _emitSnippets();
  }

  Future<void> deleteSnippet(Snippet snippet) async {
    await initialize();
    await (db.delete(
      db.snippets,
    )..where((tbl) => tbl.id.equals(snippet.id))).go();
    await _emitSnippets();
  }

  Future<List<KnownHostEntry>> getKnownHosts() async {
    final rows = await (db.select(
      db.knownHosts,
    )..orderBy([(tbl) => OrderingTerm.asc(tbl.host)])).get();
    return rows
        .map(
          (row) => KnownHostEntry(
            id: row.id,
            host: row.host,
            port: row.port,
            keyType: row.keyType,
            fingerprintHex: row.fingerprintHex,
            createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt),
            updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
          ),
        )
        .toList(growable: false);
  }

  Future<KnownHostEntry?> findKnownHost(
    String host,
    int port,
    String keyType,
  ) async {
    await initialize();
    final row =
        await (db.select(db.knownHosts)..where(
              (tbl) =>
                  tbl.host.equals(host) &
                  tbl.port.equals(port) &
                  tbl.keyType.equals(keyType),
            ))
            .getSingleOrNull();
    if (row == null) {
      return null;
    }
    return KnownHostEntry(
      id: row.id,
      host: row.host,
      port: row.port,
      keyType: row.keyType,
      fingerprintHex: row.fingerprintHex,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
    );
  }

  Future<void> saveKnownHost({
    required String host,
    required int port,
    required String keyType,
    required String fingerprint,
  }) async {
    await initialize();
    final existing = await findKnownHost(host, port, keyType);
    await db
        .into(db.knownHosts)
        .insertOnConflictUpdate(
          KnownHostsCompanion.insert(
            id: existing?.id ?? const Uuid().v4(),
            host: host,
            port: port,
            keyType: keyType,
            fingerprintHex: fingerprint,
            createdAt:
                existing?.createdAt.millisecondsSinceEpoch ??
                DateTime.now().millisecondsSinceEpoch,
            updatedAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );
    await _emitKnownHosts();
  }

  Future<void> deleteKnownHost(KnownHostEntry entry) async {
    await initialize();
    await (db.delete(
      db.knownHosts,
    )..where((tbl) => tbl.id.equals(entry.id))).go();
    await _emitKnownHosts();
  }

  Future<void> seedDemoData() async {
    final existing = await db.select(db.serverProfiles).get();
    if (existing.isNotEmpty) {
      return;
    }

    const uuid = Uuid();
    final bastionId = uuid.v4();
    final fleetId = uuid.v4();
    final browserId = uuid.v4();

    await saveProfile(
      ServerProfile(
        id: bastionId,
        label: 'Bastion',
        host: 'bastion.internal',
        port: 22,
        username: 'ops',
        tags: const ['jump', 'prod'],
        defaultDirectory: '/home/ops',
        authMethod: AuthMethod.privateKey,
        terminalTheme: TerminalThemePreset.midnight,
        managedAccessConfig: const ManagedAccessConfig(
          mode: NetworkMode.direct,
          preflightRequirements: [PreflightRequirement.knownHostReview],
        ),
        jumpRoute: JumpRoute(profileId: bastionId, hopProfileIds: const []),
        portForwards: [
          PortForwardProfile(
            id: 'pf-bastion-5432',
            profileId: bastionId,
            kind: PortForwardKind.local,
            bindHost: '127.0.0.1',
            bindPort: 5432,
            targetHost: 'db.internal',
            targetPort: 5432,
            autoStart: false,
            label: 'Postgres',
          ),
        ],
      ),
    );

    await saveProfile(
      ServerProfile(
        id: fleetId,
        label: 'Fleet Node',
        host: 'db-admin.tailnet.ts.net',
        port: 22,
        username: 'ubuntu',
        tags: const ['tailscale', 'lab'],
        defaultDirectory: '/srv/app',
        authMethod: AuthMethod.password,
        terminalTheme: TerminalThemePreset.glacier,
        networkMode: NetworkMode.tailscaleNetwork,
        managedAccessConfig: const ManagedAccessConfig(
          mode: NetworkMode.tailscaleNetwork,
          targetHint: 'Tailscale tailnet reachability required',
          preflightRequirements: [
            PreflightRequirement.tailscaleClient,
            PreflightRequirement.knownHostReview,
          ],
        ),
        jumpRoute: JumpRoute(profileId: fleetId, hopProfileIds: [bastionId]),
        portForwards: const [],
      ),
    );

    await saveProfile(
      ServerProfile(
        id: browserId,
        label: 'Zero Trust Edge',
        host: 'edge.example.com',
        port: 22,
        username: 'engineer',
        tags: const ['cloudflare', 'managed'],
        defaultDirectory: '/home/engineer',
        authMethod: AuthMethod.keyboardInteractive,
        terminalTheme: TerminalThemePreset.daybreak,
        networkMode: NetworkMode.cloudflareBrowser,
        managedAccessConfig: const ManagedAccessConfig(
          mode: NetworkMode.cloudflareBrowser,
          browserUrl: 'https://one.dash.cloudflare.com/browser-terminal',
          targetHint: 'Cloudflare browser-rendered SSH fallback',
          preflightRequirements: [
            PreflightRequirement.browserSignIn,
            PreflightRequirement.warpClient,
          ],
        ),
        jumpRoute: JumpRoute(profileId: browserId, hopProfileIds: const []),
      ),
    );

    await saveSnippet(
      Snippet(
        id: uuid.v4(),
        title: 'Tail system log',
        shellText: 'tail -f /var/log/system.log',
        isFavorite: true,
      ),
    );
    await saveSnippet(
      Snippet(
        id: uuid.v4(),
        title: 'Restart service',
        shellText: 'sudo systemctl restart {{service}}',
        placeholders: const ['service'],
      ),
    );
  }

  Future<void> dispose() async {
    await _profilesController.close();
    await _snippetsController.close();
    await _credentialsController.close();
    await _knownHostsController.close();
  }

  Future<void> _emitAll() async {
    await Future.wait([
      _emitProfiles(),
      _emitSnippets(),
      _emitCredentials(),
      _emitKnownHosts(),
    ]);
  }

  Future<void> _emitProfiles() async {
    _profilesController.add(await getProfiles());
  }

  Future<void> _emitSnippets() async {
    _snippetsController.add(await getSnippets());
  }

  Future<void> _emitCredentials() async {
    _credentialsController.add(await getCredentials());
  }

  Future<void> _emitKnownHosts() async {
    _knownHostsController.add(await getKnownHosts());
  }

  CredentialRef _mapCredential(CredentialRefRecord row) {
    return CredentialRef(
      id: row.id,
      label: row.label,
      kind: enumByName(
        CredentialKind.values,
        row.kind,
        CredentialKind.privateKey,
      ),
      usernameHint: row.usernameHint,
      requiresBiometric: row.requiresBiometric,
      publicKeyFingerprint: row.publicKeyFingerprint,
      isEncrypted: row.isEncrypted,
    );
  }

  PortForwardProfile _mapForward(PortForwardProfileRecord row) {
    return PortForwardProfile(
      id: row.id,
      profileId: row.profileId,
      kind: enumByName(PortForwardKind.values, row.kind, PortForwardKind.local),
      bindHost: row.bindHost,
      bindPort: row.bindPort,
      targetHost: row.targetHost,
      targetPort: row.targetPort,
      autoStart: row.autoStart,
      label: row.label,
    );
  }

  List<String> _decodeStringList(String value) {
    final raw = jsonDecode(value);
    return (raw as List<dynamic>).cast<String>();
  }

  String _encodeStringList(List<String> values) {
    return jsonEncode(values);
  }

  List<PreflightRequirement> _decodePreflightRequirements(String value) {
    return _decodeStringList(value)
        .map(
          (item) => enumByName(
            PreflightRequirement.values,
            item,
            PreflightRequirement.knownHostReview,
          ),
        )
        .toList(growable: false);
  }

  String _encodePreflightRequirements(List<PreflightRequirement> values) {
    return jsonEncode(values.map((value) => value.storageKey).toList());
  }
}
