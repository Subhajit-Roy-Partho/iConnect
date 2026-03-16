import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:xterm/xterm.dart';

import '../app/providers.dart';
import '../app/theme.dart';
import '../core/snippet_interpolator.dart';
import '../data/repositories.dart';
import '../services/connection_engine.dart';
import '../services/ssh_key_service.dart';
import '../services/workspace_controller.dart';
import 'saved_key_editor_sheet.dart';
import 'server_editor_sheet.dart';

enum AppSection { servers, sessions, files, snippets, settings }

extension AppSectionX on AppSection {
  String get label => switch (this) {
    AppSection.servers => 'Servers',
    AppSection.sessions => 'Sessions',
    AppSection.files => 'Files',
    AppSection.snippets => 'Snippets',
    AppSection.settings => 'Settings',
  };

  String get path => '/$name';

  IconData get icon => switch (this) {
    AppSection.servers => Icons.dns_outlined,
    AppSection.sessions => Icons.terminal_outlined,
    AppSection.files => Icons.folder_outlined,
    AppSection.snippets => Icons.bolt_outlined,
    AppSection.settings => Icons.tune_outlined,
  };
}

class HomeShell extends ConsumerWidget {
  const HomeShell({super.key, required this.section});

  final AppSection section;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootstrap = ref.watch(appBootstrapProvider);
    final workspace = ref.watch(workspaceControllerProvider);

    return bootstrap.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) =>
          Scaffold(body: Center(child: Text('Bootstrap failed: $error'))),
      data: (_) {
        final terminalFocusMode =
            section == AppSection.sessions &&
            workspace.terminalFocusMode &&
            workspace.activeTab != null;
        final wide = MediaQuery.sizeOf(context).width >= 1100;
        final showInspector = MediaQuery.sizeOf(context).width >= 1420;
        final content = _SectionViewport(
          section: section,
          immersive: terminalFocusMode,
        );

        if (terminalFocusMode) {
          return Scaffold(body: content);
        }

        if (wide) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: section.index,
                  labelType: NavigationRailLabelType.all,
                  onDestinationSelected: (index) {
                    context.go(AppSection.values[index].path);
                  },
                  destinations: [
                    for (final item in AppSection.values)
                      NavigationRailDestination(
                        icon: Icon(item.icon),
                        label: Text(item.label),
                      ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: content),
                if (showInspector) ...[
                  const VerticalDivider(width: 1),
                  const SizedBox(width: 320, child: _InspectorPanel()),
                ],
              ],
            ),
          );
        }

        return Scaffold(
          body: content,
          bottomNavigationBar: NavigationBar(
            selectedIndex: section.index,
            destinations: [
              for (final item in AppSection.values)
                NavigationDestination(icon: Icon(item.icon), label: item.label),
            ],
            onDestinationSelected: (index) {
              context.go(AppSection.values[index].path);
            },
          ),
        );
      },
    );
  }
}

class _SectionViewport extends StatelessWidget {
  const _SectionViewport({required this.section, this.immersive = false});

  final AppSection section;
  final bool immersive;

  @override
  Widget build(BuildContext context) {
    final child = AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: switch (section) {
        AppSection.servers => const _ServersPage(),
        AppSection.sessions => const _SessionsPage(),
        AppSection.files => const _FilesPage(),
        AppSection.snippets => const _SnippetsPage(),
        AppSection.settings => const _SettingsPage(),
      },
    );
    if (immersive) {
      return child;
    }
    return SafeArea(child: child);
  }
}

class _InspectorPanel extends ConsumerWidget {
  const _InspectorPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspace = ref.watch(workspaceControllerProvider);
    final profiles = ref
        .watch(profilesProvider)
        .maybeWhen(
          data: (value) => value,
          orElse: () => const <ServerProfile>[],
        );
    final snippets = ref
        .watch(snippetsProvider)
        .maybeWhen(data: (value) => value, orElse: () => const <Snippet>[]);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Workspace', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          _MetricCard(
            label: 'Saved Servers',
            value: '${profiles.length}',
            subtitle: 'Direct, Tailscale, WARP, and browser-backed profiles.',
          ),
          const SizedBox(height: 12),
          _MetricCard(
            label: 'Open Sessions',
            value: '${workspace.tabs.length}',
            subtitle: workspace.activeTab == null
                ? 'No active terminal right now.'
                : 'Active: ${workspace.activeTab!.profile.label}',
          ),
          const SizedBox(height: 12),
          _MetricCard(
            label: 'Snippets',
            value: '${snippets.length}',
            subtitle: 'Saved commands ready to send into the active terminal.',
          ),
          const SizedBox(height: 24),
          Text('Focus', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          Text(
            workspace.activeTab?.message ??
                'Hybrid access is enabled: native SSH where possible, browser handoff where required.',
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.subtitle,
  });

  final String label;
  final String value;
  final String subtitle;

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
            Text(label, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 10),
            Text(value, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(subtitle),
          ],
        ),
      ),
    );
  }
}

class _ServersPage extends ConsumerWidget {
  const _ServersPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilesAsync = ref.watch(profilesProvider);
    final savedKeysAsync = ref.watch(savedKeysProvider);

    return profilesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) =>
          Center(child: Text('Failed to load profiles: $error')),
      data: (profiles) => savedKeysAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Failed to load keys: $error')),
        data: (savedKeys) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _PageHeader(
                  title: 'Servers',
                  subtitle:
                      'Saved hosts, ProxyJump routes, managed-access hints, and reusable SSH key IDs.',
                  action: FilledButton.icon(
                    onPressed: () => _openEditor(
                      context,
                      ref,
                      profiles,
                      savedKeys: savedKeys,
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Server'),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    itemCount: profiles.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final profile = profiles[index];
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          profile.label,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleLarge,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${profile.username}@${profile.host}:${profile.port}',
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    onSelected: (value) async {
                                      switch (value) {
                                        case 'edit':
                                          await _openEditor(
                                            context,
                                            ref,
                                            profiles,
                                            savedKeys: savedKeys,
                                            initial: profile,
                                          );
                                        case 'delete':
                                          await _deleteProfile(
                                            context,
                                            ref,
                                            profile,
                                          );
                                      }
                                    },
                                    itemBuilder: (context) => const [
                                      PopupMenuItem(
                                        value: 'edit',
                                        child: Text('Edit'),
                                      ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _Badge(label: profile.networkMode.name),
                                  _Badge(label: profile.authMethod.name),
                                  if (profile.authMethod ==
                                          AuthMethod.privateKey &&
                                      profile.credentialRef != null)
                                    _Badge(
                                      label:
                                          'Key ${profile.credentialRef!.label} (${profile.credentialRef!.id.substring(0, 8)})',
                                    ),
                                  if (profile
                                      .jumpRoute
                                      .hopProfileIds
                                      .isNotEmpty)
                                    _Badge(
                                      label:
                                          'ProxyJump ${profile.jumpRoute.hopProfileIds.length}',
                                    ),
                                  for (final tag in profile.tags)
                                    _Badge(label: tag),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  FilledButton.icon(
                                    onPressed: () async {
                                      await ref
                                          .read(
                                            workspaceControllerProvider
                                                .notifier,
                                          )
                                          .connectProfile(
                                            profile,
                                            hostTrustDelegate:
                                                _MaterialHostTrustDelegate(
                                                  context,
                                                ),
                                          );
                                      if (context.mounted) {
                                        context.go(AppSection.sessions.path);
                                      }
                                    },
                                    icon: const Icon(Icons.terminal),
                                    label: const Text('Connect'),
                                  ),
                                  const SizedBox(width: 12),
                                  OutlinedButton.icon(
                                    onPressed: () => _openEditor(
                                      context,
                                      ref,
                                      profiles,
                                      savedKeys: savedKeys,
                                      initial: profile,
                                    ),
                                    icon: const Icon(Icons.edit_outlined),
                                    label: const Text('Edit'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _openEditor(
    BuildContext context,
    WidgetRef ref,
    List<ServerProfile> profiles, {
    required List<CredentialRef> savedKeys,
    ServerProfile? initial,
  }) async {
    final result = await showModalBottomSheet<ServerEditorResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => ServerEditorSheet(
        initialProfile: initial,
        availableProfiles: profiles,
        availableKeys: savedKeys,
        sshKeyService: ref.read(sshKeyServiceProvider),
      ),
    );

    if (result == null) {
      return;
    }

    for (final savedKey in result.savedKeys) {
      await ref.read(appRepositoryProvider).saveCredential(savedKey.credential);
      await ref
          .read(secureStorageProvider)
          .persistCredential(
            savedKey.credential,
            primarySecret: savedKey.privateKeyPem,
            publicKey: savedKey.publicKey,
            passphrase: savedKey.passphrase,
          );
    }

    await ref.read(appRepositoryProvider).saveProfile(result.profile);

    final credential = result.profile.credentialRef;
    if (credential != null &&
        (result.primarySecret != null || result.passphrase != null)) {
      await ref
          .read(secureStorageProvider)
          .persistCredential(
            credential,
            primarySecret: result.primarySecret,
            passphrase: result.passphrase,
          );
    }

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Saved ${result.profile.label}')));
    }
  }

  Future<void> _deleteProfile(
    BuildContext context,
    WidgetRef ref,
    ServerProfile profile,
  ) async {
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete server?'),
            content: Text('Remove ${profile.label} and its local metadata?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) {
      return;
    }

    await ref.read(appRepositoryProvider).deleteProfile(profile);

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Deleted ${profile.label}')));
    }
  }
}

class _SessionsPage extends ConsumerWidget {
  const _SessionsPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspace = ref.watch(workspaceControllerProvider);
    final preferences = ref.watch(appPreferencesProvider);
    final focusMode =
        workspace.terminalFocusMode && workspace.activeTab != null;

    if (focusMode) {
      final activeTab = workspace.activeTab!;
      return Stack(
        children: [
          Positioned.fill(
            child: _TerminalPanel(tab: activeTab, fullscreen: true),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      child: Text(
                        activeTab.profile.label,
                        style: Theme.of(
                          context,
                        ).textTheme.labelLarge?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  const Spacer(),
                  FilledButton.tonalIcon(
                    onPressed: () {
                      ref
                          .read(workspaceControllerProvider.notifier)
                          .toggleTerminalFocusMode(false);
                    },
                    icon: const Icon(Icons.fullscreen_exit),
                    label: const Text('Exit Full Screen'),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _PageHeader(
            title: 'Sessions',
            subtitle:
                'Terminal tabs, hybrid managed-access handoff, and iPad-ready split view.',
            action: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Toggle split view',
                  onPressed: workspace.tabs.length < 2
                      ? null
                      : () {
                          ref
                              .read(workspaceControllerProvider.notifier)
                              .toggleSplitView();
                        },
                  icon: Icon(
                    workspace.splitViewEnabled
                        ? Icons.splitscreen
                        : Icons.crop_square_outlined,
                  ),
                ),
                IconButton(
                  tooltip: 'Make terminal full screen',
                  onPressed: workspace.activeTab == null
                      ? null
                      : () {
                          ref
                              .read(workspaceControllerProvider.notifier)
                              .toggleTerminalFocusMode(true);
                        },
                  icon: const Icon(Icons.fullscreen),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (workspace.tabs.isEmpty)
            Expanded(
              child: _EmptyState(
                title: 'No active sessions',
                subtitle:
                    'Connect to a saved server to open a terminal tab and start browsing files.',
              ),
            )
          else ...[
            SizedBox(
              height: 54,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: workspace.tabs.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final tab = workspace.tabs[index];
                  final active = tab.id == workspace.activeTabId;
                  return FilterChip(
                    selected: active,
                    avatar: Icon(switch (tab.status) {
                      WorkspaceTabStatus.connecting => Icons.sync,
                      WorkspaceTabStatus.connected => Icons.terminal,
                      WorkspaceTabStatus.browserFallback =>
                        Icons.open_in_browser,
                      WorkspaceTabStatus.error => Icons.warning_amber_rounded,
                    }, size: 18),
                    label: Text(tab.profile.label),
                    onSelected: (_) {
                      ref
                          .read(workspaceControllerProvider.notifier)
                          .selectTab(tab.id);
                    },
                    deleteIcon: const Icon(Icons.close),
                    onDeleted: () {
                      ref
                          .read(workspaceControllerProvider.notifier)
                          .closeTab(tab.id);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final showSplit =
                      preferences.splitSessions &&
                      workspace.splitViewEnabled &&
                      constraints.maxWidth >= 1200 &&
                      workspace.tabs.length >= 2;

                  final activeTab = workspace.activeTab ?? workspace.tabs.last;
                  final secondaryTab = showSplit
                      ? workspace.tabs.firstWhere(
                          (tab) => tab.id != activeTab.id,
                          orElse: () => activeTab,
                        )
                      : null;

                  return Row(
                    children: [
                      Expanded(child: _TerminalPanel(tab: activeTab)),
                      if (showSplit && secondaryTab != null) ...[
                        const SizedBox(width: 16),
                        Expanded(child: _TerminalPanel(tab: secondaryTab)),
                      ],
                    ],
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TerminalPanel extends StatelessWidget {
  const _TerminalPanel({required this.tab, this.fullscreen = false});

  final WorkspaceTab tab;
  final bool fullscreen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final terminalBody = switch (tab.status) {
      WorkspaceTabStatus.browserFallback => _BrowserFallbackView(tab: tab),
      _ => TerminalView(
        tab.terminal,
        theme:
            tab.session?.terminalTheme ??
            terminalThemes[tab.profile.terminalTheme]!,
        backgroundOpacity: 1,
        deleteDetection: true,
      ),
    };

    if (fullscreen) {
      return ColoredBox(
        color: tab.session?.terminalTheme.background ?? Colors.black,
        child: terminalBody,
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tab.profile.label, style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              tab.message ?? tab.profile.managedAccessConfig.targetHint ?? '',
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: terminalBody,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrowserFallbackView extends ConsumerWidget {
  const _BrowserFallbackView({required this.tab});

  final WorkspaceTab tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Managed access opened in browser',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(tab.message ?? tab.browserIntent?.reason ?? ''),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: tab.browserIntent == null
                ? null
                : () async {
                    final opened = await ref
                        .read(connectionEngineProvider)
                        .openBrowser(tab.browserIntent!);
                    if (context.mounted && !opened) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Unable to open the browser.'),
                        ),
                      );
                    }
                  },
            icon: const Icon(Icons.open_in_browser),
            label: const Text('Open Again'),
          ),
        ],
      ),
    );
  }
}

class _FilesPage extends ConsumerStatefulWidget {
  const _FilesPage();

  @override
  ConsumerState<_FilesPage> createState() => _FilesPageState();
}

class _FilesPageState extends ConsumerState<_FilesPage> {
  ConnectedSession? _session;
  String _currentPath = '.';
  bool _loading = false;
  Object? _error;
  List<RemoteFileEntry> _entries = const [];

  @override
  Widget build(BuildContext context) {
    final activeSession = ref
        .watch(workspaceControllerProvider)
        .activeTab
        ?.session;
    if (!identical(activeSession, _session)) {
      _session = activeSession;
      _currentPath = activeSession?.startingDirectory ?? '.';
      unawaited(_refresh());
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _PageHeader(
            title: 'Files',
            subtitle:
                'Basic SFTP browser with preview, create, rename, delete, upload, and download.',
            action: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: _session == null ? null : () => _refresh(),
                  icon: const Icon(Icons.refresh),
                ),
                IconButton(
                  onPressed: _session == null ? null : _goUp,
                  icon: const Icon(Icons.arrow_upward),
                ),
                FilledButton.icon(
                  onPressed: _session == null ? null : _promptCreateDirectory,
                  icon: const Icon(Icons.create_new_folder_outlined),
                  label: const Text('New Folder'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: _session == null
                      ? null
                      : _uploadIntoCurrentDirectory,
                  icon: const Icon(Icons.upload_file_outlined),
                  label: const Text('Upload'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _session == null ? 'No active SSH session' : _currentPath,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(28),
              ),
              child: _session == null
                  ? const _EmptyState(
                      title: 'Connect first',
                      subtitle:
                          'The file manager follows the active native SSH session.',
                    )
                  : _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? Center(child: Text('Failed to load directory: $_error'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: _entries.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final entry = _entries[index];
                        return ListTile(
                          tileColor: Theme.of(context).colorScheme.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          leading: Icon(
                            entry.isDirectory
                                ? Icons.folder_outlined
                                : entry.isSymbolicLink
                                ? Icons.shortcut_outlined
                                : Icons.description_outlined,
                          ),
                          title: Text(entry.name),
                          subtitle: Text(
                            entry.isDirectory
                                ? 'Directory'
                                : '${entry.size ?? 0} bytes',
                          ),
                          onTap: () async {
                            if (entry.isDirectory) {
                              setState(() => _currentPath = entry.path);
                              await _refresh();
                              return;
                            }
                            await _preview(entry);
                          },
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) async {
                              switch (value) {
                                case 'preview':
                                  await _preview(entry);
                                case 'rename':
                                  await _rename(entry);
                                case 'delete':
                                  await _delete(entry);
                                case 'download':
                                  await _download(entry);
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: 'preview',
                                child: Text('Preview'),
                              ),
                              PopupMenuItem(
                                value: 'rename',
                                child: Text('Rename'),
                              ),
                              PopupMenuItem(
                                value: 'download',
                                child: Text('Download'),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refresh() async {
    final session = _session;
    if (session == null) {
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final normalized = await session.resolveDirectory(_currentPath);
      final entries = await session.listDirectory(normalized);
      if (!mounted) {
        return;
      }
      setState(() {
        _currentPath = normalized;
        _entries = entries;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = error;
        _loading = false;
      });
    }
  }

  Future<void> _goUp() async {
    if (_session == null) {
      return;
    }
    if (_currentPath == '/') {
      return;
    }
    final segments = _currentPath
        .split('/')
        .where((segment) => segment.isNotEmpty)
        .toList();
    if (segments.isNotEmpty) {
      segments.removeLast();
    }
    _currentPath = segments.isEmpty ? '/' : '/${segments.join('/')}';
    await _refresh();
  }

  Future<void> _promptCreateDirectory() async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create directory'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Directory name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Create'),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty || _session == null) {
      return;
    }
    await _session!.createDirectory('$_currentPath/$name');
    await _refresh();
  }

  Future<void> _uploadIntoCurrentDirectory() async {
    if (_session == null) {
      return;
    }
    await _session!.uploadIntoDirectory(_currentPath);
    await _refresh();
  }

  Future<void> _rename(RemoteFileEntry entry) async {
    final controller = TextEditingController(text: entry.name);
    final nextName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rename ${entry.name}'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'New name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Rename'),
          ),
        ],
      ),
    );
    if (nextName == null || nextName.isEmpty || _session == null) {
      return;
    }
    final nextPath = _currentPath == '/'
        ? '/$nextName'
        : '$_currentPath/$nextName';
    await _session!.renamePath(entry.path, nextPath);
    await _refresh();
  }

  Future<void> _delete(RemoteFileEntry entry) async {
    if (_session == null) {
      return;
    }
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Delete ${entry.name}?'),
            content: const Text('This action runs on the remote host.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed) {
      return;
    }
    await _session!.deletePath(entry);
    await _refresh();
  }

  Future<void> _download(RemoteFileEntry entry) async {
    if (_session == null) {
      return;
    }
    final file = await _session!.downloadToDocuments(entry);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Downloaded to ${file.path}')));
  }

  Future<void> _preview(RemoteFileEntry entry) async {
    if (_session == null) {
      return;
    }
    final bytes = await _session!.readPreviewBytes(entry.path);
    if (!mounted) {
      return;
    }
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(entry.name),
        content: SizedBox(width: 620, child: _FilePreview(bytes: bytes)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _FilePreview extends StatelessWidget {
  const _FilePreview({required this.bytes});

  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    if (_isImage(bytes)) {
      return InteractiveViewer(child: Image.memory(bytes, fit: BoxFit.contain));
    }

    return SingleChildScrollView(
      child: SelectableText(
        utf8.decode(bytes, allowMalformed: true),
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
      ),
    );
  }

  bool _isImage(Uint8List bytes) {
    if (bytes.length < 4) {
      return false;
    }
    final header = bytes.take(4).toList(growable: false);
    return (header[0] == 0x89 &&
            header[1] == 0x50 &&
            header[2] == 0x4E &&
            header[3] == 0x47) ||
        (header[0] == 0xFF && header[1] == 0xD8);
  }
}

class _SnippetsPage extends ConsumerWidget {
  const _SnippetsPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snippetsAsync = ref.watch(snippetsProvider);

    return snippetsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) =>
          Center(child: Text('Failed to load snippets: $error')),
      data: (snippets) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _PageHeader(
                title: 'Snippets',
                subtitle:
                    'Saved commands, placeholder prompts, and fast terminal insertion.',
                action: FilledButton.icon(
                  onPressed: () => _editSnippet(context, ref),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Snippet'),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: snippets.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final snippet = snippets[index];
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(18),
                        title: Text(snippet.title),
                        subtitle: Text(snippet.shellText),
                        trailing: Wrap(
                          spacing: 8,
                          children: [
                            IconButton(
                              tooltip: 'Run snippet',
                              onPressed: () =>
                                  _runSnippet(context, ref, snippet),
                              icon: const Icon(Icons.play_arrow_outlined),
                            ),
                            IconButton(
                              tooltip: 'Edit snippet',
                              onPressed: () =>
                                  _editSnippet(context, ref, snippet: snippet),
                              icon: const Icon(Icons.edit_outlined),
                            ),
                            IconButton(
                              tooltip: 'Delete snippet',
                              onPressed: () => ref
                                  .read(appRepositoryProvider)
                                  .deleteSnippet(snippet),
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _runSnippet(
    BuildContext context,
    WidgetRef ref,
    Snippet snippet,
  ) async {
    Map<String, String> values = const {};
    if (snippet.placeholders.isNotEmpty) {
      values = await _promptPlaceholderValues(context, snippet);
    }
    final rendered = SnippetInterpolator.render(snippet, values);
    await ref
        .read(workspaceControllerProvider.notifier)
        .runSnippet(snippet.copyWith(shellText: rendered));
    await ref
        .read(appRepositoryProvider)
        .saveSnippet(snippet.copyWith(lastUsedAt: DateTime.now()));
  }

  Future<void> _editSnippet(
    BuildContext context,
    WidgetRef ref, {
    Snippet? snippet,
  }) async {
    final titleController = TextEditingController(text: snippet?.title ?? '');
    final bodyController = TextEditingController(
      text: snippet?.shellText ?? '',
    );
    final placeholdersController = TextEditingController(
      text: snippet?.placeholders.join(', ') ?? '',
    );
    final workingDirectoryController = TextEditingController(
      text: snippet?.workingDirectoryHint ?? '',
    );
    var favorite = snippet?.isFavorite ?? false;

    final saved =
        await showDialog<bool>(
          context: context,
          builder: (context) => StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              title: Text(snippet == null ? 'Add snippet' : 'Edit snippet'),
              content: SizedBox(
                width: 560,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: bodyController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: 'Shell text',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: placeholdersController,
                        decoration: const InputDecoration(
                          labelText: 'Placeholders',
                          hintText: 'service, filename',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: workingDirectoryController,
                        decoration: const InputDecoration(
                          labelText: 'Working directory hint',
                        ),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: favorite,
                        title: const Text('Favorite'),
                        onChanged: (value) => setState(() => favorite = value),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ) ??
        false;

    if (!saved) {
      return;
    }

    await ref
        .read(appRepositoryProvider)
        .saveSnippet(
          Snippet(
            id: snippet?.id ?? UniqueKey().toString(),
            title: titleController.text.trim(),
            shellText: bodyController.text.trim(),
            placeholders: placeholdersController.text
                .split(',')
                .map((item) => item.trim())
                .where((item) => item.isNotEmpty)
                .toList(growable: false),
            workingDirectoryHint: workingDirectoryController.text.trim().isEmpty
                ? null
                : workingDirectoryController.text.trim(),
            isFavorite: favorite,
            lastUsedAt: snippet?.lastUsedAt,
          ),
        );
  }

  Future<Map<String, String>> _promptPlaceholderValues(
    BuildContext context,
    Snippet snippet,
  ) async {
    final controllers = {
      for (final placeholder in snippet.placeholders)
        placeholder: TextEditingController(),
    };

    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Fill ${snippet.title}'),
            content: SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final entry in controllers.entries) ...[
                    TextField(
                      controller: entry.value,
                      decoration: InputDecoration(labelText: entry.key),
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Run'),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) {
      return {};
    }

    return {
      for (final entry in controllers.entries)
        entry.key: entry.value.text.trim(),
    };
  }
}

class _SettingsPage extends ConsumerWidget {
  const _SettingsPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(appPreferencesProvider);
    final profilesAsync = ref.watch(profilesProvider);
    final savedKeysAsync = ref.watch(savedKeysProvider);
    final knownHostsAsync = ref.watch(knownHostsProvider);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const _PageHeader(
            title: 'Settings',
            subtitle:
                'Theme, split workspace behavior, and the local known-hosts trust store.',
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Appearance',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 14),
                        SegmentedButton<ThemeMode>(
                          segments: const [
                            ButtonSegment(
                              value: ThemeMode.system,
                              label: Text('System'),
                            ),
                            ButtonSegment(
                              value: ThemeMode.light,
                              label: Text('Light'),
                            ),
                            ButtonSegment(
                              value: ThemeMode.dark,
                              label: Text('Dark'),
                            ),
                          ],
                          selected: {preferences.themeMode},
                          onSelectionChanged: (selection) {
                            ref
                                .read(appPreferencesProvider.notifier)
                                .setThemeMode(selection.first);
                          },
                        ),
                        const SizedBox(height: 18),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          value: preferences.splitSessions,
                          title: const Text('Enable split session layouts'),
                          onChanged: (value) {
                            ref
                                .read(appPreferencesProvider.notifier)
                                .setSplitSessions(value);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Saved Keys',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Create or import reusable SSH keys, then attach them to servers by ID.',
                                  ),
                                ],
                              ),
                            ),
                            FilledButton.icon(
                              onPressed: () => _addSavedKey(context, ref),
                              icon: const Icon(Icons.add),
                              label: const Text('Add Key'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        profilesAsync.when(
                          loading: () => const CircularProgressIndicator(),
                          error: (error, _) => Text('$error'),
                          data: (profiles) => savedKeysAsync.when(
                            loading: () => const CircularProgressIndicator(),
                            error: (error, _) => Text('$error'),
                            data: (keys) {
                              if (keys.isEmpty) {
                                return const Text(
                                  'No saved SSH keys yet. Generate or import one here, then select it from a server profile.',
                                );
                              }
                              return Column(
                                children: [
                                  for (final key in keys) ...[
                                    FutureBuilder<String?>(
                                      future: ref
                                          .read(secureStorageProvider)
                                          .readPublicKey(key.id),
                                      builder: (context, snapshot) {
                                        final usageCount = profiles
                                            .where(
                                              (profile) =>
                                                  profile.credentialRef?.id ==
                                                  key.id,
                                            )
                                            .length;
                                        return ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(key.label),
                                          subtitle: Text(
                                            [
                                              'ID: ${key.id}',
                                              if (key.publicKeyFingerprint !=
                                                  null)
                                                key.publicKeyFingerprint!,
                                              'Used by $usageCount server${usageCount == 1 ? '' : 's'}',
                                            ].join('\n'),
                                          ),
                                          trailing: Wrap(
                                            spacing: 8,
                                            children: [
                                              IconButton(
                                                tooltip: 'Copy key ID',
                                                onPressed: () async {
                                                  await Clipboard.setData(
                                                    ClipboardData(text: key.id),
                                                  );
                                                  if (context.mounted) {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          'Copied key ID for ${key.label}',
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                                icon: const Icon(
                                                  Icons.badge_outlined,
                                                ),
                                              ),
                                              IconButton(
                                                tooltip: 'Copy public key',
                                                onPressed: snapshot.data == null
                                                    ? null
                                                    : () => _copyPublicKey(
                                                        context,
                                                        snapshot.data!,
                                                        key.label,
                                                      ),
                                                icon: const Icon(
                                                  Icons.content_copy,
                                                ),
                                              ),
                                              IconButton(
                                                tooltip: 'Delete key',
                                                onPressed: usageCount > 0
                                                    ? null
                                                    : () => _deleteSavedKey(
                                                        context,
                                                        ref,
                                                        key,
                                                      ),
                                                icon: const Icon(
                                                  Icons.delete_outline,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                    const Divider(),
                                  ],
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Known Hosts',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 14),
                        knownHostsAsync.when(
                          loading: () => const CircularProgressIndicator(),
                          error: (error, _) => Text('$error'),
                          data: (entries) {
                            if (entries.isEmpty) {
                              return const Text(
                                'Host fingerprints you approve will appear here.',
                              );
                            }
                            return Column(
                              children: [
                                for (final entry in entries) ...[
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text('${entry.host}:${entry.port}'),
                                    subtitle: Text(
                                      '${entry.keyType}\n${entry.fingerprintHex}',
                                    ),
                                    trailing: IconButton(
                                      onPressed: () {
                                        ref
                                            .read(appRepositoryProvider)
                                            .deleteKnownHost(entry);
                                      },
                                      icon: const Icon(Icons.delete_outline),
                                    ),
                                  ),
                                  const Divider(),
                                ],
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addSavedKey(BuildContext context, WidgetRef ref) async {
    final material = await showModalBottomSheet<SavedKeyMaterial>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) =>
          SavedKeyEditorSheet(sshKeyService: ref.read(sshKeyServiceProvider)),
    );
    if (material == null) {
      return;
    }

    await ref.read(appRepositoryProvider).saveCredential(material.credential);
    await ref
        .read(secureStorageProvider)
        .persistCredential(
          material.credential,
          primarySecret: material.privateKeyPem,
          publicKey: material.publicKey,
          passphrase: material.passphrase,
        );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Saved ${material.credential.label} as ${material.credential.id}',
          ),
        ),
      );
    }
  }

  Future<void> _copyPublicKey(
    BuildContext context,
    String publicKey,
    String label,
  ) async {
    await Clipboard.setData(ClipboardData(text: publicKey));
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Copied public key for $label')));
    }
  }

  Future<void> _deleteSavedKey(
    BuildContext context,
    WidgetRef ref,
    CredentialRef key,
  ) async {
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete saved key?'),
            content: Text(
              'Remove ${key.label} and delete its stored key material?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed) {
      return;
    }

    await ref.read(appRepositoryProvider).deleteCredentialRef(key.id);
    await ref.read(secureStorageProvider).deleteCredential(key.id);

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Deleted ${key.label}')));
    }
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.title, required this.subtitle, this.action});

  final String title;
  final String subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text(subtitle),
            ],
          ),
        ),
        if (action != null) ...[const SizedBox(width: 12), action!],
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(label),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(subtitle, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _MaterialHostTrustDelegate implements HostTrustDelegate {
  const _MaterialHostTrustDelegate(this.context);

  final BuildContext context;

  @override
  Future<bool> approveChangedHostKey({
    required String host,
    required int port,
    required String keyType,
    required String existingFingerprint,
    required String newFingerprint,
  }) async {
    return _confirm(
      title: 'Host key changed',
      body:
          '$host:$port sent a new $keyType fingerprint.\n\nOld:\n$existingFingerprint\n\nNew:\n$newFingerprint',
    );
  }

  @override
  Future<bool> approveUnknownHost({
    required String host,
    required int port,
    required String keyType,
    required String fingerprint,
  }) async {
    return _confirm(
      title: 'Trust host?',
      body:
          '$host:$port presented a $keyType fingerprint.\n\n$fingerprint\n\nSave this host key locally?',
    );
  }

  Future<bool> _confirm({required String title, required String body}) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: SelectableText(body),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Reject'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Trust'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
