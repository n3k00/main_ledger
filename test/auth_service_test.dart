import 'package:flutter_test/flutter_test.dart';
import 'package:main_ledger/features/auth/data/auth_service.dart';

void main() {
  test('normalizes phone number by removing spaces and dashes', () {
    expect(AuthService.normalizePhoneNumber('09 123-456-789'), '09123456789');
  });

  test('converts normalized phone number to group mobile pseudo email', () {
    expect(AuthService.toPseudoEmail('09123456789'), '09123456789@tkt.com');
  });

  test('rejects phone number that does not start with 09', () {
    expect(
      () => AuthService.normalizePhoneNumber('08123456789'),
      throwsStateError,
    );
  });

  test('rejects invalid phone number characters', () {
    expect(
      () => AuthService.normalizePhoneNumber('09abc123'),
      throwsStateError,
    );
  });
}
