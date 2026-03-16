import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

import '../data/repositories.dart';

class SecureStorageService {
  const SecureStorageService();

  static const _storage = FlutterSecureStorage();

  String _primaryKey(String credentialId) => 'credential:$credentialId:primary';
  String _passphraseKey(String credentialId) =>
      'credential:$credentialId:passphrase';

  Future<void> persistCredential(
    CredentialRef ref, {
    String? primarySecret,
    String? passphrase,
  }) async {
    if (primarySecret != null) {
      await _storage.write(key: _primaryKey(ref.id), value: primarySecret);
    }
    if (passphrase != null) {
      await _storage.write(key: _passphraseKey(ref.id), value: passphrase);
    }
  }

  Future<String?> readPrimarySecret(String credentialId) {
    return _storage.read(key: _primaryKey(credentialId));
  }

  Future<String?> readPassphrase(String credentialId) {
    return _storage.read(key: _passphraseKey(credentialId));
  }

  Future<void> deleteCredential(String credentialId) async {
    await _storage.delete(key: _primaryKey(credentialId));
    await _storage.delete(key: _passphraseKey(credentialId));
  }
}

class BiometricService {
  const BiometricService();

  Future<bool> unlockIfNeeded(bool required) async {
    if (!required) {
      return true;
    }

    try {
      final auth = LocalAuthentication();
      final canCheck = await auth.canCheckBiometrics || await auth.isDeviceSupported();
      if (!canCheck) {
        return false;
      }
      return await auth.authenticate(
        localizedReason: 'Unlock your SSH credentials',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
    } on PlatformException {
      return false;
    }
  }
}
