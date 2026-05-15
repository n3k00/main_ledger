import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:main_ledger/features/ledger/data/firestore_ledger_data_source.dart';
import 'package:main_ledger/features/ledger/domain/ledger_status.dart';

void main() {
  test('parses valid ledger documents with fallback values', () {
    final dispatchDate = DateTime(2026, 5, 15, 9);
    final updatedAt = DateTime(2026, 5, 15, 10);

    final ledger = ledgerFromFirestoreData({
      'id': '',
      'driverId': ' driver-1 ',
      'dispatchDate': Timestamp.fromDate(dispatchDate),
      'commissionFee': '3000',
      'laborFee': 'bad-fee',
      'status': 'unknown-status',
      'settledParcelCount': '4',
      'updatedAt': Timestamp.fromDate(updatedAt),
    }, 'ledger-1');

    expect(ledger, isNotNull);
    expect(ledger!.id, 'ledger-1');
    expect(ledger.driverId, 'driver-1');
    expect(ledger.dispatchDate, dispatchDate);
    expect(ledger.createdAt, dispatchDate);
    expect(ledger.updatedAt, updatedAt);
    expect(ledger.commissionFee, 3000);
    expect(ledger.laborFee, isNull);
    expect(ledger.status, LedgerStatus.draft);
    expect(ledger.settledParcelCount, 4);
  });

  test('skips ledger documents without driver id instead of throwing', () {
    expect(
      ledgerFromFirestoreData({
        'dispatchDate': 'not-a-date',
        'createdAt': 'bad-date',
      }, 'ledger-bad'),
      isNull,
    );
  });
}
