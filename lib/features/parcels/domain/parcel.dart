class Parcel {
  const Parcel({
    required this.trackingId,
    required this.createdAt,
    required this.fromTown,
    required this.toTown,
    required this.cityCode,
    required this.accountCode,
    required this.senderName,
    required this.senderPhone,
    required this.receiverName,
    required this.receiverPhone,
    this.ledgerId,
    required this.parcelType,
    required this.numberOfParcels,
    required this.totalCharges,
    required this.paymentStatus,
    this.cashAdvance = 0,
    this.remark,
    this.status = 'received',
    this.syncStatus = 'pending',
    this.syncedAt,
    this.arrivedAt,
    this.claimedAt,
    required this.updatedAt,
  });

  final String trackingId;
  final DateTime createdAt;
  final String fromTown;
  final String toTown;
  final String cityCode;
  final String accountCode;
  final String senderName;
  final String senderPhone;
  final String receiverName;
  final String receiverPhone;
  final String? ledgerId;
  final String parcelType;
  final int numberOfParcels;
  final double totalCharges;
  final String paymentStatus;
  final double cashAdvance;
  final String? remark;
  final String status;
  final String syncStatus;
  final DateTime? syncedAt;
  final DateTime? arrivedAt;
  final DateTime? claimedAt;
  final DateTime updatedAt;

  Parcel copyWith({
    String? trackingId,
    DateTime? createdAt,
    String? fromTown,
    String? toTown,
    String? cityCode,
    String? accountCode,
    String? senderName,
    String? senderPhone,
    String? receiverName,
    String? receiverPhone,
    String? ledgerId,
    bool clearLedgerId = false,
    String? parcelType,
    int? numberOfParcels,
    double? totalCharges,
    String? paymentStatus,
    double? cashAdvance,
    String? remark,
    bool clearRemark = false,
    String? status,
    String? syncStatus,
    DateTime? syncedAt,
    bool clearSyncedAt = false,
    DateTime? arrivedAt,
    bool clearArrivedAt = false,
    DateTime? claimedAt,
    bool clearClaimedAt = false,
    DateTime? updatedAt,
  }) {
    return Parcel(
      trackingId: trackingId ?? this.trackingId,
      createdAt: createdAt ?? this.createdAt,
      fromTown: fromTown ?? this.fromTown,
      toTown: toTown ?? this.toTown,
      cityCode: cityCode ?? this.cityCode,
      accountCode: accountCode ?? this.accountCode,
      senderName: senderName ?? this.senderName,
      senderPhone: senderPhone ?? this.senderPhone,
      receiverName: receiverName ?? this.receiverName,
      receiverPhone: receiverPhone ?? this.receiverPhone,
      ledgerId: clearLedgerId ? null : ledgerId ?? this.ledgerId,
      parcelType: parcelType ?? this.parcelType,
      numberOfParcels: numberOfParcels ?? this.numberOfParcels,
      totalCharges: totalCharges ?? this.totalCharges,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      cashAdvance: cashAdvance ?? this.cashAdvance,
      remark: clearRemark ? null : remark ?? this.remark,
      status: status ?? this.status,
      syncStatus: syncStatus ?? this.syncStatus,
      syncedAt: clearSyncedAt ? null : syncedAt ?? this.syncedAt,
      arrivedAt: clearArrivedAt ? null : arrivedAt ?? this.arrivedAt,
      claimedAt: clearClaimedAt ? null : claimedAt ?? this.claimedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
