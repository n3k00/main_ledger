import '../domain/parcel.dart';
import 'firestore_parcel_data_source.dart';
import 'parcel_repository.dart';

class ParcelLookupService {
  ParcelLookupService({
    required ParcelRepository localRepository,
    required ParcelRemoteDataSource remoteDataSource,
  }) : _localRepository = localRepository,
       _remoteDataSource = remoteDataSource;

  final ParcelRepository _localRepository;
  final ParcelRemoteDataSource _remoteDataSource;

  Future<Parcel?> lookupAndCache(String trackingId) async {
    final normalizedTrackingId = trackingId.trim();
    if (normalizedTrackingId.isEmpty) return null;

    final localParcel = await _localRepository.fetchByTrackingId(
      normalizedTrackingId,
    );
    if (localParcel != null) return localParcel;

    final remoteParcel = await _remoteDataSource.fetchParcel(
      normalizedTrackingId,
    );
    if (remoteParcel == null) return null;

    await _localRepository.saveParcel(
      remoteParcel.copyWith(syncStatus: 'synced'),
    );
    return _localRepository.fetchByTrackingId(remoteParcel.trackingId);
  }
}
