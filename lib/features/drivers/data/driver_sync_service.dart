import '../domain/driver.dart';
import 'driver_repository.dart';
import 'firestore_driver_data_source.dart';

abstract class DriverSyncService {
  Future<void> syncRemoteToLocal();
  Future<void> syncTwoWay();
  Future<void> saveDriver(Driver driver);
}

class FirestoreDriverSyncService implements DriverSyncService {
  FirestoreDriverSyncService({
    required DriverRepository localRepository,
    required DriverRemoteDataSource remoteDataSource,
  }) : _localRepository = localRepository,
       _remoteDataSource = remoteDataSource;

  final DriverRepository _localRepository;
  final DriverRemoteDataSource _remoteDataSource;

  @override
  Future<void> syncRemoteToLocal() async {
    final remoteDrivers = await _remoteDataSource.fetchAllDrivers();
    final localDrivers = await _localRepository.getAllDrivers();
    final localById = {for (final driver in localDrivers) driver.id: driver};
    for (final driver in remoteDrivers) {
      final localDriver = localById[driver.id];
      if (localDriver == null ||
          driver.updatedAt.isAfter(localDriver.updatedAt)) {
        await _localRepository.saveDriver(driver);
      }
    }
  }

  @override
  Future<void> syncTwoWay() async {
    final remoteDrivers = await _remoteDataSource.fetchAllDrivers();
    final localDrivers = await _localRepository.getAllDrivers();
    final remoteById = {for (final driver in remoteDrivers) driver.id: driver};
    final localById = {for (final driver in localDrivers) driver.id: driver};

    for (final remoteDriver in remoteDrivers) {
      final localDriver = localById[remoteDriver.id];
      if (localDriver == null) {
        await _localRepository.saveDriver(remoteDriver);
        continue;
      }
      if (remoteDriver.updatedAt.isAfter(localDriver.updatedAt)) {
        await _localRepository.saveDriver(remoteDriver);
      } else if (localDriver.updatedAt.isAfter(remoteDriver.updatedAt)) {
        await _remoteDataSource.upsertDriver(localDriver);
      }
    }

    for (final driver in localDrivers) {
      if (!remoteById.containsKey(driver.id)) {
        await _remoteDataSource.upsertDriver(driver);
      }
    }
  }

  @override
  Future<void> saveDriver(Driver driver) {
    return _remoteDataSource.upsertDriver(driver);
  }
}
