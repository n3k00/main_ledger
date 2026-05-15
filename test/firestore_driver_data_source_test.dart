import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:main_ledger/features/drivers/data/firestore_driver_data_source.dart';

void main() {
  test('parses valid driver documents with timestamp fallbacks', () {
    final updatedAt = DateTime(2026, 5, 15, 9);

    final driver = driverFromFirestoreData({
      'id': '',
      'name': ' Ko Aung ',
      'phone': ' 09123456789 ',
      'vehicleNumber': '',
      'updatedAt': Timestamp.fromDate(updatedAt),
    }, 'driver-1');

    expect(driver, isNotNull);
    expect(driver!.id, 'driver-1');
    expect(driver.name, 'Ko Aung');
    expect(driver.phone, '09123456789');
    expect(driver.vehicleNumber, isNull);
    expect(driver.createdAt, updatedAt);
    expect(driver.updatedAt, updatedAt);
  });

  test('skips invalid driver documents instead of throwing', () {
    expect(
      driverFromFirestoreData({
        'phone': '09123456789',
        'createdAt': 'not-a-date',
      }, 'driver-bad'),
      isNull,
    );
  });
}
