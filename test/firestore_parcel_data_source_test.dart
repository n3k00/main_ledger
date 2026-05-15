import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:main_ledger/features/parcels/data/firestore_parcel_data_source.dart';

void main() {
  test('parses old parcel documents with missing optional schema fields', () {
    final createdAt = DateTime(2026, 5, 15, 8, 30);

    final parcel = parcelFromFirestoreData({
      'createdAt': Timestamp.fromDate(createdAt),
      'receiverName': 'Ko Min',
      'totalCharges': 15000,
    }, 'YGN001');

    expect(parcel.trackingId, 'YGN001');
    expect(parcel.createdAt, createdAt);
    expect(parcel.updatedAt, createdAt);
    expect(parcel.receiverName, 'Ko Min');
    expect(parcel.cityCode, '');
    expect(parcel.accountCode, '');
    expect(parcel.numberOfParcels, 1);
    expect(parcel.totalCharges, 15000);
    expect(parcel.paymentStatus, 'unpaid');
    expect(parcel.status, 'received');
    expect(parcel.syncStatus, 'synced');
  });

  test('falls back instead of throwing for invalid parcel field types', () {
    final parcel = parcelFromFirestoreData({
      'trackingId': '',
      'createdAt': 'not-a-date',
      'updatedAt': '2026-05-15T09:00:00.000',
      'numberOfParcels': '0',
      'totalCharges': 'bad-amount',
      'cashAdvance': '5000',
      'ledgerId': ' ledger-1 ',
    }, 'YGN002');

    expect(parcel.trackingId, 'YGN002');
    expect(parcel.createdAt, DateTime(2026, 5, 15, 9));
    expect(parcel.numberOfParcels, 1);
    expect(parcel.totalCharges, 0);
    expect(parcel.cashAdvance, 5000);
    expect(parcel.ledgerId, 'ledger-1');
    expect(parcel.receiverName, 'Unknown');
  });
}
