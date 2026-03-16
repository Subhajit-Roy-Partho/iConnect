import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:pinenacl/ed25519.dart' as ed25519;

import '../data/repositories.dart';

class SavedKeyMaterial {
  const SavedKeyMaterial({
    required this.credential,
    required this.privateKeyPem,
    required this.publicKey,
    this.passphrase,
  });

  final CredentialRef credential;
  final String privateKeyPem;
  final String publicKey;
  final String? passphrase;
}

class SshKeyException implements Exception {
  const SshKeyException(this.message);

  final String message;

  @override
  String toString() => message;
}

class SshKeyService {
  const SshKeyService();

  SavedKeyMaterial importKey({
    required String id,
    required String label,
    required String privateKeyPem,
    String? publicKey,
    String? passphrase,
    bool requiresBiometric = false,
  }) {
    final trimmedPrivateKey = privateKeyPem.trim();
    if (trimmedPrivateKey.isEmpty) {
      throw const SshKeyException('A private key is required.');
    }

    final normalizedPassphrase = _normalizeOptional(passphrase);
    final derivedPublicKey = publicKeyForPrivateKey(
      privateKeyPem: trimmedPrivateKey,
      passphrase: normalizedPassphrase,
      comment: label,
    );
    final normalizedPublicKey = publicKey == null || publicKey.trim().isEmpty
        ? derivedPublicKey
        : normalizePublicKey(publicKey, fallbackComment: label);

    final provided = _splitPublicKey(normalizedPublicKey);
    final derived = _splitPublicKey(derivedPublicKey);
    if (provided.type != derived.type ||
        provided.encodedKey != derived.encodedKey) {
      throw const SshKeyException(
        'The public key does not match the selected private key.',
      );
    }

    return SavedKeyMaterial(
      credential: CredentialRef(
        id: id,
        label: label.trim().isEmpty ? id : label.trim(),
        kind: CredentialKind.privateKey,
        requiresBiometric: requiresBiometric,
        publicKeyFingerprint: fingerprintPublicKey(normalizedPublicKey),
        isEncrypted: SSHKeyPair.isEncryptedPem(trimmedPrivateKey),
      ),
      privateKeyPem: trimmedPrivateKey,
      publicKey: normalizedPublicKey,
      passphrase: normalizedPassphrase,
    );
  }

  SavedKeyMaterial generateEd25519({
    required String id,
    required String label,
    bool requiresBiometric = false,
  }) {
    final signingKey = ed25519.SigningKey.generate();
    final keyPair = OpenSSHEd25519KeyPair(
      signingKey.verifyKey.asTypedList,
      signingKey.asTypedList,
      label,
    );
    final privateKeyPem = keyPair.toPem();
    final publicKey = _publicKeyLine(
      type: keyPair.name,
      encodedKey: base64Encode(keyPair.toPublicKey().encode()),
      comment: label,
    );

    return SavedKeyMaterial(
      credential: CredentialRef(
        id: id,
        label: label.trim().isEmpty ? id : label.trim(),
        kind: CredentialKind.privateKey,
        requiresBiometric: requiresBiometric,
        publicKeyFingerprint: fingerprintPublicKey(publicKey),
        isEncrypted: false,
      ),
      privateKeyPem: privateKeyPem,
      publicKey: publicKey,
    );
  }

  String publicKeyForPrivateKey({
    required String privateKeyPem,
    String? passphrase,
    String? comment,
  }) {
    final normalizedPassphrase = _normalizeOptional(passphrase);
    final keyPair = _parseKeyPair(privateKeyPem.trim(), normalizedPassphrase);
    return _publicKeyLine(
      type: keyPair.name,
      encodedKey: base64Encode(keyPair.toPublicKey().encode()),
      comment: _normalizeOptional(comment),
    );
  }

  String normalizePublicKey(String publicKey, {String? fallbackComment}) {
    final parts = _splitPublicKey(publicKey);
    return _publicKeyLine(
      type: parts.type,
      encodedKey: parts.encodedKey,
      comment: parts.comment ?? _normalizeOptional(fallbackComment),
    );
  }

  String fingerprintPublicKey(String publicKey) {
    final parts = _splitPublicKey(publicKey);
    final digest = sha256.convert(base64Decode(parts.encodedKey)).bytes;
    return 'SHA256:${base64Encode(digest).replaceAll('=', '')}';
  }

  SSHKeyPair _parseKeyPair(String privateKeyPem, String? passphrase) {
    try {
      return SSHKeyPair.fromPem(privateKeyPem, passphrase).first;
    } on SSHKeyDecryptError {
      throw const SshKeyException(
        'The private key passphrase is missing or invalid.',
      );
    } on UnsupportedError catch (error) {
      throw SshKeyException(error.message ?? 'Unsupported private key format.');
    } on FormatException {
      throw const SshKeyException('The private key is not valid PEM content.');
    } catch (error) {
      throw SshKeyException('Unable to read the private key: $error');
    }
  }

  _ParsedPublicKey _splitPublicKey(String publicKeyText) {
    final trimmed = publicKeyText.trim();
    final match = RegExp(r'^(\S+)\s+(\S+)(?:\s+(.+))?$').firstMatch(trimmed);
    if (match == null) {
      throw const SshKeyException(
        'Public keys must use the OpenSSH format: type, key, and optional comment.',
      );
    }

    final type = match.group(1)!;
    final encodedKey = match.group(2)!;
    try {
      base64Decode(encodedKey);
    } on FormatException {
      throw const SshKeyException(
        'The public key payload is not valid base64.',
      );
    }

    return _ParsedPublicKey(
      type: type,
      encodedKey: encodedKey,
      comment: _normalizeOptional(match.group(3)),
    );
  }

  String _publicKeyLine({
    required String type,
    required String encodedKey,
    String? comment,
  }) {
    final normalizedComment = _normalizeOptional(comment);
    return normalizedComment == null
        ? '$type $encodedKey'
        : '$type $encodedKey $normalizedComment';
  }

  String? _normalizeOptional(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}

class _ParsedPublicKey {
  const _ParsedPublicKey({
    required this.type,
    required this.encodedKey,
    this.comment,
  });

  final String type;
  final String encodedKey;
  final String? comment;
}
