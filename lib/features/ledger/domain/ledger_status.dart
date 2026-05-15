enum LedgerStatus {
  draft('draft'),
  settled('settled'),
  cancelled('cancelled');

  const LedgerStatus(this.value);

  final String value;

  static LedgerStatus fromValue(String value) {
    return LedgerStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => LedgerStatus.draft,
    );
  }
}
