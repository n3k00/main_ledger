import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/database_provider.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../data/driver_sync_service.dart';
import '../../data/firestore_driver_data_source.dart';
import '../../data/driver_repository.dart';
import '../../domain/driver.dart';

final driverRepositoryProvider = Provider<DriverRepository>((ref) {
  return DriverRepository(ref.watch(appDatabaseProvider));
});

final driverRemoteDataSourceProvider = Provider<DriverRemoteDataSource>((ref) {
  return FirestoreDriverDataSource(ref.watch(firestoreProvider));
});

final driverSyncServiceProvider = Provider<DriverSyncService>((ref) {
  return FirestoreDriverSyncService(
    localRepository: ref.watch(driverRepositoryProvider),
    remoteDataSource: ref.watch(driverRemoteDataSourceProvider),
  );
});

final driversStreamProvider = StreamProvider<List<Driver>>((ref) {
  return ref.watch(driverRepositoryProvider).watchDrivers();
});

final localDriversProvider =
    NotifierProvider<LocalDriversNotifier, List<Driver>>(
      LocalDriversNotifier.new,
    );

class LocalDriversNotifier extends Notifier<List<Driver>> {
  @override
  List<Driver> build() {
    final repository = ref.watch(driverRepositoryProvider);
    unawaited(
      repository
          .getAllDrivers()
          .then((drivers) {
            state = drivers;
          })
          .then((_) => ref.read(driverSyncServiceProvider).syncRemoteToLocal())
          .then((_) => repository.getAllDrivers())
          .then((drivers) {
            state = drivers;
          })
          .catchError((_) {
            return null;
          }),
    );
    return const [];
  }

  Future<Driver> createDriver({
    required String name,
    String? phone,
    String? vehicleNumber,
  }) async {
    final now = DateTime.now();
    final driver = Driver(
      id: 'driver_${now.microsecondsSinceEpoch}',
      name: name.trim(),
      phone: _blankToNull(phone),
      vehicleNumber: _blankToNull(vehicleNumber),
      createdAt: now,
      updatedAt: now,
    );
    state = [...state, driver];
    await ref.read(driverRepositoryProvider).saveDriver(driver);
    await ref.read(driverSyncServiceProvider).saveDriver(driver);
    return driver;
  }

  Future<void> syncWithFirebase() async {
    await ref.read(driverSyncServiceProvider).syncTwoWay();
    state = await ref.read(driverRepositoryProvider).getAllDrivers();
  }

  Future<void> updateDriver({
    required String id,
    required String name,
    String? phone,
    String? vehicleNumber,
  }) async {
    Driver? updatedDriver;
    state = [
      for (final driver in state)
        if (driver.id == id)
          updatedDriver = driver.copyWith(
            name: name.trim(),
            phone: _blankToNull(phone),
            clearPhone: _blankToNull(phone) == null,
            vehicleNumber: _blankToNull(vehicleNumber),
            clearVehicleNumber: _blankToNull(vehicleNumber) == null,
            updatedAt: DateTime.now(),
          )
        else
          driver,
    ];
    if (updatedDriver != null) {
      await ref.read(driverRepositoryProvider).saveDriver(updatedDriver);
      await ref.read(driverSyncServiceProvider).saveDriver(updatedDriver);
    }
  }

  String? _blankToNull(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
