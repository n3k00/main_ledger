import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/firebase_providers.dart';
import '../../data/firestore_parcel_data_source.dart';
import '../../data/parcel_lookup_service.dart';
import '../../data/parcel_sync_service.dart';
import '../../../../core/providers/database_provider.dart';
import '../../data/parcel_repository.dart';
import '../../domain/parcel.dart';

final parcelRepositoryProvider = Provider<ParcelRepository>((ref) {
  return ParcelRepository(ref.watch(appDatabaseProvider));
});

final parcelRemoteDataSourceProvider = Provider<ParcelRemoteDataSource>((ref) {
  return FirestoreParcelDataSource(ref.watch(firestoreProvider));
});

final parcelLookupServiceProvider = Provider<ParcelLookupService>((ref) {
  return ParcelLookupService(
    localRepository: ref.watch(parcelRepositoryProvider),
    remoteDataSource: ref.watch(parcelRemoteDataSourceProvider),
  );
});

final parcelSyncServiceProvider = Provider<ParcelSyncService>((ref) {
  return FirestoreParcelSyncService(
    localRepository: ref.watch(parcelRepositoryProvider),
    remoteDataSource: ref.watch(parcelRemoteDataSourceProvider),
  );
});

final parcelsListProvider = NotifierProvider<ParcelsListNotifier, List<Parcel>>(
  ParcelsListNotifier.new,
);

class ParcelsListNotifier extends Notifier<List<Parcel>> {
  String _query = '';

  @override
  List<Parcel> build() {
    _load();
    return const [];
  }

  String get query => _query;

  Future<void> setQuery(String query) async {
    _query = query;
    await _load();
  }

  Future<void> reload() async {
    await _load();
  }

  Future<void> syncTwoWay() async {
    await ref.read(parcelSyncServiceProvider).syncTwoWay();
    await _load();
  }

  Future<void> _load() async {
    state = await ref.read(parcelRepositoryProvider).searchParcels(_query);
  }
}

final ledgerParcelsProvider =
    NotifierProvider.family<LedgerParcelsNotifier, List<Parcel>, String>(
      LedgerParcelsNotifier.new,
    );

class LedgerParcelsNotifier extends Notifier<List<Parcel>> {
  LedgerParcelsNotifier(this.ledgerId);

  final String ledgerId;

  @override
  List<Parcel> build() {
    _load();
    return const [];
  }

  Future<void> reload() async {
    await _load();
  }

  Future<void> _load() async {
    final parcels = await ref
        .read(parcelRepositoryProvider)
        .getParcelsByLedgerId(ledgerId);
    state = parcels;
  }
}
