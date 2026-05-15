import 'firestore_parcel_data_source.dart';
import 'parcel_repository.dart';
import '../domain/parcel.dart';

abstract class ParcelSyncService {
  Future<void> syncTwoWay();
}

class FirestoreParcelSyncService implements ParcelSyncService {
  FirestoreParcelSyncService({
    required ParcelRepository localRepository,
    required ParcelRemoteDataSource remoteDataSource,
  }) : _localRepository = localRepository,
       _remoteDataSource = remoteDataSource;

  final ParcelRepository _localRepository;
  final ParcelRemoteDataSource _remoteDataSource;

  @override
  Future<void> syncTwoWay() async {
    final remoteParcels = await _remoteDataSource.fetchAllParcels();
    for (final remoteParcel in remoteParcels) {
      final localParcel = await _localRepository.fetchByTrackingId(
        remoteParcel.trackingId,
      );
      if (localParcel != null &&
          !remoteParcel.updatedAt.isAfter(localParcel.updatedAt)) {
        continue;
      }
      await _localRepository.saveParcel(
        _mergeRemoteParcel(remoteParcel, localParcel),
      );
    }
  }

  Parcel _mergeRemoteParcel(Parcel remoteParcel, Parcel? localParcel) {
    return remoteParcel.copyWith(
      ledgerId: remoteParcel.ledgerId ?? localParcel?.ledgerId,
      syncStatus: 'synced',
      syncedAt: DateTime.now(),
    );
  }
}
