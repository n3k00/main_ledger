import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';

import 'package:main_ledger/app/main_ledger_app.dart';
import 'package:main_ledger/core/database/app_database.dart';
import 'package:main_ledger/core/providers/database_provider.dart';
import 'package:main_ledger/features/auth/domain/app_auth_user.dart';
import 'package:main_ledger/features/auth/presentation/providers/auth_providers.dart';
import 'package:main_ledger/features/drivers/data/driver_sync_service.dart';
import 'package:main_ledger/features/drivers/domain/driver.dart';
import 'package:main_ledger/features/drivers/presentation/providers/driver_providers.dart';
import 'package:main_ledger/features/ledger/presentation/providers/ledger_providers.dart';
import 'package:main_ledger/features/ledger/data/ledger_sync_service.dart';
import 'package:main_ledger/features/ledger/domain/ledger_main.dart';
import 'package:main_ledger/features/parcels/data/firestore_parcel_data_source.dart';
import 'package:main_ledger/features/parcels/data/parcel_repository.dart';
import 'package:main_ledger/features/parcels/domain/parcel.dart';
import 'package:main_ledger/features/parcels/presentation/providers/parcel_providers.dart';

const _testUser = AppAuthUser(
  uid: 'test-user',
  phoneNumber: '09123456789',
  pseudoEmail: '09123456789@tkt.com',
);

var _idSequence = 0;

class TestAppHarness {
  TestAppHarness() : database = AppDatabase.forTesting(NativeDatabase.memory());

  final AppDatabase database;
  final parcelRemote = _FakeParcelRemoteDataSource();

  Future<void> close() => database.close();

  Widget build() {
    return ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        authStateChangesProvider.overrideWithValue(const AsyncData(_testUser)),
        driverSyncServiceProvider.overrideWithValue(_NoopDriverSyncService()),
        ledgerSyncServiceProvider.overrideWithValue(
          _NoopLedgerSyncService(parcelRemote),
        ),
        parcelRemoteDataSourceProvider.overrideWithValue(parcelRemote),
      ],
      child: const MainLedgerApp(),
    );
  }
}

Widget buildTestApp() {
  final harness = TestAppHarness();
  addTearDown(harness.close);
  return harness.build();
}

Future<void> seedParcel({
  required AppDatabase database,
  String? ledgerId,
  String trackingId = 'YGN001',
}) {
  final now = DateTime.now();
  return ParcelRepository(database).saveParcel(
    Parcel(
      trackingId: trackingId,
      createdAt: now,
      fromTown: 'Yangon',
      toTown: 'Mandalay',
      cityCode: 'YGN',
      accountCode: 'AC',
      senderName: 'Sender Name',
      senderPhone: '091111111',
      receiverName: 'Receiver Name',
      receiverPhone: '092222222',
      ledgerId: ledgerId,
      parcelType: 'Box',
      numberOfParcels: 2,
      totalCharges: 50000,
      paymentStatus: 'paid',
      cashAdvance: 5000,
      status: 'received',
      updatedAt: now,
    ),
  );
}

Future<String> seedDriver(AppDatabase database, String name) async {
  final now = DateTime.now();
  final id = 'driver-${_idSequence++}-$name';
  await database.driversDao.upsertDriver(
    DriversCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(now),
      updatedAt: Value(now),
    ),
  );
  return id;
}

Future<String> seedLedger(AppDatabase database, String driverId) async {
  final now = DateTime.now();
  final id = 'ledger-${_idSequence++}';
  await database.ledgerMainsDao.upsertLedgerMain(
    LedgerMainsCompanion(
      id: Value(id),
      driverId: Value(driverId),
      dispatchDate: Value(now),
      createdAt: Value(now),
      updatedAt: Value(now),
    ),
  );
  return id;
}

Future<void> createDriverAndLedger(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Open navigation menu'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Drivers'));
  await tester.pumpAndSettle();

  await tester.tap(find.text('Create Driver'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(EditableText).at(0), 'Ko Aung');
  await tester.tap(find.text('Create').last);
  await tester.pumpAndSettle();

  await tester.tap(find.byTooltip('Open navigation menu'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Ledger'));
  await tester.pumpAndSettle();

  await tester.tap(find.text('Create Ledger Main'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Create').last);
  await tester.pumpAndSettle();
}

Future<String> firstLedgerId(AppDatabase database) async {
  final ledgers = await database.ledgerMainsDao.getAllLedgerMains();
  return ledgers.single.id;
}

Widget buildTestAppWithHarness(TestAppHarness harness) {
  addTearDown(harness.close);
  return harness.build();
}

class _NoopDriverSyncService implements DriverSyncService {
  @override
  Future<void> saveDriver(Driver driver) async {}

  @override
  Future<void> syncRemoteToLocal() async {}

  @override
  Future<void> syncTwoWay() async {}
}

class _NoopLedgerSyncService implements LedgerSyncService {
  _NoopLedgerSyncService(this._parcelRemote);

  final _FakeParcelRemoteDataSource _parcelRemote;

  @override
  Future<void> saveLedgerById(String ledgerId) async {}

  @override
  Future<void> saveSettledLedger({
    required LedgerMain ledger,
    required List<Parcel> parcelsToDispatch,
  }) async {
    for (final parcel in parcelsToDispatch) {
      await _parcelRemote.updateParcelLedgerId(
        trackingId: parcel.trackingId,
        ledgerId: ledger.id,
        status: 'dispatched',
      );
    }
  }

  @override
  Future<void> syncTwoWay() async {}
}

class _FakeParcelRemoteDataSource implements ParcelRemoteDataSource {
  final parcels = <String, Parcel>{};
  final updatedLedgerIds = <String, String>{};
  final updatedStatuses = <String, String>{};

  @override
  Future<List<Parcel>> fetchAllParcels() async {
    return parcels.values.toList();
  }

  @override
  Future<Parcel?> fetchParcel(String trackingId) async {
    return parcels[trackingId];
  }

  @override
  Future<void> upsertParcel(Parcel parcel) async {
    parcels[parcel.trackingId] = parcel;
  }

  @override
  Future<void> updateParcelLedgerId({
    required String trackingId,
    required String ledgerId,
    required String status,
  }) async {
    updatedLedgerIds[trackingId] = ledgerId;
    updatedStatuses[trackingId] = status;
    final parcel = parcels[trackingId];
    if (parcel != null) {
      parcels[trackingId] = parcel.copyWith(
        ledgerId: ledgerId,
        status: status,
        updatedAt: DateTime.now(),
      );
    }
  }
}

void main() {
  testWidgets('shows ledger setup without driver management on dashboard', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());

    expect(find.text('Main Ledger'), findsOneWidget);
    expect(find.byTooltip('Sync ledger mains'), findsOneWidget);
    expect(find.text('Ledger Mains'), findsNothing);
    expect(find.text('Create Ledger Main'), findsOneWidget);
    expect(find.text('Create Ledger'), findsNothing);
    expect(find.text('No ledger mains yet'), findsOneWidget);
    expect(find.text('Create Driver'), findsNothing);
  });

  testWidgets('drawer selects the current destination', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    var ledgerTile = tester.widget<ListTile>(
      find.widgetWithText(ListTile, 'Ledger'),
    );
    var driversTile = tester.widget<ListTile>(
      find.widgetWithText(ListTile, 'Drivers'),
    );
    expect(ledgerTile.selected, isTrue);
    expect(driversTile.selected, isFalse);

    await tester.tap(find.text('Drivers'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    ledgerTile = tester.widget<ListTile>(
      find.widgetWithText(ListTile, 'Ledger'),
    );
    driversTile = tester.widget<ListTile>(
      find.widgetWithText(ListTile, 'Drivers'),
    );
    expect(ledgerTile.selected, isFalse);
    expect(driversTile.selected, isTrue);
  });

  testWidgets('opens drivers from drawer and creates a driver', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Drivers'));
    await tester.pumpAndSettle();

    expect(find.text('Drivers'), findsOneWidget);
    expect(find.byTooltip('Sync drivers'), findsOneWidget);
    expect(find.text('Create Driver'), findsOneWidget);

    await tester.tap(find.text('Create Driver'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(EditableText).at(0), 'Ko Aung');
    await tester.enterText(find.byType(EditableText).at(1), '09123456789');
    await tester.enterText(find.byType(EditableText).at(2), 'YGN-1234');
    await tester.tap(find.text('Create').last);
    await tester.pumpAndSettle();

    expect(find.text('Ko Aung'), findsOneWidget);
    expect(find.text('09123456789  |  YGN-1234'), findsOneWidget);
  });

  testWidgets('edits a driver from drivers page', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestApp());

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Drivers'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Create Driver'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(EditableText).at(0), 'Ko Aung');
    await tester.tap(find.text('Create').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Edit driver'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(EditableText).at(0), 'Ko Min');
    await tester.tap(find.text('Save').last);
    await tester.pumpAndSettle();

    expect(find.text('Ko Min'), findsOneWidget);
    expect(find.text('Ko Aung'), findsNothing);
  });

  testWidgets('creates a ledger main with a driver created from drawer', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Drivers'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Create Driver'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(EditableText).at(0), 'Ko Aung');
    await tester.tap(find.text('Create').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ledger'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Create Ledger Main'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create').last);
    await tester.pumpAndSettle();

    expect(find.text('Ko Aung'), findsOneWidget);
    expect(find.textContaining('Dispatch date:'), findsOneWidget);
    expect(find.text('draft'), findsOneWidget);
  });

  testWidgets('opens ledger detail with parcel table placeholder', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Drivers'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Create Driver'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(EditableText).at(0), 'Ko Aung');
    await tester.tap(find.text('Create').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ledger'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Create Ledger Main'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ko Aung'));
    await tester.pumpAndSettle();

    expect(find.text('Ledger Detail'), findsOneWidget);
    expect(find.byTooltip('Back'), findsOneWidget);
    expect(find.byTooltip('Open navigation menu'), findsNothing);
    expect(find.text('Scan Parcel'), findsOneWidget);
    expect(find.text('Manual Add'), findsNothing);
    expect(find.text('Settle'), findsOneWidget);
    expect(find.text('No parcels attached yet'), findsOneWidget);
    expect(
      find.text('Use Scan Parcel to attach parcels to this ledger.'),
      findsOneWidget,
    );
    expect(find.text('Tracking ID'), findsNothing);
    expect(find.text('Sender'), findsNothing);
    expect(find.text('From'), findsNothing);
    expect(find.text('Status'), findsNothing);
    expect(find.text('Action'), findsNothing);
    expect(find.text('Cash Advance'), findsNothing);
    expect(find.byTooltip('Parcel options'), findsNothing);
  });

  testWidgets('opens scan waiting dialog from ledger detail', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());

    await createDriverAndLedger(tester);
    await tester.tap(find.text('Ko Aung'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Scan Parcel'));
    await tester.pumpAndSettle();

    expect(find.text('Waiting for scanner...'), findsOneWidget);
    expect(
      find.text('Scan the barcode or QR code with the physical scanner.'),
      findsOneWidget,
    );
    expect(find.text('OK'), findsOneWidget);
  });

  testWidgets('shows local parcel rows in ledger detail table', (
    WidgetTester tester,
  ) async {
    final harness = TestAppHarness();
    await tester.pumpWidget(buildTestAppWithHarness(harness));

    await createDriverAndLedger(tester);
    await seedParcel(
      database: harness.database,
      ledgerId: await firstLedgerId(harness.database),
    );

    await tester.tap(find.text('Ko Aung'));
    await tester.pumpAndSettle();

    expect(find.text('YGN001'), findsOneWidget);
    expect(find.text('Receiver Name'), findsOneWidget);
    expect(find.text('Mandalay'), findsOneWidget);
    expect(find.text('Box'), findsOneWidget);
    expect(find.text('2'), findsAtLeastNWidgets(1));
    expect(find.text('50,000'), findsOneWidget);
    expect(find.text('5,000'), findsOneWidget);
    expect(find.text('paid'), findsOneWidget);
    expect(find.byTooltip('Parcel options'), findsOneWidget);
  });

  testWidgets('opens parcels page, searches parcels, and views detail', (
    WidgetTester tester,
  ) async {
    final harness = TestAppHarness();
    await tester.pumpWidget(buildTestAppWithHarness(harness));
    await seedParcel(database: harness.database);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Parcels'));
    await tester.pumpAndSettle();

    expect(find.text('Parcels'), findsOneWidget);
    expect(find.byTooltip('Sync parcels'), findsOneWidget);
    expect(find.text('YGN001'), findsOneWidget);

    await tester.enterText(find.byType(EditableText), 'Receiver');
    await tester.pumpAndSettle();
    expect(find.text('YGN001'), findsOneWidget);

    await tester.tap(find.text('YGN001'));
    await tester.pumpAndSettle();

    expect(find.text('Parcel Detail'), findsOneWidget);
    expect(find.text('Receiver Name'), findsOneWidget);
    expect(find.text('Sender Name'), findsOneWidget);
    expect(find.text('Reprint'), findsNothing);
  });

  testWidgets('removes a parcel from ledger without deleting it', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1800, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final harness = TestAppHarness();
    await tester.pumpWidget(buildTestAppWithHarness(harness));

    await createDriverAndLedger(tester);
    final ledgerId = await firstLedgerId(harness.database);
    await seedParcel(database: harness.database, ledgerId: ledgerId);

    await tester.tap(find.text('Ko Aung'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Parcel options'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();

    expect(find.text('YGN001'), findsNothing);
    expect(find.text('YGN001 removed from ledger.'), findsOneWidget);

    final parcel = await ParcelRepository(
      harness.database,
    ).fetchByTrackingId('YGN001');
    expect(parcel, isNotNull);
    expect(parcel!.ledgerId, isNull);
  });

  testWidgets('settles a ledger with attached parcel totals', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1800, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final harness = TestAppHarness();
    await tester.pumpWidget(buildTestAppWithHarness(harness));

    await createDriverAndLedger(tester);
    final ledgerId = await firstLedgerId(harness.database);
    await seedParcel(database: harness.database, ledgerId: ledgerId);

    await tester.tap(find.text('Ko Aung'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Settle'));
    await tester.pumpAndSettle();

    expect(find.text('Settle Ledger'), findsOneWidget);
    expect(find.text('Commission fee'), findsOneWidget);
    expect(find.text('Labor fee'), findsOneWidget);
    expect(find.text('Delivery fee'), findsOneWidget);
    expect(find.text('Other fee'), findsOneWidget);

    await tester.enterText(find.byType(EditableText).at(0), '3000');
    await tester.enterText(find.byType(EditableText).at(1), '2000');
    await tester.enterText(find.byType(EditableText).at(2), '1000');
    await tester.enterText(find.byType(EditableText).at(3), '500');
    await tester.enterText(find.byType(EditableText).at(4), 'Done note');
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Settle').last);
    await tester.pumpAndSettle();

    expect(find.text('Ledger settled.'), findsOneWidget);
    expect(find.text('Paid Amount'), findsOneWidget);
    expect(find.text('Unpaid Amount'), findsAtLeastNWidgets(1));
    expect(find.text('Total Charges'), findsOneWidget);
    expect(find.text('Cash Advance'), findsOneWidget);
    expect(find.text('Commission Fee'), findsOneWidget);
    expect(find.text('Labor Fee'), findsOneWidget);
    expect(find.text('Delivery Fee'), findsOneWidget);
    expect(find.text('Other Fee'), findsOneWidget);
    expect(find.text('Net Amount'), findsOneWidget);
    expect(find.text('Pay / Receive Amount'), findsOneWidget);
    expect(find.text('50,000 Ks'), findsAtLeastNWidgets(1));
    expect(find.text('- 3,000 Ks'), findsOneWidget);
    expect(find.text('- 2,000 Ks'), findsOneWidget);
    expect(find.text('- 1,000 Ks'), findsOneWidget);
    expect(find.text('- 500 Ks'), findsOneWidget);
    expect(find.text('+ 43,500 Ks'), findsOneWidget);
    expect(find.text('5,000 Ks'), findsAtLeastNWidgets(1));

    final ledger = (await harness.database.ledgerMainsDao.getAllLedgerMains())
        .singleWhere((item) => item.id == ledgerId);
    expect(ledger.status, 'settled');
    expect(ledger.commissionFee, 3000);
    expect(ledger.laborFee, 2000);
    expect(ledger.deliveryFee, 1000);
    expect(ledger.otherFee, 500);
    expect(ledger.note, 'Done note');
    expect(ledger.settledTotalCharges, 50000);
    expect(ledger.settledTotalCashAdvance, 5000);
    expect(ledger.settledNetAmount, 43500);
    expect(ledger.settledParcelCount, 2);
    expect(ledger.settledAt, isNotNull);
    expect(harness.parcelRemote.updatedLedgerIds['YGN001'], ledgerId);
    final settledParcel = await ParcelRepository(
      harness.database,
    ).fetchByTrackingId('YGN001');
    expect(settledParcel?.status, 'dispatched');
    expect(harness.parcelRemote.updatedStatuses['YGN001'], 'dispatched');
  });

  testWidgets('blocks settle when Firebase parcel belongs to another ledger', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1800, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final harness = TestAppHarness();
    await tester.pumpWidget(buildTestAppWithHarness(harness));

    await createDriverAndLedger(tester);
    final ledgerId = await firstLedgerId(harness.database);
    await seedParcel(database: harness.database, ledgerId: ledgerId);
    harness.parcelRemote.parcels['YGN001'] = _parcelForRemote(
      trackingId: 'YGN001',
      ledgerId: 'other-ledger',
    );

    await tester.tap(find.text('Ko Aung'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settle'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Settle').last);
    await tester.pumpAndSettle();

    expect(
      find.text('YGN001 is already attached to another ledger in Firebase.'),
      findsOneWidget,
    );

    final ledger = (await harness.database.ledgerMainsDao.getAllLedgerMains())
        .singleWhere((item) => item.id == ledgerId);
    expect(ledger.status, 'draft');
    expect(harness.parcelRemote.updatedLedgerIds, isEmpty);
  });

  testWidgets('edits an existing settlement without changing settled date', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1800, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final harness = TestAppHarness();
    await tester.pumpWidget(buildTestAppWithHarness(harness));

    await createDriverAndLedger(tester);
    final ledgerId = await firstLedgerId(harness.database);
    await seedParcel(database: harness.database, ledgerId: ledgerId);

    await tester.tap(find.text('Ko Aung'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Settle'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(EditableText).at(0), '3000');
    await tester.enterText(find.byType(EditableText).at(1), '2000');
    await tester.enterText(find.byType(EditableText).at(2), '1000');
    await tester.enterText(find.byType(EditableText).at(3), '500');
    await tester.enterText(find.byType(EditableText).at(4), 'First note');
    await tester.tap(find.widgetWithText(FilledButton, 'Settle').last);
    await tester.pumpAndSettle();

    final settledLedger =
        (await harness.database.ledgerMainsDao.getAllLedgerMains()).singleWhere(
          (item) => item.id == ledgerId,
        );
    final settledAt = settledLedger.settledAt;
    expect(settledAt, isNotNull);
    final parcelRepository = ParcelRepository(harness.database);
    final dispatchedParcel = await parcelRepository.fetchByTrackingId('YGN001');
    expect(dispatchedParcel?.status, 'dispatched');
    await parcelRepository.saveParcel(
      dispatchedParcel!.copyWith(status: 'arrived'),
    );
    harness.parcelRemote.updatedLedgerIds.clear();
    harness.parcelRemote.updatedStatuses.clear();

    expect(find.text('Edit Settlement'), findsOneWidget);
    await tester.tap(find.text('Edit Settlement'));
    await tester.pumpAndSettle();

    expect(find.text('Edit Settlement'), findsOneWidget);
    expect(find.text('Save Changes'), findsAtLeastNWidgets(1));

    await tester.enterText(find.byType(EditableText).at(0), '1000');
    await tester.enterText(find.byType(EditableText).at(1), '1000');
    await tester.enterText(find.byType(EditableText).at(2), '500');
    await tester.enterText(find.byType(EditableText).at(3), '0');
    await tester.enterText(find.byType(EditableText).at(4), 'Edited note');
    await tester.tap(find.widgetWithText(FilledButton, 'Save Changes').last);
    await tester.pumpAndSettle();

    expect(find.text('- 1,000 Ks'), findsAtLeastNWidgets(2));
    expect(find.text('- 500 Ks'), findsOneWidget);
    expect(find.text('+ 47,500 Ks'), findsOneWidget);

    final editedLedger =
        (await harness.database.ledgerMainsDao.getAllLedgerMains()).singleWhere(
          (item) => item.id == ledgerId,
        );
    expect(editedLedger.status, 'settled');
    expect(editedLedger.commissionFee, 1000);
    expect(editedLedger.laborFee, 1000);
    expect(editedLedger.deliveryFee, 500);
    expect(editedLedger.otherFee, 0);
    expect(editedLedger.note, 'Edited note');
    expect(editedLedger.settledNetAmount, 47500);
    expect(editedLedger.settledAt, settledAt);
    final arrivedParcel = await parcelRepository.fetchByTrackingId('YGN001');
    expect(arrivedParcel?.status, 'arrived');
    expect(harness.parcelRemote.updatedLedgerIds, isEmpty);
    expect(harness.parcelRemote.updatedStatuses, isEmpty);
  });

  test('protects parcel attach duplicates', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = ParcelRepository(database);
    final driverId = await seedDriver(database, 'Ko Aung');
    final firstLedgerId = await seedLedger(database, driverId);
    final secondLedgerId = await seedLedger(database, driverId);

    await seedParcel(database: database);

    expect(
      await repository.attachToLedger(
        trackingId: 'YGN001',
        ledgerId: firstLedgerId,
      ),
      ParcelAttachResult.attached,
    );
    expect(
      await repository.attachToLedger(
        trackingId: 'YGN001',
        ledgerId: firstLedgerId,
      ),
      ParcelAttachResult.alreadyAttached,
    );
    expect(
      await repository.attachToLedger(
        trackingId: 'YGN001',
        ledgerId: secondLedgerId,
      ),
      ParcelAttachResult.attachedToAnotherLedger,
    );
  });
}

Parcel _parcelForRemote({required String trackingId, String? ledgerId}) {
  final now = DateTime.now();
  return Parcel(
    trackingId: trackingId,
    createdAt: now,
    fromTown: 'Yangon',
    toTown: 'Mandalay',
    cityCode: 'YGN',
    accountCode: 'AC',
    senderName: 'Sender Name',
    senderPhone: '091111111',
    receiverName: 'Receiver Name',
    receiverPhone: '092222222',
    ledgerId: ledgerId,
    parcelType: 'Box',
    numberOfParcels: 2,
    totalCharges: 50000,
    paymentStatus: 'paid',
    cashAdvance: 5000,
    status: 'received',
    updatedAt: now,
  );
}
