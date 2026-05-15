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
    return snapshot.docs.map(_fromDocument).toList();
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

  Driver _fromDocument(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;

    DateTime readTimestamp(String key) {
      final value = data[key];
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      if (value is String) return DateTime.parse(value);
      throw FormatException('Invalid driver timestamp for $key.');
    }

    return Driver(
      id: (data['id'] as String?) ?? snapshot.id,
      name: data['name'] as String,
      phone: data['phone'] as String?,
      vehicleNumber: data['vehicleNumber'] as String?,
      createdAt: readTimestamp('createdAt'),
      updatedAt: readTimestamp('updatedAt'),
    );
  }
}
