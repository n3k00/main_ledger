import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart' as db;
import '../../parcels/domain/parcel.dart';
import '../domain/ledger_main.dart';
import '../domain/ledger_status.dart';
import '../domain/ledger_totals.dart';

class LedgerRepository {
  LedgerRepository(this._database);

  final db.AppDatabase _database;

  Stream<List<LedgerMain>> watchLedgers() {
    return _database.ledgerMainsDao.watchAllLedgerMains().map(
      (rows) => rows.map(_toDomain).toList(),
    );
  }

  Future<List<LedgerMain>> getAllLedgers() async {
    final rows = await _database.ledgerMainsDao.getAllLedgerMains();
    return rows.map(_toDomain).toList();
  }

  Future<void> saveLedger(LedgerMain ledger) {
    return _database.ledgerMainsDao.upsertLedgerMain(
      db.LedgerMainsCompanion(
        id: Value(ledger.id),
        driverId: Value(ledger.driverId),
        dispatchDate: Value(ledger.dispatchDate),
        commissionFee: Value(ledger.commissionFee),
        laborFee: Value(ledger.laborFee),
        deliveryFee: Value(ledger.deliveryFee),
        otherFee: Value(ledger.otherFee),
        status: Value(ledger.status.value),
        note: Value(ledger.note),
        settledTotalCharges: Value(ledger.settledTotalCharges),
        settledTotalCashAdvance: Value(ledger.settledTotalCashAdvance),
        settledNetAmount: Value(ledger.settledNetAmount),
        settledParcelCount: Value(ledger.settledParcelCount),
        settledAt: Value(ledger.settledAt),
        createdAt: Value(ledger.createdAt),
        updatedAt: Value(ledger.updatedAt),
      ),
    );
  }

  LedgerTotals calculateLedgerTotals({
    required LedgerMain ledger,
    required List<Parcel> parcels,
  }) {
    final totalCharges = parcels.fold<double>(
      0,
      (total, parcel) => total + parcel.totalCharges,
    );
    final totalCashAdvance = parcels.fold<double>(
      0,
      (total, parcel) => total + parcel.cashAdvance,
    );
    final paidAmount = parcels.fold<double>(
      0,
      (total, parcel) =>
          _isPaidParcel(parcel) ? total + parcel.totalCharges : total,
    );
    final collectAmount = parcels.fold<double>(
      0,
      (total, parcel) =>
          _isPaidParcel(parcel) ? total : total + parcel.totalCharges,
    );
    final parcelCount = parcels.fold<int>(
      0,
      (total, parcel) => total + parcel.numberOfParcels,
    );
    final netAmount = totalCharges - ledger.totalDeductions;

    return LedgerTotals(
      totalCharges: totalCharges,
      paidAmount: paidAmount,
      collectAmount: collectAmount,
      totalCashAdvance: totalCashAdvance,
      netAmount: netAmount,
      driverBalance: netAmount - collectAmount,
      parcelCount: parcelCount,
    );
  }

  LedgerMain _toDomain(db.LedgerMainRow row) {
    return LedgerMain(
      id: row.id,
      driverId: row.driverId,
      dispatchDate: row.dispatchDate,
      commissionFee: row.commissionFee,
      laborFee: row.laborFee,
      deliveryFee: row.deliveryFee,
      otherFee: row.otherFee,
      note: row.note,
      status: LedgerStatus.fromValue(row.status),
      settledTotalCharges: row.settledTotalCharges,
      settledTotalCashAdvance: row.settledTotalCashAdvance,
      settledNetAmount: row.settledNetAmount,
      settledParcelCount: row.settledParcelCount,
      settledAt: row.settledAt,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}

bool _isPaidParcel(Parcel parcel) {
  return parcel.paymentStatus.trim().toLowerCase() == 'paid';
}
