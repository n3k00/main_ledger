import 'firestore_ledger_data_source.dart';
import 'ledger_repository.dart';
import '../../parcels/domain/parcel.dart';
import '../domain/ledger_main.dart';

abstract class LedgerSyncService {
  Future<void> syncTwoWay();
  Future<void> saveLedgerById(String ledgerId);
  Future<void> saveSettledLedger({
    required LedgerMain ledger,
    required List<Parcel> parcelsToDispatch,
  });
}

class FirestoreLedgerSyncService implements LedgerSyncService {
  FirestoreLedgerSyncService({
    required LedgerRepository localRepository,
    required LedgerRemoteDataSource remoteDataSource,
  }) : _localRepository = localRepository,
       _remoteDataSource = remoteDataSource;

  final LedgerRepository _localRepository;
  final LedgerRemoteDataSource _remoteDataSource;

  @override
  Future<void> syncTwoWay() async {
    final remoteLedgers = await _remoteDataSource.fetchAllLedgers();
    final localLedgers = await _localRepository.getAllLedgers();
    final remoteById = {for (final ledger in remoteLedgers) ledger.id: ledger};
    final localById = {for (final ledger in localLedgers) ledger.id: ledger};

    for (final remoteLedger in remoteLedgers) {
      final localLedger = localById[remoteLedger.id];
      if (localLedger == null) {
        await _localRepository.saveLedger(remoteLedger);
        continue;
      }
      if (remoteLedger.updatedAt.isAfter(localLedger.updatedAt)) {
        await _localRepository.saveLedger(remoteLedger);
      } else if (localLedger.updatedAt.isAfter(remoteLedger.updatedAt)) {
        await _remoteDataSource.upsertLedger(localLedger);
      }
    }

    for (final ledger in localLedgers) {
      if (!remoteById.containsKey(ledger.id)) {
        await _remoteDataSource.upsertLedger(ledger);
      }
    }
  }

  @override
  Future<void> saveLedgerById(String ledgerId) async {
    final ledgers = await _localRepository.getAllLedgers();
    for (final ledger in ledgers) {
      if (ledger.id == ledgerId) {
        await _remoteDataSource.upsertLedger(ledger);
        return;
      }
    }
  }

  @override
  Future<void> saveSettledLedger({
    required LedgerMain ledger,
    required List<Parcel> parcelsToDispatch,
  }) {
    return _remoteDataSource.upsertSettledLedger(
      ledger: ledger,
      parcelsToDispatch: parcelsToDispatch,
    );
  }
}
