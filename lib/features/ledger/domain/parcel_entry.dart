class ParcelEntry {
  const ParcelEntry({
    required this.customer,
    required this.route,
    required this.parcelCount,
    required this.grossAmount,
    required this.deductions,
  });

  final String customer;
  final String route;
  final int parcelCount;
  final int grossAmount;
  final int deductions;

  int get balance => grossAmount - deductions;
}
