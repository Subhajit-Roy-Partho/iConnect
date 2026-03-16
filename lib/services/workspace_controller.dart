import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xterm/xterm.dart';

import '../app/providers.dart';
import '../data/repositories.dart';
import 'connection_engine.dart';

enum WorkspaceTabStatus {
  connecting,
  connected,
  browserFallback,
  error,
}

class WorkspaceTab {
  const WorkspaceTab({
    required this.id,
    required this.profile,
    required this.terminal,
    required this.status,
    this.session,
    this.browserIntent,
    this.message,
  });

  final String id;
  final ServerProfile profile;
  final Terminal terminal;
  final WorkspaceTabStatus status;
  final ConnectedSession? session;
  final BrowserLaunchIntent? browserIntent;
  final String? message;

  WorkspaceTab copyWith({
    String? id,
    ServerProfile? profile,
    Terminal? terminal,
    WorkspaceTabStatus? status,
    ConnectedSession? session,
    BrowserLaunchIntent? browserIntent,
    String? message,
    bool clearSession = false,
    bool clearBrowserIntent = false,
  }) {
    return WorkspaceTab(
      id: id ?? this.id,
      profile: profile ?? this.profile,
      terminal: terminal ?? this.terminal,
      status: status ?? this.status,
      session: clearSession ? null : session ?? this.session,
      browserIntent: clearBrowserIntent
          ? null
          : browserIntent ?? this.browserIntent,
      message: message ?? this.message,
    );
  }
}

class WorkspaceState {
  const WorkspaceState({
    this.tabs = const [],
    this.activeTabId,
    this.splitViewEnabled = true,
    this.terminalFocusMode = false,
  });

  final List<WorkspaceTab> tabs;
  final String? activeTabId;
  final bool splitViewEnabled;
  final bool terminalFocusMode;

  WorkspaceTab? get activeTab =>
      tabs.firstWhereOrNull((tab) => tab.id == activeTabId);

  WorkspaceState copyWith({
    List<WorkspaceTab>? tabs,
    String? activeTabId,
    bool? splitViewEnabled,
    bool? terminalFocusMode,
  }) {
    return WorkspaceState(
      tabs: tabs ?? this.tabs,
      activeTabId: activeTabId ?? this.activeTabId,
      splitViewEnabled: splitViewEnabled ?? this.splitViewEnabled,
      terminalFocusMode: terminalFocusMode ?? this.terminalFocusMode,
    );
  }
}

class WorkspaceController extends Notifier<WorkspaceState> {
  @override
  WorkspaceState build() => const WorkspaceState();

  Future<void> connectProfile(
    ServerProfile profile, {
    required HostTrustDelegate hostTrustDelegate,
  }) async {
    final existingIndex =
        state.tabs.indexWhere((tab) => tab.profile.id == profile.id);
    if (existingIndex != -1) {
      state = state.copyWith(activeTabId: state.tabs[existingIndex].id);
      return;
    }

    final terminal = Terminal(maxLines: 5000);
    terminal.write('Connecting to ${profile.host}...\r\n');

    final tab = WorkspaceTab(
      id: '${profile.id}-${DateTime.now().microsecondsSinceEpoch}',
      profile: profile,
      terminal: terminal,
      status: WorkspaceTabStatus.connecting,
    );

    state = state.copyWith(
      tabs: [...state.tabs, tab],
      activeTabId: tab.id,
    );

    try {
      final engine = ref.read(connectionEngineProvider);
      final result = await engine.launch(
        profile,
        hostTrustDelegate: hostTrustDelegate,
      );

      switch (result) {
        case NativeSessionLaunchResult(:final session):
          _replaceTab(
            tab.id,
            tab.copyWith(
              terminal: session.terminal,
              status: WorkspaceTabStatus.connected,
              session: session,
            ),
          );
        case BrowserSessionLaunchResult(:final intent):
          final launched = await engine.openBrowser(intent);
          _replaceTab(
            tab.id,
            tab.copyWith(
              status: WorkspaceTabStatus.browserFallback,
              browserIntent: intent,
              message: launched
                  ? 'Opened managed access in your browser.'
                  : 'Unable to launch the browser automatically.',
            ),
          );
      }
    } catch (error) {
      terminal.write('\r\n$error\r\n');
      _replaceTab(
        tab.id,
        tab.copyWith(
          status: WorkspaceTabStatus.error,
          message: error.toString(),
        ),
      );
    }
  }

  Future<void> closeTab(String tabId) async {
    final tab = state.tabs.firstWhereOrNull((entry) => entry.id == tabId);
    if (tab?.session != null) {
      await tab!.session!.close();
    }
    final remaining = state.tabs.where((entry) => entry.id != tabId).toList();
    state = state.copyWith(
      tabs: remaining,
      activeTabId: remaining.isEmpty ? null : remaining.last.id,
      terminalFocusMode: remaining.isEmpty ? false : state.terminalFocusMode,
    );
  }

  void selectTab(String tabId) {
    state = state.copyWith(activeTabId: tabId);
  }

  void toggleSplitView([bool? enabled]) {
    state = state.copyWith(
      splitViewEnabled: enabled ?? !state.splitViewEnabled,
    );
  }

  void toggleTerminalFocusMode([bool? enabled]) {
    final hasActiveTab = state.activeTab != null;
    state = state.copyWith(
      terminalFocusMode: hasActiveTab
          ? (enabled ?? !state.terminalFocusMode)
          : false,
    );
  }

  Future<void> runSnippet(Snippet snippet) async {
    final session = state.activeTab?.session;
    if (session == null) {
      return;
    }
    await session.runSnippet(snippet.shellText);
  }

  void _replaceTab(String tabId, WorkspaceTab updated) {
    state = state.copyWith(
      tabs: [
        for (final tab in state.tabs) if (tab.id == tabId) updated else tab,
      ],
      activeTabId: tabId,
    );
  }
}
