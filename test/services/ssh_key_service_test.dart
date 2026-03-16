import 'package:flutter_test/flutter_test.dart';
import 'package:i_connect/services/ssh_key_service.dart';

void main() {
  const service = SshKeyService();

  test('generates and re-imports an ed25519 key pair', () {
    final generated = service.generateEd25519(
      id: 'generated-key',
      label: 'Generated Key',
      requiresBiometric: true,
    );

    expect(generated.privateKeyPem, contains('BEGIN OPENSSH PRIVATE KEY'));
    expect(generated.publicKey, startsWith('ssh-ed25519 '));
    expect(generated.credential.publicKeyFingerprint, startsWith('SHA256:'));

    final imported = service.importKey(
      id: 'imported-key',
      label: 'Imported Key',
      privateKeyPem: generated.privateKeyPem,
      publicKey: generated.publicKey,
      requiresBiometric: true,
    );

    expect(imported.publicKey, generated.publicKey);
    expect(imported.credential.kind.name, 'privateKey');
    expect(imported.credential.requiresBiometric, isTrue);
  });

  test('rejects a mismatched public key', () {
    final first = service.generateEd25519(id: 'first', label: 'First Key');
    final second = service.generateEd25519(id: 'second', label: 'Second Key');

    expect(
      () => service.importKey(
        id: 'broken',
        label: 'Broken Key',
        privateKeyPem: first.privateKeyPem,
        publicKey: second.publicKey,
      ),
      throwsA(isA<SshKeyException>()),
    );
  });
}
