import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:main_ledger/core/database/app_database.dart';
import 'package:main_ledger/features/ledger/data/firestore_ledger_data_source.dart';
import 'package:main_ledger/features/ledger/data/ledger_repository.dart';
import 'package:main_ledger/features/ledger/data/ledger_sync_service.dart';
import 'package:main_ledger/features/ledger/domain/ledger_main.dart';
import 'package:main_ledger/features/parcels/domain/parcel.dart';

void main() {
  test(
    'two-way sync pulls remote-only ledgers and pushes local-only ledgers',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);
      final repository = LedgerRepository(database);
      await repository.saveLedger(_ledger('ledger-local'));
      final remote = _FakeLedgerRemoteDataSource([_ledger('ledger-remote')]);
      final service = FirestoreLedgerSyncService(
        localRepository: repository,
        remoteDataSource: remote,
      );

      await service.syncTwoWay();

      final localLedgers = await repository.getAllLedgers();
      expect(
        localLedgers.map((ledger) => ledger.id),
        containsAll(['ledger-local', 'ledger-remote']),
      );
      expect(
        remote.savedLedgers.map((ledger) => ledger.id),
        contains('ledger-local'),
      );
      expect(
        remote.savedLedgers.map((ledger) => ledger.id),
        isNot(contains('ledger-remote')),
      );
    },
  );

  test('two-way sync keeps newer remote ledger locally', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = LedgerRepository(database);
    final older = DateTime(2026, 5, 1);
    final newer = DateTime(2026, 5, 2);
    await repository.saveLedger(
      _ledger('ledger-1', note: 'Old local', updatedAt: older),
    );
    final remote = _FakeLedgerRemoteDataSource([
      _ledger('ledger-1', note: 'New remote', updatedAt: newer),
    ]);
    final service = FirestoreLedgerSyncService(
      localRepository: repository,
      remoteDataSource: remote,
    );

    await service.syncTwoWay();

    final ledgers = await repository.getAllLedgers();
    expect(ledgers.single.note, 'New remote');
    expect(remote.savedLedgers, isEmpty);
  });

  test('two-way sync pushes newer local ledger', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = LedgerRepository(database);
    final older = DateTime(2026, 5, 1);
    final newer = DateTime(2026, 5, 2);
    await repository.saveLedger(
      _ledger('ledger-1', note: 'New local', updatedAt: newer),
    );
    final remote = _FakeLedgerRemoteDataSource([
      _ledger('ledger-1', note: 'Old remote', updatedAt: older),
    ]);
    final service = FirestoreLedgerSyncService(
      localRepository: repository,
      remoteDataSource: remote,
    );

    await service.syncTwoWay();

    expect(remote.savedLedgers.single.note, 'New local');
  });

  test('saves a local ledger by id to Firebase', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = LedgerRepository(database);
    await repository.saveLedger(_ledger('ledger-local'));
    final remote = _FakeLedgerRemoteDataSource();
    final service = FirestoreLedgerSyncService(
      localRepository: repository,
      remoteDataSource: remote,
    );

    await service.saveLedgerById('ledger-local');

    expect(remote.savedLedgers.single.id, 'ledger-local');
  });

  test(
    'saves settled ledger with parcel dispatches as one remote call',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);
      final remote = _FakeLedgerRemoteDataSource();
      final service = FirestoreLedgerSyncService(
        localRepository: LedgerRepository(database),
        remoteDataSource: remote,
      );
      final ledger = _ledger('ledger-settled');

      await service.saveSettledLedger(
        ledger: ledger,
        parcelsToDispatch: [_parcel('YGN001')],
      );

      expect(remote.savedLedgers.single.id, 'ledger-settled');
      expect(remote.dispatchedParcelIds, ['YGN001']);
    },
  );
}

class _FakeLedgerRemoteDataSource implements LedgerRemoteDataSource {
  _FakeLedgerRemoteDataSource([this.ledgers = const []]);

  final List<LedgerMain> ledgers;
  final List<LedgerMain> savedLedgers = [];
  final List<String> dispatchedParcelIds = [];

  @override
  Future<List<LedgerMain>> fetchAllLedgers() async => ledgers;

  @override
  Future<void> upsertLedger(LedgerMain ledger) async {
    savedLedgers.add(ledger);
  }

  @override
  Future<void> upsertSettledLedger({
    required LedgerMain ledger,
    required List<Parcel> parcelsToDispatch,
  }) async {
    savedLedgers.add(ledger);
    dispatchedParcelIds.addAll(
      parcelsToDispatch.map((parcel) => parcel.trackingId),
    );
  }
}

LedgerMain _ledger(String id, {String? note, DateTime? updatedAt}) {
  final now = updatedAt ?? DateTime.now();
  return LedgerMain(
    id: id,
    driverId: 'driver-1',
    dispatchDate: now,
    note: note,
    createdAt: now,
    updatedAt: now,
  );
}

Parcel _parcel(String trackingId) {
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
    parcelType: 'Box',
    numberOfParcels: 1,
    totalCharges: 10000,
    paymentStatus: 'paid',
    updatedAt: now,
  );
}
