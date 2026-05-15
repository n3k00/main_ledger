import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:main_ledger/core/database/app_database.dart';

void main() {
  test('adds missing settlement columns when upgrading to schema 3', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await database.customStatement('DROP TABLE parcels');
    await database.customStatement('DROP TABLE ledger_mains');
    await database.customStatement('''
CREATE TABLE ledger_mains (
  id TEXT NOT NULL PRIMARY KEY,
  driver_id TEXT NOT NULL REFERENCES drivers(id),
  dispatch_date INTEGER NOT NULL,
  commission_fee REAL NULL,
  labor_fee REAL NULL,
  delivery_fee REAL NULL,
  other_fee REAL NULL,
  status TEXT NOT NULL DEFAULT 'draft',
  note TEXT NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
)
''');

    await database.migrateDatabase(database.createMigrator(), 2, 3);

    final columns = await _columnNames(database, 'ledger_mains');
    expect(columns, contains('settled_total_charges'));
    expect(columns, contains('settled_total_cash_advance'));
    expect(columns, contains('settled_net_amount'));
    expect(columns, contains('settled_parcel_count'));
    expect(columns, contains('settled_at'));
  });

  test(
    'schema 3 migration is safe when settlement columns already exist',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);

      await database.migrateDatabase(database.createMigrator(), 2, 3);

      final columns = await _columnNames(database, 'ledger_mains');
      expect(
        columns.where((name) => name == 'settled_net_amount'),
        hasLength(1),
      );
    },
  );

  test('schema 3 migration keeps existing ledgers writable', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await database.customStatement('DROP TABLE parcels');
    await database.customStatement('DROP TABLE ledger_mains');
    await database.customStatement('''
CREATE TABLE ledger_mains (
  id TEXT NOT NULL PRIMARY KEY,
  driver_id TEXT NOT NULL REFERENCES drivers(id),
  dispatch_date INTEGER NOT NULL,
  commission_fee REAL NULL,
  labor_fee REAL NULL,
  delivery_fee REAL NULL,
  other_fee REAL NULL,
  status TEXT NOT NULL DEFAULT 'draft',
  note TEXT NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
)
''');

    await database.migrateDatabase(database.createMigrator(), 2, 3);

    final now = DateTime.now();
    await database.driversDao.upsertDriver(
      DriversCompanion(
        id: const Value('driver-1'),
        name: const Value('Ko Aung'),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );
    await database.ledgerMainsDao.upsertLedgerMain(
      LedgerMainsCompanion(
        id: const Value('ledger-1'),
        driverId: const Value('driver-1'),
        dispatchDate: Value(now),
        status: const Value('settled'),
        settledTotalCharges: const Value(100000),
        settledTotalCashAdvance: const Value(0),
        settledNetAmount: const Value(95000),
        settledParcelCount: const Value(3),
        settledAt: Value(now),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );

    final ledger = (await database.ledgerMainsDao.getAllLedgerMains()).single;
    expect(ledger.settledTotalCharges, 100000);
    expect(ledger.settledNetAmount, 95000);
    expect(ledger.settledParcelCount, 3);
    expect(ledger.settledAt, isNotNull);
  });
}

Future<Set<String>> _columnNames(AppDatabase database, String tableName) async {
  final rows = await database
      .customSelect('PRAGMA table_info($tableName)')
      .get();
  return rows.map((row) => row.data['name'] as String).toSet();
}
