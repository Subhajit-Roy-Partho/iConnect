import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DataClassName('ServerProfileRecord')
class ServerProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get label => text()();
  TextColumn get host => text()();
  IntColumn get port => integer()();
  TextColumn get username => text()();
  TextColumn get tagsJson => text().withDefault(const Constant('[]'))();
  TextColumn get defaultDirectory => text().nullable()();
  TextColumn get terminalTheme => text()();
  TextColumn get authMethod => text()();
  TextColumn get credentialRefId => text().nullable()();
  TextColumn get networkMode => text()();
  TextColumn get managedBrowserUrl => text().nullable()();
  TextColumn get managedTargetHint => text().nullable()();
  TextColumn get preflightRequirementsJson =>
      text().withDefault(const Constant('[]'))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

@DataClassName('JumpHopRecord')
class JumpHops extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text()();
  IntColumn get hopOrder => integer()();
  TextColumn get hopProfileId => text()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

@DataClassName('CredentialRefRecord')
class CredentialRefs extends Table {
  TextColumn get id => text()();
  TextColumn get label => text()();
  TextColumn get kind => text()();
  TextColumn get usernameHint => text().nullable()();
  BoolColumn get requiresBiometric =>
      boolean().withDefault(const Constant(false))();
  TextColumn get publicKeyFingerprint => text().nullable()();
  BoolColumn get isEncrypted =>
      boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

@DataClassName('PortForwardProfileRecord')
class PortForwardProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text()();
  TextColumn get kind => text()();
  TextColumn get bindHost => text()();
  IntColumn get bindPort => integer()();
  TextColumn get targetHost => text()();
  IntColumn get targetPort => integer()();
  BoolColumn get autoStart => boolean().withDefault(const Constant(false))();
  TextColumn get label => text().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

@DataClassName('SnippetRecord')
class Snippets extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get shellText => text()();
  TextColumn get placeholdersJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get workingDirectoryHint => text().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  IntColumn get lastUsedAt => integer().nullable()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

@DataClassName('KnownHostRecord')
class KnownHosts extends Table {
  TextColumn get id => text()();
  TextColumn get host => text()();
  IntColumn get port => integer()();
  TextColumn get keyType => text()();
  TextColumn get fingerprintHex => text()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    ServerProfiles,
    JumpHops,
    CredentialRefs,
    PortForwardProfiles,
    Snippets,
    KnownHosts,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  factory AppDatabase.inMemory() {
    return AppDatabase(NativeDatabase.memory());
  }

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (migrator) async {
          await migrator.createAll();
        },
      );
}

QueryExecutor _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, 'i_connect.sqlite'));
    return NativeDatabase(
      file,
      setup: (database) {
        database.execute('PRAGMA foreign_keys = ON;');
      },
    );
  });
}
