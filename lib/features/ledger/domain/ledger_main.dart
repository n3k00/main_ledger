import 'ledger_status.dart';

class LedgerMain {
  const LedgerMain({
    required this.id,
    required this.driverId,
    required this.dispatchDate,
    this.commissionFee,
    this.laborFee,
    this.deliveryFee,
    this.otherFee,
    this.note,
    this.status = LedgerStatus.draft,
    this.settledTotalCharges,
    this.settledTotalCashAdvance,
    this.settledNetAmount,
    this.settledParcelCount,
    this.settledAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String driverId;
  final DateTime dispatchDate;
  final double? commissionFee;
  final double? laborFee;
  final double? deliveryFee;
  final double? otherFee;
  final String? note;
  final LedgerStatus status;
  final double? settledTotalCharges;
  final double? settledTotalCashAdvance;
  final double? settledNetAmount;
  final int? settledParcelCount;
  final DateTime? settledAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  double get totalDeductions {
    return (commissionFee ?? 0) +
        (laborFee ?? 0) +
        (deliveryFee ?? 0) +
        (otherFee ?? 0);
  }

  LedgerMain copyWith({
    String? id,
    String? driverId,
    DateTime? dispatchDate,
    double? commissionFee,
    bool clearCommissionFee = false,
    double? laborFee,
    bool clearLaborFee = false,
    double? deliveryFee,
    bool clearDeliveryFee = false,
    double? otherFee,
    bool clearOtherFee = false,
    String? note,
    bool clearNote = false,
    LedgerStatus? status,
    double? settledTotalCharges,
    bool clearSettledTotalCharges = false,
    double? settledTotalCashAdvance,
    bool clearSettledTotalCashAdvance = false,
    double? settledNetAmount,
    bool clearSettledNetAmount = false,
    int? settledParcelCount,
    bool clearSettledParcelCount = false,
    DateTime? settledAt,
    bool clearSettledAt = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LedgerMain(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      dispatchDate: dispatchDate ?? this.dispatchDate,
      commissionFee: clearCommissionFee
          ? null
          : commissionFee ?? this.commissionFee,
      laborFee: clearLaborFee ? null : laborFee ?? this.laborFee,
      deliveryFee: clearDeliveryFee ? null : deliveryFee ?? this.deliveryFee,
      otherFee: clearOtherFee ? null : otherFee ?? this.otherFee,
      note: clearNote ? null : note ?? this.note,
      status: status ?? this.status,
      settledTotalCharges: clearSettledTotalCharges
          ? null
          : settledTotalCharges ?? this.settledTotalCharges,
      settledTotalCashAdvance: clearSettledTotalCashAdvance
          ? null
          : settledTotalCashAdvance ?? this.settledTotalCashAdvance,
      settledNetAmount: clearSettledNetAmount
          ? null
          : settledNetAmount ?? this.settledNetAmount,
      settledParcelCount: clearSettledParcelCount
          ? null
          : settledParcelCount ?? this.settledParcelCount,
      settledAt: clearSettledAt ? null : settledAt ?? this.settledAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
