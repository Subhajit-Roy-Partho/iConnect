import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_connect/app/providers.dart';
import 'package:i_connect/data/app_database.dart';
import 'package:i_connect/data/repositories.dart';
import 'package:i_connect/features/home_shell.dart';

void main() {
  testWidgets('renders saved servers in the shell', (tester) async {
    final database = AppDatabase.inMemory();
    final repository = AppRepository(database, seedDemoContent: false);
    await repository.initialize();
    await repository.saveProfile(
      ServerProfile(
        id: 'profile-1',
        label: 'Lab Node',
        host: 'lab.internal',
        port: 22,
        username: 'dev',
        managedAccessConfig: const ManagedAccessConfig(mode: NetworkMode.direct),
        jumpRoute: const JumpRoute(
          profileId: 'profile-1',
          hopProfileIds: [],
        ),
      ),
    );

    addTearDown(() async {
      await repository.dispose();
      await database.close();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          appRepositoryProvider.overrideWith((ref) => repository),
          appBootstrapProvider.overrideWith((ref) async {}),
        ],
        child: const MaterialApp(
          home: HomeShell(section: AppSection.servers),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Servers'), findsWidgets);
    expect(find.text('Lab Node'), findsOneWidget);
  });
}
