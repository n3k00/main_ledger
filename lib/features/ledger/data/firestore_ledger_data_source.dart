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
    return snapshot.docs.map(_fromDocument).toList();
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

  LedgerMain _fromDocument(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;

    DateTime readTimestamp(String key) {
      final value = data[key];
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      if (value is String) return DateTime.parse(value);
      throw FormatException('Invalid ledger timestamp for $key.');
    }

    DateTime? readNullableTimestamp(String key) {
      final value = data[key];
      if (value == null) return null;
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      if (value is String) return DateTime.parse(value);
      throw FormatException('Invalid ledger timestamp for $key.');
    }

    return LedgerMain(
      id: (data['id'] as String?) ?? snapshot.id,
      driverId: data['driverId'] as String,
      dispatchDate: readTimestamp('dispatchDate'),
      commissionFee: (data['commissionFee'] as num?)?.toDouble(),
      laborFee: (data['laborFee'] as num?)?.toDouble(),
      deliveryFee: (data['deliveryFee'] as num?)?.toDouble(),
      otherFee: (data['otherFee'] as num?)?.toDouble(),
      note: data['note'] as String?,
      status: LedgerStatus.fromValue((data['status'] as String?) ?? 'draft'),
      settledTotalCharges: (data['settledTotalCharges'] as num?)?.toDouble(),
      settledTotalCashAdvance: (data['settledTotalCashAdvance'] as num?)
          ?.toDouble(),
      settledNetAmount: (data['settledNetAmount'] as num?)?.toDouble(),
      settledParcelCount: (data['settledParcelCount'] as num?)?.toInt(),
      settledAt: readNullableTimestamp('settledAt'),
      createdAt: readTimestamp('createdAt'),
      updatedAt: readTimestamp('updatedAt'),
    );
  }
}
