import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../core/server_profile_validator.dart';
import '../data/repositories.dart';
import '../services/ssh_key_service.dart';
import 'saved_key_editor_sheet.dart';

class ServerEditorResult {
  const ServerEditorResult({
    required this.profile,
    this.primarySecret,
    this.passphrase,
    this.savedKeys = const [],
  });

  final ServerProfile profile;
  final String? primarySecret;
  final String? passphrase;
  final List<SavedKeyMaterial> savedKeys;
}

class ServerEditorSheet extends StatefulWidget {
  const ServerEditorSheet({
    super.key,
    this.initialProfile,
    required this.availableProfiles,
    required this.availableKeys,
    required this.sshKeyService,
  });

  final ServerProfile? initialProfile;
  final List<ServerProfile> availableProfiles;
  final List<CredentialRef> availableKeys;
  final SshKeyService sshKeyService;

  @override
  State<ServerEditorSheet> createState() => _ServerEditorSheetState();
}

class _ServerEditorSheetState extends State<ServerEditorSheet> {
  static const _uuid = Uuid();

  late final TextEditingController _labelController;
  late final TextEditingController _hostController;
  late final TextEditingController _portController;
  late final TextEditingController _usernameController;
  late final TextEditingController _tagsController;
  late final TextEditingController _defaultDirectoryController;
  late final TextEditingController _credentialLabelController;
  late final TextEditingController _secretController;
  late final TextEditingController _browserUrlController;
  late final TextEditingController _targetHintController;

  late AuthMethod _authMethod;
  late NetworkMode _networkMode;
  late TerminalThemePreset _themePreset;
  late bool _requiresBiometric;
  late final List<String> _selectedHopIds;
  late final List<_PortForwardDraft> _forwardDrafts;
  late final List<CredentialRef> _availableKeys;
  final List<SavedKeyMaterial> _createdKeys = [];

  String? _pendingHopId;
  String? _selectedKeyId;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialProfile;
    _labelController = TextEditingController(text: initial?.label ?? '');
    _hostController = TextEditingController(text: initial?.host ?? '');
    _portController = TextEditingController(
      text: (initial?.port ?? 22).toString(),
    );
    _usernameController = TextEditingController(text: initial?.username ?? '');
    _tagsController = TextEditingController(
      text: initial?.tags.join(', ') ?? '',
    );
    _defaultDirectoryController = TextEditingController(
      text: initial?.defaultDirectory ?? '',
    );
    _credentialLabelController = TextEditingController(
      text: initial?.credentialRef?.label ?? '',
    );
    _secretController = TextEditingController();
    _browserUrlController = TextEditingController(
      text: initial?.managedAccessConfig.browserUrl ?? '',
    );
    _targetHintController = TextEditingController(
      text: initial?.managedAccessConfig.targetHint ?? '',
    );
    _authMethod = initial?.authMethod ?? AuthMethod.privateKey;
    _networkMode = initial?.networkMode ?? NetworkMode.direct;
    _themePreset = initial?.terminalTheme ?? TerminalThemePreset.midnight;
    _requiresBiometric = initial?.credentialRef?.requiresBiometric ?? false;
    _selectedHopIds = [...initial?.jumpRoute.hopProfileIds ?? const []];
    _forwardDrafts = (initial?.portForwards ?? const [])
        .map(_PortForwardDraft.fromProfile)
        .toList();
    _availableKeys = [...widget.availableKeys];
    _selectedKeyId = initial?.authMethod == AuthMethod.privateKey
        ? initial?.credentialRef?.id
        : null;
  }

  @override
  void dispose() {
    _labelController.dispose();
    _hostController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _tagsController.dispose();
    _defaultDirectoryController.dispose();
    _credentialLabelController.dispose();
    _secretController.dispose();
    _browserUrlController.dispose();
    _targetHintController.dispose();
    for (final draft in _forwardDrafts) {
      draft.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentProfileId = widget.initialProfile?.id;
    final jumpCandidates = widget.availableProfiles
        .where((profile) => profile.id != currentProfileId)
        .toList(growable: false);

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
                widget.initialProfile == null ? 'Add Server' : 'Edit Server',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Profiles stay local, credentials go into secure storage, and jump routes can reuse your saved servers.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              _Section(
                title: 'Identity',
                child: Column(
                  children: [
                    TextField(
                      controller: _labelController,
                      decoration: const InputDecoration(
                        labelText: 'Display name',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: _hostController,
                            decoration: const InputDecoration(
                              labelText: 'Host',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _portController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Port',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(labelText: 'Username'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _tagsController,
                      decoration: const InputDecoration(
                        labelText: 'Tags',
                        hintText: 'prod, jump, tailscale',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _defaultDirectoryController,
                      decoration: const InputDecoration(
                        labelText: 'Default directory',
                        hintText: '/home/user',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _Section(
                title: 'Access',
                child: Column(
                  children: [
                    DropdownButtonFormField<AuthMethod>(
                      initialValue: _authMethod,
                      decoration: const InputDecoration(
                        labelText: 'Auth method',
                      ),
                      items: AuthMethod.values
                          .map(
                            (method) => DropdownMenuItem(
                              value: method,
                              child: Text(method.name),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() => _authMethod = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<NetworkMode>(
                      initialValue: _networkMode,
                      decoration: const InputDecoration(
                        labelText: 'Network mode',
                      ),
                      items: NetworkMode.values
                          .map(
                            (mode) => DropdownMenuItem(
                              value: mode,
                              child: Text(mode.name),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() => _networkMode = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<TerminalThemePreset>(
                      initialValue: _themePreset,
                      decoration: const InputDecoration(
                        labelText: 'Terminal theme',
                      ),
                      items: TerminalThemePreset.values
                          .map(
                            (preset) => DropdownMenuItem(
                              value: preset,
                              child: Text(preset.name),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() => _themePreset = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    if (_authMethod == AuthMethod.privateKey) ...[
                      DropdownButtonFormField<String>(
                        initialValue: _selectedKeyId,
                        decoration: const InputDecoration(
                          labelText: 'Saved key',
                        ),
                        items: _availableKeys
                            .map(
                              (key) => DropdownMenuItem(
                                value: key.id,
                                child: Text(
                                  '${key.label} (${key.id.substring(0, 8)})',
                                ),
                              ),
                            )
                            .toList(growable: false),
                        onChanged: (value) {
                          setState(() {
                            _selectedKeyId = value;
                            final selected = _selectedKey;
                            _requiresBiometric =
                                selected?.requiresBiometric ??
                                _requiresBiometric;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _selectedKey == null
                              ? 'Pick a saved key, or create one now and reuse it by ID across servers.'
                              : 'Selected key ID: ${_selectedKey!.id}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          FilledButton.tonalIcon(
                            onPressed: _createOrImportKey,
                            icon: const Icon(Icons.key_outlined),
                            label: const Text('Create or Import Key'),
                          ),
                          const SizedBox(width: 12),
                          if (_selectedKey != null)
                            OutlinedButton.icon(
                              onPressed: () {
                                setState(() => _selectedKeyId = null);
                              },
                              icon: const Icon(Icons.clear),
                              label: const Text('Clear'),
                            ),
                        ],
                      ),
                    ] else ...[
                      TextField(
                        controller: _credentialLabelController,
                        decoration: const InputDecoration(
                          labelText: 'Credential label',
                          hintText: 'Prod password or OTP fallback',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _secretController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: switch (_authMethod) {
                            AuthMethod.password => 'Password',
                            AuthMethod.privateKey => 'Private key (PEM)',
                            AuthMethod.keyboardInteractive =>
                              'Default interactive response',
                          },
                        ),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: _requiresBiometric,
                        title: const Text('Require biometric unlock'),
                        onChanged: (value) {
                          setState(() => _requiresBiometric = value);
                        },
                      ),
                    ],
                    const SizedBox(height: 12),
                    TextField(
                      controller: _browserUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Browser fallback URL',
                        hintText:
                            'Required for Cloudflare/Tailscale browser flows',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _targetHintController,
                      decoration: const InputDecoration(
                        labelText: 'Target hint',
                        hintText: 'Shown in the managed-access banner',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _Section(
                title: 'ProxyJump',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _selectedHopIds
                          .map(
                            (hopId) => InputChip(
                              label: Text(
                                widget.availableProfiles
                                    .firstWhere(
                                      (profile) => profile.id == hopId,
                                    )
                                    .label,
                              ),
                              onDeleted: () {
                                setState(() => _selectedHopIds.remove(hopId));
                              },
                            ),
                          )
                          .toList(growable: false),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _pendingHopId,
                      decoration: const InputDecoration(
                        labelText: 'Add jump profile',
                      ),
                      items: jumpCandidates
                          .where(
                            (profile) => !_selectedHopIds.contains(profile.id),
                          )
                          .map(
                            (profile) => DropdownMenuItem(
                              value: profile.id,
                              child: Text(profile.label),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _selectedHopIds.add(value);
                          _pendingHopId = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _Section(
                title: 'Port Forwards',
                child: Column(
                  children: [
                    for (final draft in _forwardDrafts) ...[
                      _PortForwardEditor(
                        draft: draft,
                        onRemove: () {
                          setState(() {
                            draft.dispose();
                            _forwardDrafts.remove(draft);
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                    Align(
                      alignment: Alignment.centerLeft,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(
                            () => _forwardDrafts.add(_PortForwardDraft.empty()),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add forward'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const Spacer(),
                  FilledButton(onPressed: _save, child: const Text('Save')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    final label = _labelController.text.trim();
    final host = _hostController.text.trim();
    final username = _usernameController.text.trim();
    final port = int.tryParse(_portController.text.trim()) ?? 22;

    final issues = ServerProfileValidator.validateDraft(
      label: label,
      host: host,
      username: username,
      port: port,
      networkMode: _networkMode,
      browserUrl: _browserUrlController.text.trim(),
    );
    if (issues.isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(issues.first)));
      return;
    }

    final initial = widget.initialProfile;
    final initialCredential = initial?.credentialRef;
    final nativeCredentialIssue = _validateCredentialChoice(initialCredential);
    if (nativeCredentialIssue != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(nativeCredentialIssue)));
      return;
    }

    final credentialRef = switch (_authMethod) {
      AuthMethod.privateKey => _selectedKey,
      AuthMethod.password || AuthMethod.keyboardInteractive =>
        _passwordCredentialFor(initialCredential, label),
    };

    final preflightRequirements = switch (_networkMode) {
      NetworkMode.direct => const [PreflightRequirement.knownHostReview],
      NetworkMode.tailscaleNetwork => const [
        PreflightRequirement.tailscaleClient,
        PreflightRequirement.knownHostReview,
      ],
      NetworkMode.tailscaleConsole => const [
        PreflightRequirement.tailscaleClient,
        PreflightRequirement.browserSignIn,
      ],
      NetworkMode.cloudflareWarp => const [
        PreflightRequirement.warpClient,
        PreflightRequirement.knownHostReview,
      ],
      NetworkMode.cloudflareBrowser => const [
        PreflightRequirement.warpClient,
        PreflightRequirement.browserSignIn,
      ],
    };

    final profileId = initial?.id ?? _uuid.v4();
    final profile = ServerProfile(
      id: profileId,
      label: label,
      host: host,
      port: port,
      username: username,
      tags: _tagsController.text
          .split(',')
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList(growable: false),
      defaultDirectory: _defaultDirectoryController.text.trim().isEmpty
          ? null
          : _defaultDirectoryController.text.trim(),
      terminalTheme: _themePreset,
      authMethod: _authMethod,
      credentialRef: credentialRef,
      networkMode: _networkMode,
      managedAccessConfig: ManagedAccessConfig(
        mode: _networkMode,
        browserUrl: _browserUrlController.text.trim().isEmpty
            ? null
            : _browserUrlController.text.trim(),
        targetHint: _targetHintController.text.trim().isEmpty
            ? null
            : _targetHintController.text.trim(),
        preflightRequirements: preflightRequirements,
      ),
      jumpRoute: JumpRoute(
        profileId: profileId,
        hopProfileIds: List.unmodifiable(_selectedHopIds),
      ),
      portForwards: _forwardDrafts
          .map((draft) => draft.toProfile(profileId))
          .whereType<PortForwardProfile>()
          .toList(growable: false),
    );

    Navigator.of(context).pop(
      ServerEditorResult(
        profile: profile,
        primarySecret: _secretController.text.trim().isEmpty
            ? null
            : _secretController.text.trim(),
        savedKeys: List.unmodifiable(_createdKeys),
      ),
    );
  }

  CredentialRef? get _selectedKey => _availableKeys
      .cast<CredentialRef?>()
      .firstWhere((key) => key?.id == _selectedKeyId, orElse: () => null);

  CredentialRef? _passwordCredentialFor(
    CredentialRef? initialCredential,
    String profileLabel,
  ) {
    final initialIsReusable =
        initialCredential != null &&
        initialCredential.kind != CredentialKind.privateKey;
    final hasContent =
        _credentialLabelController.text.trim().isNotEmpty ||
        _secretController.text.trim().isNotEmpty ||
        initialIsReusable;
    if (!hasContent) {
      return null;
    }

    final credentialLabel = _credentialLabelController.text.trim().isEmpty
        ? initialCredential?.label ?? '$profileLabel credentials'
        : _credentialLabelController.text.trim();

    if (initialIsReusable) {
      return initialCredential.copyWith(
        label: credentialLabel,
        kind: CredentialKind.password,
        requiresBiometric: _requiresBiometric,
        isEncrypted: false,
      );
    }

    return CredentialRef(
      id: _uuid.v4(),
      label: credentialLabel,
      kind: CredentialKind.password,
      requiresBiometric: _requiresBiometric,
      isEncrypted: false,
    );
  }

  String? _validateCredentialChoice(CredentialRef? initialCredential) {
    if (_authMethod == AuthMethod.privateKey && _selectedKeyId == null) {
      return 'Select a saved key before using private-key authentication.';
    }

    if (_authMethod != AuthMethod.privateKey) {
      final hasExistingCredential =
          initialCredential != null &&
          initialCredential.kind != CredentialKind.privateKey;
      final hasNewSecret = _secretController.text.trim().isNotEmpty;
      if (!hasExistingCredential && !hasNewSecret) {
        return _authMethod == AuthMethod.password
            ? 'Enter a password for this server.'
            : 'Enter a default interactive response for this server.';
      }
    }

    return null;
  }

  Future<void> _createOrImportKey() async {
    final material = await showModalBottomSheet<SavedKeyMaterial>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) =>
          SavedKeyEditorSheet(sshKeyService: widget.sshKeyService),
    );
    if (material == null) {
      return;
    }

    setState(() {
      _createdKeys.add(material);
      _availableKeys.removeWhere((key) => key.id == material.credential.id);
      _availableKeys.add(material.credential);
      _availableKeys.sort((a, b) => a.label.compareTo(b.label));
      _selectedKeyId = material.credential.id;
      _requiresBiometric = material.credential.requiresBiometric;
    });
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _PortForwardDraft {
  _PortForwardDraft({
    required this.id,
    required this.kind,
    required this.labelController,
    required this.bindHostController,
    required this.bindPortController,
    required this.targetHostController,
    required this.targetPortController,
    required this.autoStart,
  });

  factory _PortForwardDraft.empty() {
    return _PortForwardDraft(
      id: const Uuid().v4(),
      kind: PortForwardKind.local,
      labelController: TextEditingController(),
      bindHostController: TextEditingController(text: '127.0.0.1'),
      bindPortController: TextEditingController(),
      targetHostController: TextEditingController(),
      targetPortController: TextEditingController(),
      autoStart: false,
    );
  }

  factory _PortForwardDraft.fromProfile(PortForwardProfile profile) {
    return _PortForwardDraft(
      id: profile.id,
      kind: profile.kind,
      labelController: TextEditingController(text: profile.label ?? ''),
      bindHostController: TextEditingController(text: profile.bindHost),
      bindPortController: TextEditingController(text: '${profile.bindPort}'),
      targetHostController: TextEditingController(text: profile.targetHost),
      targetPortController: TextEditingController(
        text: '${profile.targetPort}',
      ),
      autoStart: profile.autoStart,
    );
  }

  final String id;
  PortForwardKind kind;
  final TextEditingController labelController;
  final TextEditingController bindHostController;
  final TextEditingController bindPortController;
  final TextEditingController targetHostController;
  final TextEditingController targetPortController;
  bool autoStart;

  PortForwardProfile? toProfile(String profileId) {
    final bindPort = int.tryParse(bindPortController.text.trim());
    final targetPort = int.tryParse(targetPortController.text.trim());
    final bindHost = bindHostController.text.trim();
    final targetHost = targetHostController.text.trim();
    if (bindPort == null ||
        targetPort == null ||
        bindHost.isEmpty ||
        targetHost.isEmpty) {
      return null;
    }
    return PortForwardProfile(
      id: id,
      profileId: profileId,
      kind: kind,
      bindHost: bindHost,
      bindPort: bindPort,
      targetHost: targetHost,
      targetPort: targetPort,
      autoStart: autoStart,
      label: labelController.text.trim().isEmpty
          ? null
          : labelController.text.trim(),
    );
  }

  void dispose() {
    labelController.dispose();
    bindHostController.dispose();
    bindPortController.dispose();
    targetHostController.dispose();
    targetPortController.dispose();
  }
}

class _PortForwardEditor extends StatefulWidget {
  const _PortForwardEditor({required this.draft, required this.onRemove});

  final _PortForwardDraft draft;
  final VoidCallback onRemove;

  @override
  State<_PortForwardEditor> createState() => _PortForwardEditorState();
}

class _PortForwardEditorState extends State<_PortForwardEditor> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<PortForwardKind>(
                    initialValue: widget.draft.kind,
                    decoration: const InputDecoration(labelText: 'Direction'),
                    items: PortForwardKind.values
                        .map(
                          (kind) => DropdownMenuItem(
                            value: kind,
                            child: Text(kind.name),
                          ),
                        )
                        .toList(growable: false),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() => widget.draft.kind = value);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: widget.onRemove,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: widget.draft.labelController,
              decoration: const InputDecoration(labelText: 'Label'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.draft.bindHostController,
                    decoration: const InputDecoration(labelText: 'Bind host'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: widget.draft.bindPortController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Bind port'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.draft.targetHostController,
                    decoration: const InputDecoration(labelText: 'Target host'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: widget.draft.targetPortController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Target port'),
                  ),
                ),
              ],
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: widget.draft.autoStart,
              title: const Text('Auto-start'),
              onChanged: (value) {
                setState(() => widget.draft.autoStart = value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
