import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../services/ssh_key_service.dart';

class SavedKeyEditorSheet extends StatefulWidget {
  const SavedKeyEditorSheet({super.key, required this.sshKeyService});

  final SshKeyService sshKeyService;

  @override
  State<SavedKeyEditorSheet> createState() => _SavedKeyEditorSheetState();
}

class _SavedKeyEditorSheetState extends State<SavedKeyEditorSheet> {
  static const _uuid = Uuid();

  late final TextEditingController _labelController;
  late final TextEditingController _privateKeyController;
  late final TextEditingController _publicKeyController;
  late final TextEditingController _passphraseController;

  bool _requiresBiometric = false;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController();
    _privateKeyController = TextEditingController();
    _publicKeyController = TextEditingController();
    _passphraseController = TextEditingController();
  }

  @override
  void dispose() {
    _labelController.dispose();
    _privateKeyController.dispose();
    _publicKeyController.dispose();
    _passphraseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Saved Key',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Import a private/public key pair or generate a new Ed25519 key that can be reused across servers by ID.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _labelController,
                decoration: const InputDecoration(
                  labelText: 'Key name',
                  hintText: 'Work laptop or Prod deploy key',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  FilledButton.icon(
                    onPressed: _generateEd25519,
                    icon: const Icon(Icons.auto_fix_high_outlined),
                    label: const Text('Generate Ed25519'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: _derivePublicKey,
                    icon: const Icon(Icons.key_outlined),
                    label: const Text('Derive Public Key'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _privateKeyController,
                maxLines: 10,
                decoration: const InputDecoration(
                  labelText: 'Private key (PEM)',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _publicKeyController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Public key (OpenSSH)',
                  hintText: 'ssh-ed25519 AAAA...',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passphraseController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Private key passphrase (optional)',
                ),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _requiresBiometric,
                title: const Text('Require biometric unlock'),
                onChanged: (value) {
                  setState(() => _requiresBiometric = value);
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const Spacer(),
                  FilledButton(onPressed: _save, child: const Text('Save Key')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _generateEd25519() {
    try {
      final label = _labelController.text.trim().isEmpty
          ? 'Generated key'
          : _labelController.text.trim();
      final generated = widget.sshKeyService.generateEd25519(
        id: _uuid.v4(),
        label: label,
        requiresBiometric: _requiresBiometric,
      );
      _privateKeyController.text = generated.privateKeyPem;
      _publicKeyController.text = generated.publicKey;
      _passphraseController.clear();
      _showMessage('Generated a new Ed25519 key.');
    } on SshKeyException catch (error) {
      _showMessage(error.message);
    }
  }

  void _derivePublicKey() {
    try {
      _publicKeyController.text = widget.sshKeyService.publicKeyForPrivateKey(
        privateKeyPem: _privateKeyController.text,
        passphrase: _passphraseController.text,
        comment: _labelController.text.trim(),
      );
      _showMessage('Derived the public key from the private key.');
    } on SshKeyException catch (error) {
      _showMessage(error.message);
    }
  }

  void _save() {
    try {
      final material = widget.sshKeyService.importKey(
        id: _uuid.v4(),
        label: _labelController.text.trim(),
        privateKeyPem: _privateKeyController.text,
        publicKey: _publicKeyController.text,
        passphrase: _passphraseController.text,
        requiresBiometric: _requiresBiometric,
      );
      Navigator.of(context).pop(material);
    } on SshKeyException catch (error) {
      _showMessage(error.message);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
