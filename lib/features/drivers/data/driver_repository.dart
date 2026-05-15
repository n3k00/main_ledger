import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart' as db;
import '../domain/driver.dart';

class DriverRepository {
  DriverRepository(this._database);

  final db.AppDatabase _database;

  Stream<List<Driver>> watchDrivers() {
    return _database.driversDao.watchAllDrivers().map(
      (rows) => rows.map(_toDomain).toList(),
    );
  }

  Future<List<Driver>> getAllDrivers() async {
    final rows = await _database.driversDao.getAllDrivers();
    return rows.map(_toDomain).toList();
  }

  Future<void> saveDriver(Driver driver) {
    return _database.driversDao.upsertDriver(
      db.DriversCompanion(
        id: Value(driver.id),
        name: Value(driver.name),
        phone: Value(driver.phone),
        vehicleNumber: Value(driver.vehicleNumber),
        createdAt: Value(driver.createdAt),
        updatedAt: Value(driver.updatedAt),
      ),
    );
  }

  Driver _toDomain(db.DriverRow row) {
    return Driver(
      id: row.id,
      name: row.name,
      phone: row.phone,
      vehicleNumber: row.vehicleNumber,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
