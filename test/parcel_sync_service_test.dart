import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:main_ledger/core/database/app_database.dart';
import 'package:main_ledger/features/parcels/data/firestore_parcel_data_source.dart';
import 'package:main_ledger/features/parcels/data/parcel_repository.dart';
import 'package:main_ledger/features/parcels/data/parcel_sync_service.dart';
import 'package:main_ledger/features/parcels/domain/parcel.dart';

void main() {
  test('sync pulls Firebase parcels without pushing local parcels', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = ParcelRepository(database);
    await repository.saveParcel(_parcel('LOCAL001'));
    final remote = _FakeParcelRemoteDataSource([_parcel('REMOTE001')]);
    final service = FirestoreParcelSyncService(
      localRepository: repository,
      remoteDataSource: remote,
    );

    await service.syncTwoWay();

    final localParcels = await repository.getAllParcels();
    expect(
      localParcels.map((parcel) => parcel.trackingId),
      containsAll(['LOCAL001', 'REMOTE001']),
    );
    expect(remote.savedParcels, isEmpty);
  });

  test('sync keeps newer local parcel cache when remote is older', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = ParcelRepository(database);
    final older = DateTime(2026, 5, 1);
    final newer = DateTime(2026, 5, 2);
    await repository.saveParcel(
      _parcel('YGN001', receiverName: 'New Local', updatedAt: newer),
    );
    final remote = _FakeParcelRemoteDataSource([
      _parcel('YGN001', receiverName: 'Old Remote', updatedAt: older),
    ]);
    final service = FirestoreParcelSyncService(
      localRepository: repository,
      remoteDataSource: remote,
    );

    await service.syncTwoWay();

    final parcel = await repository.fetchByTrackingId('YGN001');
    expect(parcel?.receiverName, 'New Local');
    expect(remote.savedParcels, isEmpty);
  });

  test(
    'sync pulls newer remote parcel and preserves local draft ledger id',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);
      final repository = ParcelRepository(database);
      final older = DateTime(2026, 5, 1);
      final newer = DateTime(2026, 5, 2);
      await repository.saveParcel(
        _parcel(
          'YGN001',
          receiverName: 'Old Local',
          ledgerId: 'local-draft-ledger',
          updatedAt: older,
        ),
      );
      final remote = _FakeParcelRemoteDataSource([
        _parcel('YGN001', receiverName: 'New Remote', updatedAt: newer),
      ]);
      final service = FirestoreParcelSyncService(
        localRepository: repository,
        remoteDataSource: remote,
      );

      await service.syncTwoWay();

      final parcel = await repository.fetchByTrackingId('YGN001');
      expect(parcel?.receiverName, 'New Remote');
      expect(parcel?.ledgerId, 'local-draft-ledger');
      expect(remote.savedParcels, isEmpty);
    },
  );

  test('sync uses remote ledger id when Firebase has one', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = ParcelRepository(database);
    final older = DateTime(2026, 5, 1);
    final newer = DateTime(2026, 5, 2);
    await repository.saveParcel(
      _parcel('YGN001', ledgerId: 'local-draft-ledger', updatedAt: older),
    );
    final remote = _FakeParcelRemoteDataSource([
      _parcel('YGN001', ledgerId: 'remote-ledger', updatedAt: newer),
    ]);
    final service = FirestoreParcelSyncService(
      localRepository: repository,
      remoteDataSource: remote,
    );

    await service.syncTwoWay();

    final parcel = await repository.fetchByTrackingId('YGN001');
    expect(parcel?.ledgerId, 'remote-ledger');
  });
}

class _FakeParcelRemoteDataSource implements ParcelRemoteDataSource {
  _FakeParcelRemoteDataSource(this.parcels);

  final List<Parcel> parcels;
  final List<Parcel> savedParcels = [];

  @override
  Future<List<Parcel>> fetchAllParcels() async => parcels;

  @override
  Future<Parcel?> fetchParcel(String trackingId) async {
    for (final parcel in parcels) {
      if (parcel.trackingId == trackingId) return parcel;
    }
    return null;
  }

  @override
  Future<void> upsertParcel(Parcel parcel) async {
    savedParcels.add(parcel);
  }

  @override
  Future<void> updateParcelLedgerId({
    required String trackingId,
    required String ledgerId,
    required String status,
  }) async {}
}

Parcel _parcel(
  String trackingId, {
  String? receiverName,
  String? ledgerId,
  DateTime? updatedAt,
}) {
  final now = updatedAt ?? DateTime.now();
  return Parcel(
    trackingId: trackingId,
    createdAt: now,
    fromTown: 'Yangon',
    toTown: 'Mandalay',
    cityCode: 'YGN',
    accountCode: 'AC',
    senderName: 'Sender Name',
    senderPhone: '091111111',
    receiverName: receiverName ?? 'Receiver Name',
    receiverPhone: '092222222',
    ledgerId: ledgerId,
    parcelType: 'Box',
    numberOfParcels: 1,
    totalCharges: 10000,
    paymentStatus: 'paid',
    updatedAt: now,
  );
}
