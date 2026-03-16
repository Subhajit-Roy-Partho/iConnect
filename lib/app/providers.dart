import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/app_database.dart';
import '../data/repositories.dart';
import '../features/home_shell.dart';
import '../services/browser_launcher.dart';
import '../services/connection_engine.dart';
import '../services/secure_storage_service.dart';
import '../services/workspace_controller.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return const SecureStorageService();
});

final biometricServiceProvider = Provider<BiometricService>((ref) {
  return const BiometricService();
});

final browserLauncherProvider = Provider<BrowserLauncher>((ref) {
  return const BrowserLauncher();
});

final appRepositoryProvider = Provider<AppRepository>((ref) {
  final repository = AppRepository(ref.watch(databaseProvider));
  ref.onDispose(repository.dispose);
  return repository;
});

final appBootstrapProvider = FutureProvider<void>((ref) async {
  await ref.watch(appRepositoryProvider).initialize();
});

final connectionEngineProvider = Provider<ConnectionEngine>((ref) {
  return ConnectionEngine(
    repository: ref.watch(appRepositoryProvider),
    secureStorage: ref.watch(secureStorageProvider),
    biometricService: ref.watch(biometricServiceProvider),
    browserLauncher: ref.watch(browserLauncherProvider),
  );
});

final profilesProvider = StreamProvider<List<ServerProfile>>((ref) {
  return ref.watch(appRepositoryProvider).watchProfiles();
});

final snippetsProvider = StreamProvider<List<Snippet>>((ref) {
  return ref.watch(appRepositoryProvider).watchSnippets();
});

final knownHostsProvider = StreamProvider<List<KnownHostEntry>>((ref) {
  return ref.watch(appRepositoryProvider).watchKnownHosts();
});

class AppPreferencesState {
  const AppPreferencesState({
    this.themeMode = ThemeMode.system,
    this.splitSessions = true,
  });

  final ThemeMode themeMode;
  final bool splitSessions;

  AppPreferencesState copyWith({
    ThemeMode? themeMode,
    bool? splitSessions,
  }) {
    return AppPreferencesState(
      themeMode: themeMode ?? this.themeMode,
      splitSessions: splitSessions ?? this.splitSessions,
    );
  }
}

class AppPreferencesController extends Notifier<AppPreferencesState> {
  @override
  AppPreferencesState build() => const AppPreferencesState();

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
  }

  void setSplitSessions(bool enabled) {
    state = state.copyWith(splitSessions: enabled);
  }
}

final appPreferencesProvider =
    NotifierProvider<AppPreferencesController, AppPreferencesState>(
      AppPreferencesController.new,
    );

final workspaceControllerProvider =
    NotifierProvider<WorkspaceController, WorkspaceState>(
      WorkspaceController.new,
    );

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/servers',
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) => '/servers',
      ),
      for (final section in AppSection.values)
        GoRoute(
          path: section.path,
          pageBuilder: (context, state) => NoTransitionPage<void>(
            child: HomeShell(section: section),
          ),
        ),
    ],
  );
});
