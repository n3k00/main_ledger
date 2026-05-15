import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:main_ledger/core/database/app_database.dart';
import 'package:main_ledger/features/drivers/data/driver_repository.dart';
import 'package:main_ledger/features/drivers/data/driver_sync_service.dart';
import 'package:main_ledger/features/drivers/data/firestore_driver_data_source.dart';
import 'package:main_ledger/features/drivers/domain/driver.dart';

void main() {
  test('syncs Firebase drivers into local database', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = DriverRepository(database);
    final remote = _FakeDriverRemoteDataSource([
      _driver('driver-1', 'Ko Aung'),
      _driver('driver-2', 'Ko Min'),
    ]);
    final service = FirestoreDriverSyncService(
      localRepository: repository,
      remoteDataSource: remote,
    );

    await service.syncRemoteToLocal();

    final drivers = await repository.getAllDrivers();
    expect(drivers.map((driver) => driver.name), ['Ko Aung', 'Ko Min']);
  });

  test('saves local driver to Firebase data source', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final remote = _FakeDriverRemoteDataSource();
    final service = FirestoreDriverSyncService(
      localRepository: DriverRepository(database),
      remoteDataSource: remote,
    );
    final driver = _driver('driver-1', 'Ko Aung');

    await service.saveDriver(driver);

    expect(remote.savedDrivers.single.id, 'driver-1');
    expect(remote.savedDrivers.single.name, 'Ko Aung');
  });

  test(
    'two-way sync pulls remote-only drivers and pushes local-only drivers',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);
      final repository = DriverRepository(database);
      final localDriver = _driver('driver-local', 'Local Driver');
      await repository.saveDriver(localDriver);
      final remote = _FakeDriverRemoteDataSource([
        _driver('driver-remote', 'Remote Driver'),
      ]);
      final service = FirestoreDriverSyncService(
        localRepository: repository,
        remoteDataSource: remote,
      );

      await service.syncTwoWay();

      final localDrivers = await repository.getAllDrivers();
      expect(
        localDrivers.map((driver) => driver.id),
        containsAll(['driver-local', 'driver-remote']),
      );
      expect(
        remote.savedDrivers.map((driver) => driver.id),
        contains('driver-local'),
      );
      expect(
        remote.savedDrivers.map((driver) => driver.id),
        isNot(contains('driver-remote')),
      );
    },
  );

  test('two-way sync keeps newer remote driver locally', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = DriverRepository(database);
    final older = DateTime(2026, 5, 1);
    final newer = DateTime(2026, 5, 2);
    await repository.saveDriver(
      _driver('driver-1', 'Old Local', updatedAt: older),
    );
    final remote = _FakeDriverRemoteDataSource([
      _driver('driver-1', 'New Remote', updatedAt: newer),
    ]);
    final service = FirestoreDriverSyncService(
      localRepository: repository,
      remoteDataSource: remote,
    );

    await service.syncTwoWay();

    final drivers = await repository.getAllDrivers();
    expect(drivers.single.name, 'New Remote');
    expect(remote.savedDrivers, isEmpty);
  });

  test('two-way sync pushes newer local driver', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = DriverRepository(database);
    final older = DateTime(2026, 5, 1);
    final newer = DateTime(2026, 5, 2);
    await repository.saveDriver(
      _driver('driver-1', 'New Local', updatedAt: newer),
    );
    final remote = _FakeDriverRemoteDataSource([
      _driver('driver-1', 'Old Remote', updatedAt: older),
    ]);
    final service = FirestoreDriverSyncService(
      localRepository: repository,
      remoteDataSource: remote,
    );

    await service.syncTwoWay();

    expect(remote.savedDrivers.single.name, 'New Local');
  });
}

class _FakeDriverRemoteDataSource implements DriverRemoteDataSource {
  _FakeDriverRemoteDataSource([this.drivers = const []]);

  final List<Driver> drivers;
  final List<Driver> savedDrivers = [];

  @override
  Future<List<Driver>> fetchAllDrivers() async {
    return drivers;
  }

  @override
  Future<void> upsertDriver(Driver driver) async {
    savedDrivers.add(driver);
  }
}

Driver _driver(String id, String name, {DateTime? updatedAt}) {
  final now = updatedAt ?? DateTime.now();
  return Driver(
    id: id,
    name: name,
    phone: '09123456789',
    vehicleNumber: 'YGN-1234',
    createdAt: now,
    updatedAt: now,
  );
}
