import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DataClassName('DriverRow')
class Drivers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get vehicleNumber => text().named('vehicle_number').nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LedgerMainRow')
class LedgerMains extends Table {
  TextColumn get id => text()();
  TextColumn get driverId =>
      text().named('driver_id').references(Drivers, #id)();
  DateTimeColumn get dispatchDate => dateTime().named('dispatch_date')();
  RealColumn get commissionFee => real().named('commission_fee').nullable()();
  RealColumn get laborFee => real().named('labor_fee').nullable()();
  RealColumn get deliveryFee => real().named('delivery_fee').nullable()();
  RealColumn get otherFee => real().named('other_fee').nullable()();
  TextColumn get status => text().withDefault(const Constant('draft'))();
  TextColumn get note => text().nullable()();
  RealColumn get settledTotalCharges =>
      real().named('settled_total_charges').nullable()();
  RealColumn get settledTotalCashAdvance =>
      real().named('settled_total_cash_advance').nullable()();
  RealColumn get settledNetAmount =>
      real().named('settled_net_amount').nullable()();
  IntColumn get settledParcelCount =>
      integer().named('settled_parcel_count').nullable()();
  DateTimeColumn get settledAt => dateTime().named('settled_at').nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ParcelRow')
class Parcels extends Table {
  TextColumn get trackingId => text().named('tracking_id')();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  TextColumn get fromTown => text().named('from_town')();
  TextColumn get toTown => text().named('to_town')();
  TextColumn get cityCode => text().named('city_code')();
  TextColumn get accountCode => text().named('account_code')();
  TextColumn get senderName => text().named('sender_name')();
  TextColumn get senderPhone => text().named('sender_phone')();
  TextColumn get receiverName => text().named('receiver_name')();
  TextColumn get receiverPhone => text().named('receiver_phone')();
  TextColumn get ledgerId =>
      text().named('ledger_id').references(LedgerMains, #id).nullable()();
  TextColumn get parcelType => text().named('parcel_type')();
  IntColumn get numberOfParcels => integer().named('number_of_parcels')();
  RealColumn get totalCharges => real().named('total_charges')();
  TextColumn get paymentStatus => text().named('payment_status')();
  RealColumn get cashAdvance =>
      real().named('cash_advance').withDefault(const Constant(0))();
  TextColumn get remark => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('received'))();
  TextColumn get syncStatus =>
      text().named('sync_status').withDefault(const Constant('pending'))();
  DateTimeColumn get syncedAt => dateTime().named('synced_at').nullable()();
  DateTimeColumn get arrivedAt => dateTime().named('arrived_at').nullable()();
  DateTimeColumn get claimedAt => dateTime().named('claimed_at').nullable()();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column> get primaryKey => {trackingId};

  @override
  List<String> get customConstraints => const [
    'CHECK (number_of_parcels > 0)',
    'CHECK (total_charges >= 0)',
    'CHECK (cash_advance >= 0)',
  ];
}

@DriftAccessor(tables: [Drivers])
class DriversDao extends DatabaseAccessor<AppDatabase> with _$DriversDaoMixin {
  DriversDao(super.db);

  Future<List<DriverRow>> getAllDrivers() {
    final query = select(drivers)
      ..orderBy([(table) => OrderingTerm.asc(table.name)]);
    return query.get();
  }

  Stream<List<DriverRow>> watchAllDrivers() {
    final query = select(drivers)
      ..orderBy([(table) => OrderingTerm.asc(table.name)]);
    return query.watch();
  }

  Future<void> upsertDriver(DriversCompanion driver) {
    return into(drivers).insertOnConflictUpdate(driver);
  }
}

@DriftAccessor(tables: [LedgerMains])
class LedgerMainsDao extends DatabaseAccessor<AppDatabase>
    with _$LedgerMainsDaoMixin {
  LedgerMainsDao(super.db);

  Future<List<LedgerMainRow>> getAllLedgerMains() {
    final query = select(ledgerMains)
      ..orderBy([(table) => OrderingTerm.desc(table.dispatchDate)]);
    return query.get();
  }

  Stream<List<LedgerMainRow>> watchAllLedgerMains() {
    final query = select(ledgerMains)
      ..orderBy([(table) => OrderingTerm.desc(table.dispatchDate)]);
    return query.watch();
  }

  Future<void> upsertLedgerMain(LedgerMainsCompanion ledger) {
    return into(ledgerMains).insertOnConflictUpdate(ledger);
  }
}

@DriftAccessor(tables: [Parcels])
class ParcelsDao extends DatabaseAccessor<AppDatabase> with _$ParcelsDaoMixin {
  ParcelsDao(super.db);

  Future<ParcelRow?> getParcelByTrackingId(String trackingId) {
    return (select(
      parcels,
    )..where((table) => table.trackingId.equals(trackingId))).getSingleOrNull();
  }

  Future<List<ParcelRow>> getAllParcels() {
    final query = select(parcels)
      ..orderBy([(table) => OrderingTerm.desc(table.updatedAt)]);
    return query.get();
  }

  Future<List<ParcelRow>> searchParcels(String queryText) {
    final pattern = '%${queryText.toLowerCase()}%';
    final query = select(parcels)
      ..where(
        (table) =>
            table.trackingId.lower().like(pattern) |
            table.receiverName.lower().like(pattern) |
            table.receiverPhone.lower().like(pattern) |
            table.senderName.lower().like(pattern) |
            table.toTown.lower().like(pattern),
      )
      ..orderBy([(table) => OrderingTerm.desc(table.updatedAt)]);
    return query.get();
  }

  Future<List<ParcelRow>> getParcelsByLedgerId(String ledgerId) {
    final query = select(parcels)
      ..where((table) => table.ledgerId.equals(ledgerId))
      ..orderBy([(table) => OrderingTerm.desc(table.createdAt)]);
    return query.get();
  }

  Stream<List<ParcelRow>> watchParcelsByLedgerId(String ledgerId) {
    final query = select(parcels)
      ..where((table) => table.ledgerId.equals(ledgerId))
      ..orderBy([(table) => OrderingTerm.desc(table.createdAt)]);
    return query.watch();
  }

  Future<void> upsertParcel(ParcelsCompanion parcel) {
    return into(parcels).insertOnConflictUpdate(parcel);
  }
}

@DriftDatabase(
  tables: [Drivers, LedgerMains, Parcels],
  daos: [DriversDao, LedgerMainsDao, ParcelsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(parcels);
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final file = File(p.join(documentsDirectory.path, 'main_ledger.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
