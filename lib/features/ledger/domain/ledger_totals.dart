class LedgerTotals {
  const LedgerTotals({
    required this.totalCharges,
    required this.paidAmount,
    required this.collectAmount,
    required this.totalCashAdvance,
    required this.netAmount,
    required this.driverBalance,
    required this.parcelCount,
  });

  final double totalCharges;
  final double paidAmount;
  final double collectAmount;
  final double totalCashAdvance;
  final double netAmount;
  final double driverBalance;
  final int parcelCount;
}
