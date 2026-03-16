import 'package:flutter_test/flutter_test.dart';
import 'package:i_connect/data/app_database.dart';
import 'package:i_connect/data/repositories.dart';

void main() {
  late AppDatabase database;
  late AppRepository repository;

  setUp(() {
    database = AppDatabase.inMemory();
    repository = AppRepository(database, seedDemoContent: false);
  });

  tearDown(() async {
    await repository.dispose();
    await database.close();
  });

  test('persists jump route order and port forward metadata', () async {
    await repository.initialize();

    final bastion = _profile(
      id: 'bastion',
      label: 'Bastion',
      host: 'bastion.internal',
      username: 'ops',
    );
    final target = _profile(
      id: 'target',
      label: 'Target',
      host: 'db.internal',
      username: 'ubuntu',
    ).copyWith(
      jumpRoute: const JumpRoute(
        profileId: 'target',
        hopProfileIds: ['bastion'],
      ),
      portForwards: const [
        PortForwardProfile(
          id: 'pf-1',
          profileId: 'target',
          kind: PortForwardKind.local,
          bindHost: '127.0.0.1',
          bindPort: 15432,
          targetHost: 'localhost',
          targetPort: 5432,
          autoStart: true,
          label: 'Postgres',
        ),
      ],
    );

    await repository.saveProfile(bastion);
    await repository.saveProfile(target);

    final loaded = await repository.getProfiles();
    final restored = loaded.firstWhere((profile) => profile.id == 'target');

    expect(restored.jumpRoute.hopProfileIds, ['bastion']);
    expect(restored.portForwards, hasLength(1));
    expect(restored.portForwards.first.bindPort, 15432);
    expect(restored.portForwards.first.autoStart, isTrue);
  });

  test('returns jump profiles in requested order', () async {
    await repository.initialize();

    await repository.saveProfile(
      _profile(
        id: 'jump-a',
        label: 'Jump A',
        host: 'a.internal',
        username: 'ops',
      ),
    );
    await repository.saveProfile(
      _profile(
        id: 'jump-b',
        label: 'Jump B',
        host: 'b.internal',
        username: 'ops',
      ),
    );

    final ordered = await repository.getProfilesByIds(['jump-b', 'jump-a']);
    expect(ordered.map((profile) => profile.id), ['jump-b', 'jump-a']);
  });

  test('replaces known host fingerprints for the same host and key type', () async {
    await repository.initialize();

    await repository.saveKnownHost(
      host: 'bastion.internal',
      port: 22,
      keyType: 'ssh-ed25519',
      fingerprint: 'aa:bb:cc',
    );
    await repository.saveKnownHost(
      host: 'bastion.internal',
      port: 22,
      keyType: 'ssh-ed25519',
      fingerprint: '11:22:33',
    );

    final entries = await repository.getKnownHosts();
    expect(entries, hasLength(1));
    expect(entries.first.fingerprintHex, '11:22:33');
  });
}

ServerProfile _profile({
  required String id,
  required String label,
  required String host,
  required String username,
}) {
  return ServerProfile(
    id: id,
    label: label,
    host: host,
    port: 22,
    username: username,
    managedAccessConfig: const ManagedAccessConfig(mode: NetworkMode.direct),
    jumpRoute: JumpRoute(profileId: id, hopProfileIds: const []),
  );
}
