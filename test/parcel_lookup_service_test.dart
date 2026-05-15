import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:main_ledger/core/database/app_database.dart';
import 'package:main_ledger/features/parcels/data/firestore_parcel_data_source.dart';
import 'package:main_ledger/features/parcels/data/parcel_lookup_service.dart';
import 'package:main_ledger/features/parcels/data/parcel_repository.dart';
import 'package:main_ledger/features/parcels/domain/parcel.dart';

void main() {
  test('returns local parcel before asking Firebase', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = ParcelRepository(database);
    final remote = _FakeRemoteDataSource();
    final service = ParcelLookupService(
      localRepository: repository,
      remoteDataSource: remote,
    );
    await repository.saveParcel(_parcel('YGN001', receiverName: 'Local User'));

    final parcel = await service.lookupAndCache('YGN001');

    expect(parcel?.receiverName, 'Local User');
    expect(remote.fetchCount, 0);
  });

  test('fetches Firebase parcel and caches it locally when missing', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = ParcelRepository(database);
    final remote = _FakeRemoteDataSource({
      'YGN001': _parcel(
        'YGN001',
        receiverName: 'Cloud User',
        ledgerId: 'remote-ledger',
      ),
    });
    final service = ParcelLookupService(
      localRepository: repository,
      remoteDataSource: remote,
    );

    final parcel = await service.lookupAndCache('YGN001');
    final cached = await repository.fetchByTrackingId('YGN001');

    expect(parcel?.receiverName, 'Cloud User');
    expect(cached?.receiverName, 'Cloud User');
    expect(cached?.ledgerId, 'remote-ledger');
    expect(cached?.syncStatus, 'synced');
    expect(remote.fetchCount, 1);
  });

  test(
    'preserves Firebase ledger id so attach protection can warn early',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);
      final repository = ParcelRepository(database);
      final remote = _FakeRemoteDataSource({
        'YGN001': _parcel('YGN001', ledgerId: 'other-ledger'),
      });
      final service = ParcelLookupService(
        localRepository: repository,
        remoteDataSource: remote,
      );

      await service.lookupAndCache('YGN001');
      final result = await repository.attachToLedger(
        trackingId: 'YGN001',
        ledgerId: 'current-ledger',
      );

      expect(result, ParcelAttachResult.attachedToAnotherLedger);
    },
  );

  test('returns null when local and Firebase lookup miss', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = ParcelRepository(database);
    final remote = _FakeRemoteDataSource();
    final service = ParcelLookupService(
      localRepository: repository,
      remoteDataSource: remote,
    );

    final parcel = await service.lookupAndCache('YGN404');

    expect(parcel, isNull);
    expect(remote.fetchCount, 1);
  });
}

class _FakeRemoteDataSource implements ParcelRemoteDataSource {
  _FakeRemoteDataSource([this.parcels = const {}]);

  final Map<String, Parcel> parcels;
  int fetchCount = 0;

  @override
  Future<Parcel?> fetchParcel(String trackingId) async {
    fetchCount++;
    return parcels[trackingId];
  }

  @override
  Future<List<Parcel>> fetchAllParcels() async {
    return parcels.values.toList();
  }

  @override
  Future<void> upsertParcel(Parcel parcel) async {}

  @override
  Future<void> updateParcelLedgerId({
    required String trackingId,
    required String ledgerId,
    required String status,
  }) async {}
}

Parcel _parcel(String trackingId, {String? receiverName, String? ledgerId}) {
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
    receiverName: receiverName ?? 'Receiver Name',
    receiverPhone: '092222222',
    ledgerId: ledgerId,
    parcelType: 'Box',
    numberOfParcels: 1,
    totalCharges: 10000,
    paymentStatus: 'paid',
    cashAdvance: 0,
    status: 'received',
    updatedAt: now,
  );
}
