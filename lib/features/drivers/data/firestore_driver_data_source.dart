import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/driver.dart';

abstract class DriverRemoteDataSource {
  Future<List<Driver>> fetchAllDrivers();
  Future<void> upsertDriver(Driver driver);
}

class FirestoreDriverDataSource implements DriverRemoteDataSource {
  FirestoreDriverDataSource(this._firestore);

  static const _collectionName = 'drivers';

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _drivers =>
      _firestore.collection(_collectionName);

  @override
  Future<List<Driver>> fetchAllDrivers() async {
    final snapshot = await _drivers.orderBy('name').get();
    return snapshot.docs
        .map(
          (document) => driverFromFirestoreData(document.data(), document.id),
        )
        .whereType<Driver>()
        .toList();
  }

  @override
  Future<void> upsertDriver(Driver driver) {
    return _drivers.doc(driver.id).set(_toDocument(driver));
  }

  Map<String, dynamic> _toDocument(Driver driver) {
    return {
      'id': driver.id,
      'name': driver.name,
      'phone': driver.phone,
      'vehicleNumber': driver.vehicleNumber,
      'createdAt': Timestamp.fromDate(driver.createdAt),
      'updatedAt': Timestamp.fromDate(driver.updatedAt),
    };
  }
}

Driver? driverFromFirestoreData(Map<String, dynamic> data, String documentId) {
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

  DateTime? readNullableTimestamp(String key) {
    final value = data[key];
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  final name = readString('name');
  if (name.isEmpty) return null;

  final createdAt =
      readNullableTimestamp('createdAt') ??
      readNullableTimestamp('updatedAt') ??
      now;
  final updatedAt = readNullableTimestamp('updatedAt') ?? createdAt;

  return Driver(
    id: readString('id', fallback: documentId),
    name: name,
    phone: readNullableString('phone'),
    vehicleNumber: readNullableString('vehicleNumber'),
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
