import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart' as db;
import '../domain/parcel.dart';

enum ParcelAttachResult {
  attached,
  notFound,
  alreadyAttached,
  attachedToAnotherLedger,
}

class ParcelRepository {
  ParcelRepository(this._database);

  final db.AppDatabase _database;

  Future<Parcel?> fetchByTrackingId(String trackingId) async {
    final row = await _database.parcelsDao.getParcelByTrackingId(trackingId);
    return row == null ? null : _toDomain(row);
  }

  Future<List<Parcel>> getParcelsByLedgerId(String ledgerId) async {
    final rows = await _database.parcelsDao.getParcelsByLedgerId(ledgerId);
    return rows.map(_toDomain).toList();
  }

  Future<List<Parcel>> getAllParcels() async {
    final rows = await _database.parcelsDao.getAllParcels();
    return rows.map(_toDomain).toList();
  }

  Future<List<Parcel>> searchParcels(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) return getAllParcels();
    final rows = await _database.parcelsDao.searchParcels(trimmedQuery);
    return rows.map(_toDomain).toList();
  }

  Stream<List<Parcel>> watchByLedgerId(String ledgerId) {
    return _database.parcelsDao
        .watchParcelsByLedgerId(ledgerId)
        .map((rows) => rows.map(_toDomain).toList());
  }

  Future<void> saveParcel(Parcel parcel) {
    return _database.parcelsDao.upsertParcel(
      db.ParcelsCompanion(
        trackingId: Value(parcel.trackingId),
        createdAt: Value(parcel.createdAt),
        fromTown: Value(parcel.fromTown),
        toTown: Value(parcel.toTown),
        cityCode: Value(parcel.cityCode),
        accountCode: Value(parcel.accountCode),
        senderName: Value(parcel.senderName),
        senderPhone: Value(parcel.senderPhone),
        receiverName: Value(parcel.receiverName),
        receiverPhone: Value(parcel.receiverPhone),
        ledgerId: Value(parcel.ledgerId),
        parcelType: Value(parcel.parcelType),
        numberOfParcels: Value(parcel.numberOfParcels),
        totalCharges: Value(parcel.totalCharges),
        paymentStatus: Value(parcel.paymentStatus),
        cashAdvance: Value(parcel.cashAdvance),
        remark: Value(parcel.remark),
        status: Value(parcel.status),
        syncStatus: Value(parcel.syncStatus),
        syncedAt: Value(parcel.syncedAt),
        arrivedAt: Value(parcel.arrivedAt),
        claimedAt: Value(parcel.claimedAt),
        updatedAt: Value(parcel.updatedAt),
      ),
    );
  }

  Future<ParcelAttachResult> attachToLedger({
    required String trackingId,
    required String ledgerId,
  }) async {
    final existing = await fetchByTrackingId(trackingId);
    if (existing == null) return ParcelAttachResult.notFound;
    if (existing.ledgerId == ledgerId) {
      return ParcelAttachResult.alreadyAttached;
    }
    if (existing.ledgerId != null) {
      return ParcelAttachResult.attachedToAnotherLedger;
    }

    await saveParcel(
      existing.copyWith(ledgerId: ledgerId, updatedAt: DateTime.now()),
    );
    return ParcelAttachResult.attached;
  }

  Future<void> removeFromLedger(String trackingId) async {
    final existing = await fetchByTrackingId(trackingId);
    if (existing == null || existing.ledgerId == null) return;
    await saveParcel(
      existing.copyWith(clearLedgerId: true, updatedAt: DateTime.now()),
    );
  }

  Future<void> createManualParcel({
    required Parcel parcel,
    required String ledgerId,
  }) {
    return saveParcel(
      parcel.copyWith(ledgerId: ledgerId, updatedAt: DateTime.now()),
    );
  }

  Parcel _toDomain(db.ParcelRow row) {
    return Parcel(
      trackingId: row.trackingId,
      createdAt: row.createdAt,
      fromTown: row.fromTown,
      toTown: row.toTown,
      cityCode: row.cityCode,
      accountCode: row.accountCode,
      senderName: row.senderName,
      senderPhone: row.senderPhone,
      receiverName: row.receiverName,
      receiverPhone: row.receiverPhone,
      ledgerId: row.ledgerId,
      parcelType: row.parcelType,
      numberOfParcels: row.numberOfParcels,
      totalCharges: row.totalCharges,
      paymentStatus: row.paymentStatus,
      cashAdvance: row.cashAdvance,
      remark: row.remark,
      status: row.status,
      syncStatus: row.syncStatus,
      syncedAt: row.syncedAt,
      arrivedAt: row.arrivedAt,
      claimedAt: row.claimedAt,
      updatedAt: row.updatedAt,
    );
  }
}
