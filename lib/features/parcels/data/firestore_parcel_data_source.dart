import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/parcel.dart';

abstract class ParcelRemoteDataSource {
  Future<Parcel?> fetchParcel(String trackingId);
  Future<List<Parcel>> fetchAllParcels();
  Future<void> upsertParcel(Parcel parcel);
  Future<void> updateParcelLedgerId({
    required String trackingId,
    required String ledgerId,
    required String status,
  });
}

class FirestoreParcelDataSource implements ParcelRemoteDataSource {
  FirestoreParcelDataSource(this._firestore);

  static const _collectionName = 'parcels';

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _parcels =>
      _firestore.collection(_collectionName);

  @override
  Future<Parcel?> fetchParcel(String trackingId) async {
    final normalizedTrackingId = trackingId.trim();
    if (normalizedTrackingId.isEmpty) return null;

    final snapshot = await _parcels.doc(normalizedTrackingId).get();
    if (!snapshot.exists) return null;

    return _fromDocument(snapshot);
  }

  @override
  Future<List<Parcel>> fetchAllParcels() async {
    final snapshot = await _parcels
        .orderBy('updatedAt', descending: true)
        .get();
    return snapshot.docs.map(_fromDocument).toList();
  }

  @override
  Future<void> upsertParcel(Parcel parcel) {
    return _parcels.doc(parcel.trackingId).set(_toDocument(parcel));
  }

  @override
  Future<void> updateParcelLedgerId({
    required String trackingId,
    required String ledgerId,
    required String status,
  }) {
    return _parcels.doc(trackingId.trim()).update({
      'ledgerId': ledgerId,
      'status': status,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  Map<String, dynamic> _toDocument(Parcel parcel) {
    return {
      'trackingId': parcel.trackingId,
      'createdAt': Timestamp.fromDate(parcel.createdAt),
      'fromTown': parcel.fromTown,
      'toTown': parcel.toTown,
      'cityCode': parcel.cityCode,
      'accountCode': parcel.accountCode,
      'senderName': parcel.senderName,
      'senderPhone': parcel.senderPhone,
      'receiverName': parcel.receiverName,
      'receiverPhone': parcel.receiverPhone,
      'ledgerId': parcel.ledgerId,
      'parcelType': parcel.parcelType,
      'numberOfParcels': parcel.numberOfParcels,
      'totalCharges': parcel.totalCharges,
      'paymentStatus': parcel.paymentStatus,
      'cashAdvance': parcel.cashAdvance,
      'remark': parcel.remark,
      'status': parcel.status,
      'arrivedAt': parcel.arrivedAt == null
          ? null
          : Timestamp.fromDate(parcel.arrivedAt!),
      'claimedAt': parcel.claimedAt == null
          ? null
          : Timestamp.fromDate(parcel.claimedAt!),
      'updatedAt': Timestamp.fromDate(parcel.updatedAt),
    };
  }

  Parcel _fromDocument(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return parcelFromFirestoreData(snapshot.data()!, snapshot.id);
  }
}

Parcel parcelFromFirestoreData(Map<String, dynamic> data, String documentId) {
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

  double readDouble(String key, {double fallback = 0}) {
    final value = data[key];
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.trim()) ?? fallback;
    return fallback;
  }

  int readInt(String key, {int fallback = 1}) {
    final value = data[key];
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value.trim()) ?? fallback;
    return fallback;
  }

  DateTime? readNullableTimestamp(String key) {
    final value = data[key];
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  final createdAt =
      readNullableTimestamp('createdAt') ??
      readNullableTimestamp('updatedAt') ??
      now;
  final updatedAt = readNullableTimestamp('updatedAt') ?? createdAt;
  final parcelCount = readInt('numberOfParcels');

  return Parcel(
    trackingId: readString('trackingId', fallback: documentId),
    createdAt: createdAt,
    fromTown: readString('fromTown'),
    toTown: readString('toTown'),
    cityCode: readString('cityCode'),
    accountCode: readString('accountCode'),
    senderName: readString('senderName'),
    senderPhone: readString('senderPhone'),
    receiverName: readString('receiverName', fallback: 'Unknown'),
    receiverPhone: readString('receiverPhone'),
    ledgerId: readNullableString('ledgerId'),
    parcelType: readString('parcelType'),
    numberOfParcels: parcelCount <= 0 ? 1 : parcelCount,
    totalCharges: readDouble('totalCharges'),
    paymentStatus: readString('paymentStatus', fallback: 'unpaid'),
    cashAdvance: readDouble('cashAdvance'),
    remark: readNullableString('remark'),
    status: readString('status', fallback: 'received'),
    syncStatus: 'synced',
    syncedAt: now,
    arrivedAt: readNullableTimestamp('arrivedAt'),
    claimedAt: readNullableTimestamp('claimedAt'),
    updatedAt: updatedAt,
  );
}
