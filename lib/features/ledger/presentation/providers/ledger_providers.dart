import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/database_provider.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../data/firestore_ledger_data_source.dart';
import '../../data/ledger_repository.dart';
import '../../data/ledger_sync_service.dart';
import '../../domain/ledger_main.dart';
import '../../domain/ledger_status.dart';
import '../../domain/parcel_date_group.dart';
import '../../domain/parcel_entry.dart';
import '../../../parcels/domain/parcel.dart';
import '../../../parcels/presentation/providers/parcel_providers.dart';

const maxSettlementVoucherCount = 450;

final ledgerRepositoryProvider = Provider<LedgerRepository>((ref) {
  return LedgerRepository(ref.watch(appDatabaseProvider));
});

final ledgerRemoteDataSourceProvider = Provider<LedgerRemoteDataSource>((ref) {
  return FirestoreLedgerDataSource(ref.watch(firestoreProvider));
});

final ledgerSyncServiceProvider = Provider<LedgerSyncService>((ref) {
  return FirestoreLedgerSyncService(
    localRepository: ref.watch(ledgerRepositoryProvider),
    remoteDataSource: ref.watch(ledgerRemoteDataSourceProvider),
  );
});

final ledgersStreamProvider = StreamProvider<List<LedgerMain>>((ref) {
  return ref.watch(ledgerRepositoryProvider).watchLedgers();
});

final selectedLedgerIdProvider =
    NotifierProvider<SelectedLedgerIdNotifier, String?>(
      SelectedLedgerIdNotifier.new,
    );

class SelectedLedgerIdNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String ledgerId) {
    state = ledgerId;
  }

  void clear() {
    state = null;
  }
}

final localLedgerMainsProvider =
    NotifierProvider<LocalLedgerMainsNotifier, List<LedgerMain>>(
      LocalLedgerMainsNotifier.new,
    );

class LocalLedgerMainsNotifier extends Notifier<List<LedgerMain>> {
  @override
  List<LedgerMain> build() {
    final repository = ref.watch(ledgerRepositoryProvider);
    unawaited(
      repository.getAllLedgers().then((ledgers) {
        state = ledgers;
      }),
    );
    return const [];
  }

  Future<void> syncWithFirebase() async {
    await ref.read(ledgerSyncServiceProvider).syncTwoWay();
    state = await ref.read(ledgerRepositoryProvider).getAllLedgers();
  }

  Future<LedgerMain> createLedger({
    required String driverId,
    required DateTime dispatchDate,
    double? commissionFee,
    double? laborFee,
    double? deliveryFee,
    double? otherFee,
    String? note,
  }) async {
    final now = DateTime.now();
    final ledger = LedgerMain(
      id: 'ledger_${now.microsecondsSinceEpoch}',
      driverId: driverId,
      dispatchDate: dispatchDate,
      commissionFee: commissionFee,
      laborFee: laborFee,
      deliveryFee: deliveryFee,
      otherFee: otherFee,
      note: _blankToNull(note),
      status: LedgerStatus.draft,
      createdAt: now,
      updatedAt: now,
    );
    state = [ledger, ...state];
    await ref.read(ledgerRepositoryProvider).saveLedger(ledger);
    await ref.read(ledgerSyncServiceProvider).saveLedgerById(ledger.id);
    return ledger;
  }

  Future<LedgerMain?> settleLedger({
    required String ledgerId,
    required double commissionFee,
    required double laborFee,
    required double deliveryFee,
    required double otherFee,
    required String? note,
    required double settledTotalCharges,
    required double settledTotalCashAdvance,
    required double settledNetAmount,
    required int settledParcelCount,
  }) async {
    final currentLedgers = await ref
        .read(ledgerRepositoryProvider)
        .getAllLedgers();
    LedgerMain? existingLedger;
    for (final ledger in currentLedgers) {
      if (ledger.id == ledgerId) {
        existingLedger = ledger;
        break;
      }
    }
    final isEditingSettlement = existingLedger?.status == LedgerStatus.settled;
    final attachedParcels = isEditingSettlement
        ? const <Parcel>[]
        : await ref
              .read(parcelRepositoryProvider)
              .getParcelsByLedgerId(ledgerId);
    if (!isEditingSettlement &&
        attachedParcels.length > maxSettlementVoucherCount) {
      throw LedgerSettleLimitException(
        count: attachedParcels.length,
        max: maxSettlementVoucherCount,
      );
    }
    final remoteParcels = ref.read(parcelRemoteDataSourceProvider);
    if (!isEditingSettlement) {
      for (final parcel in attachedParcels) {
        final remoteParcel = await remoteParcels.fetchParcel(parcel.trackingId);
        final remoteLedgerId = remoteParcel?.ledgerId;
        if (remoteLedgerId != null && remoteLedgerId != ledgerId) {
          throw LedgerSettleConflictException(parcel.trackingId);
        }
      }
    }

    if (existingLedger == null) return null;
    final now = DateTime.now();
    final settledLedger = existingLedger.copyWith(
      commissionFee: commissionFee,
      laborFee: laborFee,
      deliveryFee: deliveryFee,
      otherFee: otherFee,
      note: _blankToNull(note),
      clearNote: _blankToNull(note) == null,
      status: LedgerStatus.settled,
      settledTotalCharges: settledTotalCharges,
      settledTotalCashAdvance: settledTotalCashAdvance,
      settledNetAmount: settledNetAmount,
      settledParcelCount: settledParcelCount,
      settledAt: existingLedger.settledAt ?? now,
      updatedAt: now,
    );

    await ref
        .read(ledgerSyncServiceProvider)
        .saveSettledLedger(
          ledger: settledLedger,
          parcelsToDispatch: attachedParcels,
        );
    await ref.read(ledgerRepositoryProvider).saveLedger(settledLedger);
    for (final parcel in attachedParcels) {
      await ref
          .read(parcelRepositoryProvider)
          .saveParcel(
            parcel.copyWith(
              ledgerId: ledgerId,
              status: 'dispatched',
              syncStatus: 'synced',
              syncedAt: now,
              updatedAt: now,
            ),
          );
    }
    state = await ref.read(ledgerRepositoryProvider).getAllLedgers();
    return settledLedger;
  }

  String? _blankToNull(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}

class LedgerSettleConflictException implements Exception {
  const LedgerSettleConflictException(this.trackingId);

  final String trackingId;

  @override
  String toString() {
    return '$trackingId is already attached to another ledger in Firebase.';
  }
}

class LedgerSettleLimitException implements Exception {
  const LedgerSettleLimitException({required this.count, required this.max});

  final int count;
  final int max;

  @override
  String toString() {
    return 'Too many vouchers to settle at once. $count attached, maximum is $max.';
  }
}

final ledgerDateGroupsProvider = Provider<List<ParcelDateGroup>>((ref) {
  return const [
    ParcelDateGroup(
      dateLabel: 'May 8, 2026',
      parcels: [
        ParcelEntry(
          customer: 'Aung Myint',
          route: 'Yangon to Mandalay',
          parcelCount: 8,
          grossAmount: 240000,
          deductions: 42000,
        ),
        ParcelEntry(
          customer: 'Thiri Online Shop',
          route: 'Yangon to Naypyidaw',
          parcelCount: 5,
          grossAmount: 162500,
          deductions: 27500,
        ),
      ],
    ),
    ParcelDateGroup(
      dateLabel: 'May 7, 2026',
      parcels: [
        ParcelEntry(
          customer: 'Moe Delivery',
          route: 'Bago to Yangon',
          parcelCount: 3,
          grossAmount: 87000,
          deductions: 14500,
        ),
      ],
    ),
  ];
});
