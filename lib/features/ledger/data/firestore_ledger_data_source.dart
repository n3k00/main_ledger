import 'package:cloud_firestore/cloud_firestore.dart';

import '../../parcels/domain/parcel.dart';
import '../domain/ledger_main.dart';
import '../domain/ledger_status.dart';

abstract class LedgerRemoteDataSource {
  Future<List<LedgerMain>> fetchAllLedgers();
  Future<void> upsertLedger(LedgerMain ledger);
  Future<void> upsertSettledLedger({
    required LedgerMain ledger,
    required List<Parcel> parcelsToDispatch,
  });
}

class FirestoreLedgerDataSource implements LedgerRemoteDataSource {
  FirestoreLedgerDataSource(this._firestore);

  static const _collectionName = 'ledger_mains';

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _ledgerMains =>
      _firestore.collection(_collectionName);

  @override
  Future<List<LedgerMain>> fetchAllLedgers() async {
    final snapshot = await _ledgerMains
        .orderBy('dispatchDate', descending: true)
        .get();
    return snapshot.docs
        .map(
          (document) => ledgerFromFirestoreData(document.data(), document.id),
        )
        .whereType<LedgerMain>()
        .toList();
  }

  @override
  Future<void> upsertLedger(LedgerMain ledger) {
    return _ledgerMains.doc(ledger.id).set(_toDocument(ledger));
  }

  @override
  Future<void> upsertSettledLedger({
    required LedgerMain ledger,
    required List<Parcel> parcelsToDispatch,
  }) {
    final batch = _firestore.batch();
    batch.set(_ledgerMains.doc(ledger.id), _toDocument(ledger));

    final updatedAt = Timestamp.fromDate(ledger.updatedAt);
    for (final parcel in parcelsToDispatch) {
      batch.update(
        _firestore.collection('parcels').doc(parcel.trackingId.trim()),
        {'ledgerId': ledger.id, 'status': 'dispatched', 'updatedAt': updatedAt},
      );
    }

    return batch.commit();
  }

  Map<String, dynamic> _toDocument(LedgerMain ledger) {
    return {
      'id': ledger.id,
      'driverId': ledger.driverId,
      'dispatchDate': Timestamp.fromDate(ledger.dispatchDate),
      'commissionFee': ledger.commissionFee,
      'laborFee': ledger.laborFee,
      'deliveryFee': ledger.deliveryFee,
      'otherFee': ledger.otherFee,
      'status': ledger.status.value,
      'note': ledger.note,
      'settledTotalCharges': ledger.settledTotalCharges,
      'settledTotalCashAdvance': ledger.settledTotalCashAdvance,
      'settledNetAmount': ledger.settledNetAmount,
      'settledParcelCount': ledger.settledParcelCount,
      'settledAt': ledger.settledAt == null
          ? null
          : Timestamp.fromDate(ledger.settledAt!),
      'createdAt': Timestamp.fromDate(ledger.createdAt),
      'updatedAt': Timestamp.fromDate(ledger.updatedAt),
    };
  }
}

LedgerMain? ledgerFromFirestoreData(
  Map<String, dynamic> data,
  String documentId,
) {
  final now = DateTime.now();

  String readString(String key, {String fallback = ''}) {
    final value = data[key];
    if (value == null) return fallback;
    final text = value.toString().trim();
    return text.isEmpty ? fallback : text;
  }

  String? readNullableString(String key) {
    final text = readString(key);
    return text.isEmpty ? null : text;
  }

  double? readNullableDouble(String key) {
    final value = data[key];
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.trim());
    return null;
  }

  int? readNullableInt(String key) {
    final value = data[key];
    if (value == null) return null;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value.trim());
    return null;
  }

  DateTime? readNullableTimestamp(String key) {
    final value = data[key];
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  final driverId = readString('driverId');
  if (driverId.isEmpty) return null;

  final createdAt =
      readNullableTimestamp('createdAt') ??
      readNullableTimestamp('dispatchDate') ??
      readNullableTimestamp('updatedAt') ??
      now;
  final updatedAt = readNullableTimestamp('updatedAt') ?? createdAt;
  final dispatchDate = readNullableTimestamp('dispatchDate') ?? createdAt;

  return LedgerMain(
    id: readString('id', fallback: documentId),
    driverId: driverId,
    dispatchDate: dispatchDate,
    commissionFee: readNullableDouble('commissionFee'),
    laborFee: readNullableDouble('laborFee'),
    deliveryFee: readNullableDouble('deliveryFee'),
    otherFee: readNullableDouble('otherFee'),
    note: readNullableString('note'),
    status: LedgerStatus.fromValue(readString('status', fallback: 'draft')),
    settledTotalCharges: readNullableDouble('settledTotalCharges'),
    settledTotalCashAdvance: readNullableDouble('settledTotalCashAdvance'),
    settledNetAmount: readNullableDouble('settledNetAmount'),
    settledParcelCount: readNullableInt('settledParcelCount'),
    settledAt: readNullableTimestamp('settledAt'),
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
