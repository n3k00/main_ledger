class Driver {
  const Driver({
    required this.id,
    required this.name,
    this.phone,
    this.vehicleNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String? phone;
  final String? vehicleNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  Driver copyWith({
    String? id,
    String? name,
    String? phone,
    bool clearPhone = false,
    String? vehicleNumber,
    bool clearVehicleNumber = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Driver(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: clearPhone ? null : phone ?? this.phone,
      vehicleNumber: clearVehicleNumber
          ? null
          : vehicleNumber ?? this.vehicleNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
