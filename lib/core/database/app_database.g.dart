// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
mixin _$DriversDaoMixin on DatabaseAccessor<AppDatabase> {
  $DriversTable get drivers => attachedDatabase.drivers;
  DriversDaoManager get managers => DriversDaoManager(this);
}

class DriversDaoManager {
  final _$DriversDaoMixin _db;
  DriversDaoManager(this._db);
  $$DriversTableTableManager get drivers =>
      $$DriversTableTableManager(_db.attachedDatabase, _db.drivers);
}

mixin _$LedgerMainsDaoMixin on DatabaseAccessor<AppDatabase> {
  $DriversTable get drivers => attachedDatabase.drivers;
  $LedgerMainsTable get ledgerMains => attachedDatabase.ledgerMains;
  LedgerMainsDaoManager get managers => LedgerMainsDaoManager(this);
}

class LedgerMainsDaoManager {
  final _$LedgerMainsDaoMixin _db;
  LedgerMainsDaoManager(this._db);
  $$DriversTableTableManager get drivers =>
      $$DriversTableTableManager(_db.attachedDatabase, _db.drivers);
  $$LedgerMainsTableTableManager get ledgerMains =>
      $$LedgerMainsTableTableManager(_db.attachedDatabase, _db.ledgerMains);
}

mixin _$ParcelsDaoMixin on DatabaseAccessor<AppDatabase> {
  $DriversTable get drivers => attachedDatabase.drivers;
  $LedgerMainsTable get ledgerMains => attachedDatabase.ledgerMains;
  $ParcelsTable get parcels => attachedDatabase.parcels;
  ParcelsDaoManager get managers => ParcelsDaoManager(this);
}

class ParcelsDaoManager {
  final _$ParcelsDaoMixin _db;
  ParcelsDaoManager(this._db);
  $$DriversTableTableManager get drivers =>
      $$DriversTableTableManager(_db.attachedDatabase, _db.drivers);
  $$LedgerMainsTableTableManager get ledgerMains =>
      $$LedgerMainsTableTableManager(_db.attachedDatabase, _db.ledgerMains);
  $$ParcelsTableTableManager get parcels =>
      $$ParcelsTableTableManager(_db.attachedDatabase, _db.parcels);
}

class $DriversTable extends Drivers with TableInfo<$DriversTable, DriverRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriversTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vehicleNumberMeta = const VerificationMeta(
    'vehicleNumber',
  );
  @override
  late final GeneratedColumn<String> vehicleNumber = GeneratedColumn<String>(
    'vehicle_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    phone,
    vehicleNumber,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drivers';
  @override
  VerificationContext validateIntegrity(
    Insertable<DriverRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('vehicle_number')) {
      context.handle(
        _vehicleNumberMeta,
        vehicleNumber.isAcceptableOrUnknown(
          data['vehicle_number']!,
          _vehicleNumberMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriverRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriverRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      vehicleNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_number'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DriversTable createAlias(String alias) {
    return $DriversTable(attachedDatabase, alias);
  }
}

class DriverRow extends DataClass implements Insertable<DriverRow> {
  final String id;
  final String name;
  final String? phone;
  final String? vehicleNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DriverRow({
    required this.id,
    required this.name,
    this.phone,
    this.vehicleNumber,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || vehicleNumber != null) {
      map['vehicle_number'] = Variable<String>(vehicleNumber);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DriversCompanion toCompanion(bool nullToAbsent) {
    return DriversCompanion(
      id: Value(id),
      name: Value(name),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      vehicleNumber: vehicleNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(vehicleNumber),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DriverRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriverRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      vehicleNumber: serializer.fromJson<String?>(json['vehicleNumber']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'vehicleNumber': serializer.toJson<String?>(vehicleNumber),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DriverRow copyWith({
    String? id,
    String? name,
    Value<String?> phone = const Value.absent(),
    Value<String?> vehicleNumber = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => DriverRow(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone.present ? phone.value : this.phone,
    vehicleNumber: vehicleNumber.present
        ? vehicleNumber.value
        : this.vehicleNumber,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DriverRow copyWithCompanion(DriversCompanion data) {
    return DriverRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      vehicleNumber: data.vehicleNumber.present
          ? data.vehicleNumber.value
          : this.vehicleNumber,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriverRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('vehicleNumber: $vehicleNumber, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, phone, vehicleNumber, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriverRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.vehicleNumber == this.vehicleNumber &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DriversCompanion extends UpdateCompanion<DriverRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> vehicleNumber;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DriversCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.vehicleNumber = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DriversCompanion.insert({
    required String id,
    required String name,
    this.phone = const Value.absent(),
    this.vehicleNumber = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<DriverRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? vehicleNumber,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (vehicleNumber != null) 'vehicle_number': vehicleNumber,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DriversCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? phone,
    Value<String?>? vehicleNumber,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DriversCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (vehicleNumber.present) {
      map['vehicle_number'] = Variable<String>(vehicleNumber.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriversCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('vehicleNumber: $vehicleNumber, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LedgerMainsTable extends LedgerMains
    with TableInfo<$LedgerMainsTable, LedgerMainRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LedgerMainsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _driverIdMeta = const VerificationMeta(
    'driverId',
  );
  @override
  late final GeneratedColumn<String> driverId = GeneratedColumn<String>(
    'driver_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES drivers (id)',
    ),
  );
  static const VerificationMeta _dispatchDateMeta = const VerificationMeta(
    'dispatchDate',
  );
  @override
  late final GeneratedColumn<DateTime> dispatchDate = GeneratedColumn<DateTime>(
    'dispatch_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _commissionFeeMeta = const VerificationMeta(
    'commissionFee',
  );
  @override
  late final GeneratedColumn<double> commissionFee = GeneratedColumn<double>(
    'commission_fee',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _laborFeeMeta = const VerificationMeta(
    'laborFee',
  );
  @override
  late final GeneratedColumn<double> laborFee = GeneratedColumn<double>(
    'labor_fee',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deliveryFeeMeta = const VerificationMeta(
    'deliveryFee',
  );
  @override
  late final GeneratedColumn<double> deliveryFee = GeneratedColumn<double>(
    'delivery_fee',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _otherFeeMeta = const VerificationMeta(
    'otherFee',
  );
  @override
  late final GeneratedColumn<double> otherFee = GeneratedColumn<double>(
    'other_fee',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('draft'),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _settledTotalChargesMeta =
      const VerificationMeta('settledTotalCharges');
  @override
  late final GeneratedColumn<double> settledTotalCharges =
      GeneratedColumn<double>(
        'settled_total_charges',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _settledTotalCashAdvanceMeta =
      const VerificationMeta('settledTotalCashAdvance');
  @override
  late final GeneratedColumn<double> settledTotalCashAdvance =
      GeneratedColumn<double>(
        'settled_total_cash_advance',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _settledNetAmountMeta = const VerificationMeta(
    'settledNetAmount',
  );
  @override
  late final GeneratedColumn<double> settledNetAmount = GeneratedColumn<double>(
    'settled_net_amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _settledParcelCountMeta =
      const VerificationMeta('settledParcelCount');
  @override
  late final GeneratedColumn<int> settledParcelCount = GeneratedColumn<int>(
    'settled_parcel_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _settledAtMeta = const VerificationMeta(
    'settledAt',
  );
  @override
  late final GeneratedColumn<DateTime> settledAt = GeneratedColumn<DateTime>(
    'settled_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    driverId,
    dispatchDate,
    commissionFee,
    laborFee,
    deliveryFee,
    otherFee,
    status,
    note,
    settledTotalCharges,
    settledTotalCashAdvance,
    settledNetAmount,
    settledParcelCount,
    settledAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ledger_mains';
  @override
  VerificationContext validateIntegrity(
    Insertable<LedgerMainRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('driver_id')) {
      context.handle(
        _driverIdMeta,
        driverId.isAcceptableOrUnknown(data['driver_id']!, _driverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_driverIdMeta);
    }
    if (data.containsKey('dispatch_date')) {
      context.handle(
        _dispatchDateMeta,
        dispatchDate.isAcceptableOrUnknown(
          data['dispatch_date']!,
          _dispatchDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dispatchDateMeta);
    }
    if (data.containsKey('commission_fee')) {
      context.handle(
        _commissionFeeMeta,
        commissionFee.isAcceptableOrUnknown(
          data['commission_fee']!,
          _commissionFeeMeta,
        ),
      );
    }
    if (data.containsKey('labor_fee')) {
      context.handle(
        _laborFeeMeta,
        laborFee.isAcceptableOrUnknown(data['labor_fee']!, _laborFeeMeta),
      );
    }
    if (data.containsKey('delivery_fee')) {
      context.handle(
        _deliveryFeeMeta,
        deliveryFee.isAcceptableOrUnknown(
          data['delivery_fee']!,
          _deliveryFeeMeta,
        ),
      );
    }
    if (data.containsKey('other_fee')) {
      context.handle(
        _otherFeeMeta,
        otherFee.isAcceptableOrUnknown(data['other_fee']!, _otherFeeMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('settled_total_charges')) {
      context.handle(
        _settledTotalChargesMeta,
        settledTotalCharges.isAcceptableOrUnknown(
          data['settled_total_charges']!,
          _settledTotalChargesMeta,
        ),
      );
    }
    if (data.containsKey('settled_total_cash_advance')) {
      context.handle(
        _settledTotalCashAdvanceMeta,
        settledTotalCashAdvance.isAcceptableOrUnknown(
          data['settled_total_cash_advance']!,
          _settledTotalCashAdvanceMeta,
        ),
      );
    }
    if (data.containsKey('settled_net_amount')) {
      context.handle(
        _settledNetAmountMeta,
        settledNetAmount.isAcceptableOrUnknown(
          data['settled_net_amount']!,
          _settledNetAmountMeta,
        ),
      );
    }
    if (data.containsKey('settled_parcel_count')) {
      context.handle(
        _settledParcelCountMeta,
        settledParcelCount.isAcceptableOrUnknown(
          data['settled_parcel_count']!,
          _settledParcelCountMeta,
        ),
      );
    }
    if (data.containsKey('settled_at')) {
      context.handle(
        _settledAtMeta,
        settledAt.isAcceptableOrUnknown(data['settled_at']!, _settledAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LedgerMainRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LedgerMainRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      driverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}driver_id'],
      )!,
      dispatchDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}dispatch_date'],
      )!,
      commissionFee: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}commission_fee'],
      ),
      laborFee: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}labor_fee'],
      ),
      deliveryFee: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}delivery_fee'],
      ),
      otherFee: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}other_fee'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      settledTotalCharges: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}settled_total_charges'],
      ),
      settledTotalCashAdvance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}settled_total_cash_advance'],
      ),
      settledNetAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}settled_net_amount'],
      ),
      settledParcelCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}settled_parcel_count'],
      ),
      settledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}settled_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LedgerMainsTable createAlias(String alias) {
    return $LedgerMainsTable(attachedDatabase, alias);
  }
}

class LedgerMainRow extends DataClass implements Insertable<LedgerMainRow> {
  final String id;
  final String driverId;
  final DateTime dispatchDate;
  final double? commissionFee;
  final double? laborFee;
  final double? deliveryFee;
  final double? otherFee;
  final String status;
  final String? note;
  final double? settledTotalCharges;
  final double? settledTotalCashAdvance;
  final double? settledNetAmount;
  final int? settledParcelCount;
  final DateTime? settledAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const LedgerMainRow({
    required this.id,
    required this.driverId,
    required this.dispatchDate,
    this.commissionFee,
    this.laborFee,
    this.deliveryFee,
    this.otherFee,
    required this.status,
    this.note,
    this.settledTotalCharges,
    this.settledTotalCashAdvance,
    this.settledNetAmount,
    this.settledParcelCount,
    this.settledAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['driver_id'] = Variable<String>(driverId);
    map['dispatch_date'] = Variable<DateTime>(dispatchDate);
    if (!nullToAbsent || commissionFee != null) {
      map['commission_fee'] = Variable<double>(commissionFee);
    }
    if (!nullToAbsent || laborFee != null) {
      map['labor_fee'] = Variable<double>(laborFee);
    }
    if (!nullToAbsent || deliveryFee != null) {
      map['delivery_fee'] = Variable<double>(deliveryFee);
    }
    if (!nullToAbsent || otherFee != null) {
      map['other_fee'] = Variable<double>(otherFee);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || settledTotalCharges != null) {
      map['settled_total_charges'] = Variable<double>(settledTotalCharges);
    }
    if (!nullToAbsent || settledTotalCashAdvance != null) {
      map['settled_total_cash_advance'] = Variable<double>(
        settledTotalCashAdvance,
      );
    }
    if (!nullToAbsent || settledNetAmount != null) {
      map['settled_net_amount'] = Variable<double>(settledNetAmount);
    }
    if (!nullToAbsent || settledParcelCount != null) {
      map['settled_parcel_count'] = Variable<int>(settledParcelCount);
    }
    if (!nullToAbsent || settledAt != null) {
      map['settled_at'] = Variable<DateTime>(settledAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LedgerMainsCompanion toCompanion(bool nullToAbsent) {
    return LedgerMainsCompanion(
      id: Value(id),
      driverId: Value(driverId),
      dispatchDate: Value(dispatchDate),
      commissionFee: commissionFee == null && nullToAbsent
          ? const Value.absent()
          : Value(commissionFee),
      laborFee: laborFee == null && nullToAbsent
          ? const Value.absent()
          : Value(laborFee),
      deliveryFee: deliveryFee == null && nullToAbsent
          ? const Value.absent()
          : Value(deliveryFee),
      otherFee: otherFee == null && nullToAbsent
          ? const Value.absent()
          : Value(otherFee),
      status: Value(status),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      settledTotalCharges: settledTotalCharges == null && nullToAbsent
          ? const Value.absent()
          : Value(settledTotalCharges),
      settledTotalCashAdvance: settledTotalCashAdvance == null && nullToAbsent
          ? const Value.absent()
          : Value(settledTotalCashAdvance),
      settledNetAmount: settledNetAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(settledNetAmount),
      settledParcelCount: settledParcelCount == null && nullToAbsent
          ? const Value.absent()
          : Value(settledParcelCount),
      settledAt: settledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(settledAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LedgerMainRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LedgerMainRow(
      id: serializer.fromJson<String>(json['id']),
      driverId: serializer.fromJson<String>(json['driverId']),
      dispatchDate: serializer.fromJson<DateTime>(json['dispatchDate']),
      commissionFee: serializer.fromJson<double?>(json['commissionFee']),
      laborFee: serializer.fromJson<double?>(json['laborFee']),
      deliveryFee: serializer.fromJson<double?>(json['deliveryFee']),
      otherFee: serializer.fromJson<double?>(json['otherFee']),
      status: serializer.fromJson<String>(json['status']),
      note: serializer.fromJson<String?>(json['note']),
      settledTotalCharges: serializer.fromJson<double?>(
        json['settledTotalCharges'],
      ),
      settledTotalCashAdvance: serializer.fromJson<double?>(
        json['settledTotalCashAdvance'],
      ),
      settledNetAmount: serializer.fromJson<double?>(json['settledNetAmount']),
      settledParcelCount: serializer.fromJson<int?>(json['settledParcelCount']),
      settledAt: serializer.fromJson<DateTime?>(json['settledAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'driverId': serializer.toJson<String>(driverId),
      'dispatchDate': serializer.toJson<DateTime>(dispatchDate),
      'commissionFee': serializer.toJson<double?>(commissionFee),
      'laborFee': serializer.toJson<double?>(laborFee),
      'deliveryFee': serializer.toJson<double?>(deliveryFee),
      'otherFee': serializer.toJson<double?>(otherFee),
      'status': serializer.toJson<String>(status),
      'note': serializer.toJson<String?>(note),
      'settledTotalCharges': serializer.toJson<double?>(settledTotalCharges),
      'settledTotalCashAdvance': serializer.toJson<double?>(
        settledTotalCashAdvance,
      ),
      'settledNetAmount': serializer.toJson<double?>(settledNetAmount),
      'settledParcelCount': serializer.toJson<int?>(settledParcelCount),
      'settledAt': serializer.toJson<DateTime?>(settledAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LedgerMainRow copyWith({
    String? id,
    String? driverId,
    DateTime? dispatchDate,
    Value<double?> commissionFee = const Value.absent(),
    Value<double?> laborFee = const Value.absent(),
    Value<double?> deliveryFee = const Value.absent(),
    Value<double?> otherFee = const Value.absent(),
    String? status,
    Value<String?> note = const Value.absent(),
    Value<double?> settledTotalCharges = const Value.absent(),
    Value<double?> settledTotalCashAdvance = const Value.absent(),
    Value<double?> settledNetAmount = const Value.absent(),
    Value<int?> settledParcelCount = const Value.absent(),
    Value<DateTime?> settledAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => LedgerMainRow(
    id: id ?? this.id,
    driverId: driverId ?? this.driverId,
    dispatchDate: dispatchDate ?? this.dispatchDate,
    commissionFee: commissionFee.present
        ? commissionFee.value
        : this.commissionFee,
    laborFee: laborFee.present ? laborFee.value : this.laborFee,
    deliveryFee: deliveryFee.present ? deliveryFee.value : this.deliveryFee,
    otherFee: otherFee.present ? otherFee.value : this.otherFee,
    status: status ?? this.status,
    note: note.present ? note.value : this.note,
    settledTotalCharges: settledTotalCharges.present
        ? settledTotalCharges.value
        : this.settledTotalCharges,
    settledTotalCashAdvance: settledTotalCashAdvance.present
        ? settledTotalCashAdvance.value
        : this.settledTotalCashAdvance,
    settledNetAmount: settledNetAmount.present
        ? settledNetAmount.value
        : this.settledNetAmount,
    settledParcelCount: settledParcelCount.present
        ? settledParcelCount.value
        : this.settledParcelCount,
    settledAt: settledAt.present ? settledAt.value : this.settledAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LedgerMainRow copyWithCompanion(LedgerMainsCompanion data) {
    return LedgerMainRow(
      id: data.id.present ? data.id.value : this.id,
      driverId: data.driverId.present ? data.driverId.value : this.driverId,
      dispatchDate: data.dispatchDate.present
          ? data.dispatchDate.value
          : this.dispatchDate,
      commissionFee: data.commissionFee.present
          ? data.commissionFee.value
          : this.commissionFee,
      laborFee: data.laborFee.present ? data.laborFee.value : this.laborFee,
      deliveryFee: data.deliveryFee.present
          ? data.deliveryFee.value
          : this.deliveryFee,
      otherFee: data.otherFee.present ? data.otherFee.value : this.otherFee,
      status: data.status.present ? data.status.value : this.status,
      note: data.note.present ? data.note.value : this.note,
      settledTotalCharges: data.settledTotalCharges.present
          ? data.settledTotalCharges.value
          : this.settledTotalCharges,
      settledTotalCashAdvance: data.settledTotalCashAdvance.present
          ? data.settledTotalCashAdvance.value
          : this.settledTotalCashAdvance,
      settledNetAmount: data.settledNetAmount.present
          ? data.settledNetAmount.value
          : this.settledNetAmount,
      settledParcelCount: data.settledParcelCount.present
          ? data.settledParcelCount.value
          : this.settledParcelCount,
      settledAt: data.settledAt.present ? data.settledAt.value : this.settledAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LedgerMainRow(')
          ..write('id: $id, ')
          ..write('driverId: $driverId, ')
          ..write('dispatchDate: $dispatchDate, ')
          ..write('commissionFee: $commissionFee, ')
          ..write('laborFee: $laborFee, ')
          ..write('deliveryFee: $deliveryFee, ')
          ..write('otherFee: $otherFee, ')
          ..write('status: $status, ')
          ..write('note: $note, ')
          ..write('settledTotalCharges: $settledTotalCharges, ')
          ..write('settledTotalCashAdvance: $settledTotalCashAdvance, ')
          ..write('settledNetAmount: $settledNetAmount, ')
          ..write('settledParcelCount: $settledParcelCount, ')
          ..write('settledAt: $settledAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    driverId,
    dispatchDate,
    commissionFee,
    laborFee,
    deliveryFee,
    otherFee,
    status,
    note,
    settledTotalCharges,
    settledTotalCashAdvance,
    settledNetAmount,
    settledParcelCount,
    settledAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LedgerMainRow &&
          other.id == this.id &&
          other.driverId == this.driverId &&
          other.dispatchDate == this.dispatchDate &&
          other.commissionFee == this.commissionFee &&
          other.laborFee == this.laborFee &&
          other.deliveryFee == this.deliveryFee &&
          other.otherFee == this.otherFee &&
          other.status == this.status &&
          other.note == this.note &&
          other.settledTotalCharges == this.settledTotalCharges &&
          other.settledTotalCashAdvance == this.settledTotalCashAdvance &&
          other.settledNetAmount == this.settledNetAmount &&
          other.settledParcelCount == this.settledParcelCount &&
          other.settledAt == this.settledAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LedgerMainsCompanion extends UpdateCompanion<LedgerMainRow> {
  final Value<String> id;
  final Value<String> driverId;
  final Value<DateTime> dispatchDate;
  final Value<double?> commissionFee;
  final Value<double?> laborFee;
  final Value<double?> deliveryFee;
  final Value<double?> otherFee;
  final Value<String> status;
  final Value<String?> note;
  final Value<double?> settledTotalCharges;
  final Value<double?> settledTotalCashAdvance;
  final Value<double?> settledNetAmount;
  final Value<int?> settledParcelCount;
  final Value<DateTime?> settledAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LedgerMainsCompanion({
    this.id = const Value.absent(),
    this.driverId = const Value.absent(),
    this.dispatchDate = const Value.absent(),
    this.commissionFee = const Value.absent(),
    this.laborFee = const Value.absent(),
    this.deliveryFee = const Value.absent(),
    this.otherFee = const Value.absent(),
    this.status = const Value.absent(),
    this.note = const Value.absent(),
    this.settledTotalCharges = const Value.absent(),
    this.settledTotalCashAdvance = const Value.absent(),
    this.settledNetAmount = const Value.absent(),
    this.settledParcelCount = const Value.absent(),
    this.settledAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LedgerMainsCompanion.insert({
    required String id,
    required String driverId,
    required DateTime dispatchDate,
    this.commissionFee = const Value.absent(),
    this.laborFee = const Value.absent(),
    this.deliveryFee = const Value.absent(),
    this.otherFee = const Value.absent(),
    this.status = const Value.absent(),
    this.note = const Value.absent(),
    this.settledTotalCharges = const Value.absent(),
    this.settledTotalCashAdvance = const Value.absent(),
    this.settledNetAmount = const Value.absent(),
    this.settledParcelCount = const Value.absent(),
    this.settledAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       driverId = Value(driverId),
       dispatchDate = Value(dispatchDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LedgerMainRow> custom({
    Expression<String>? id,
    Expression<String>? driverId,
    Expression<DateTime>? dispatchDate,
    Expression<double>? commissionFee,
    Expression<double>? laborFee,
    Expression<double>? deliveryFee,
    Expression<double>? otherFee,
    Expression<String>? status,
    Expression<String>? note,
    Expression<double>? settledTotalCharges,
    Expression<double>? settledTotalCashAdvance,
    Expression<double>? settledNetAmount,
    Expression<int>? settledParcelCount,
    Expression<DateTime>? settledAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (driverId != null) 'driver_id': driverId,
      if (dispatchDate != null) 'dispatch_date': dispatchDate,
      if (commissionFee != null) 'commission_fee': commissionFee,
      if (laborFee != null) 'labor_fee': laborFee,
      if (deliveryFee != null) 'delivery_fee': deliveryFee,
      if (otherFee != null) 'other_fee': otherFee,
      if (status != null) 'status': status,
      if (note != null) 'note': note,
      if (settledTotalCharges != null)
        'settled_total_charges': settledTotalCharges,
      if (settledTotalCashAdvance != null)
        'settled_total_cash_advance': settledTotalCashAdvance,
      if (settledNetAmount != null) 'settled_net_amount': settledNetAmount,
      if (settledParcelCount != null)
        'settled_parcel_count': settledParcelCount,
      if (settledAt != null) 'settled_at': settledAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LedgerMainsCompanion copyWith({
    Value<String>? id,
    Value<String>? driverId,
    Value<DateTime>? dispatchDate,
    Value<double?>? commissionFee,
    Value<double?>? laborFee,
    Value<double?>? deliveryFee,
    Value<double?>? otherFee,
    Value<String>? status,
    Value<String?>? note,
    Value<double?>? settledTotalCharges,
    Value<double?>? settledTotalCashAdvance,
    Value<double?>? settledNetAmount,
    Value<int?>? settledParcelCount,
    Value<DateTime?>? settledAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LedgerMainsCompanion(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      dispatchDate: dispatchDate ?? this.dispatchDate,
      commissionFee: commissionFee ?? this.commissionFee,
      laborFee: laborFee ?? this.laborFee,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      otherFee: otherFee ?? this.otherFee,
      status: status ?? this.status,
      note: note ?? this.note,
      settledTotalCharges: settledTotalCharges ?? this.settledTotalCharges,
      settledTotalCashAdvance:
          settledTotalCashAdvance ?? this.settledTotalCashAdvance,
      settledNetAmount: settledNetAmount ?? this.settledNetAmount,
      settledParcelCount: settledParcelCount ?? this.settledParcelCount,
      settledAt: settledAt ?? this.settledAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (driverId.present) {
      map['driver_id'] = Variable<String>(driverId.value);
    }
    if (dispatchDate.present) {
      map['dispatch_date'] = Variable<DateTime>(dispatchDate.value);
    }
    if (commissionFee.present) {
      map['commission_fee'] = Variable<double>(commissionFee.value);
    }
    if (laborFee.present) {
      map['labor_fee'] = Variable<double>(laborFee.value);
    }
    if (deliveryFee.present) {
      map['delivery_fee'] = Variable<double>(deliveryFee.value);
    }
    if (otherFee.present) {
      map['other_fee'] = Variable<double>(otherFee.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (settledTotalCharges.present) {
      map['settled_total_charges'] = Variable<double>(
        settledTotalCharges.value,
      );
    }
    if (settledTotalCashAdvance.present) {
      map['settled_total_cash_advance'] = Variable<double>(
        settledTotalCashAdvance.value,
      );
    }
    if (settledNetAmount.present) {
      map['settled_net_amount'] = Variable<double>(settledNetAmount.value);
    }
    if (settledParcelCount.present) {
      map['settled_parcel_count'] = Variable<int>(settledParcelCount.value);
    }
    if (settledAt.present) {
      map['settled_at'] = Variable<DateTime>(settledAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LedgerMainsCompanion(')
          ..write('id: $id, ')
          ..write('driverId: $driverId, ')
          ..write('dispatchDate: $dispatchDate, ')
          ..write('commissionFee: $commissionFee, ')
          ..write('laborFee: $laborFee, ')
          ..write('deliveryFee: $deliveryFee, ')
          ..write('otherFee: $otherFee, ')
          ..write('status: $status, ')
          ..write('note: $note, ')
          ..write('settledTotalCharges: $settledTotalCharges, ')
          ..write('settledTotalCashAdvance: $settledTotalCashAdvance, ')
          ..write('settledNetAmount: $settledNetAmount, ')
          ..write('settledParcelCount: $settledParcelCount, ')
          ..write('settledAt: $settledAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ParcelsTable extends Parcels with TableInfo<$ParcelsTable, ParcelRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParcelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _trackingIdMeta = const VerificationMeta(
    'trackingId',
  );
  @override
  late final GeneratedColumn<String> trackingId = GeneratedColumn<String>(
    'tracking_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromTownMeta = const VerificationMeta(
    'fromTown',
  );
  @override
  late final GeneratedColumn<String> fromTown = GeneratedColumn<String>(
    'from_town',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toTownMeta = const VerificationMeta('toTown');
  @override
  late final GeneratedColumn<String> toTown = GeneratedColumn<String>(
    'to_town',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cityCodeMeta = const VerificationMeta(
    'cityCode',
  );
  @override
  late final GeneratedColumn<String> cityCode = GeneratedColumn<String>(
    'city_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountCodeMeta = const VerificationMeta(
    'accountCode',
  );
  @override
  late final GeneratedColumn<String> accountCode = GeneratedColumn<String>(
    'account_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _senderNameMeta = const VerificationMeta(
    'senderName',
  );
  @override
  late final GeneratedColumn<String> senderName = GeneratedColumn<String>(
    'sender_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _senderPhoneMeta = const VerificationMeta(
    'senderPhone',
  );
  @override
  late final GeneratedColumn<String> senderPhone = GeneratedColumn<String>(
    'sender_phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receiverNameMeta = const VerificationMeta(
    'receiverName',
  );
  @override
  late final GeneratedColumn<String> receiverName = GeneratedColumn<String>(
    'receiver_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receiverPhoneMeta = const VerificationMeta(
    'receiverPhone',
  );
  @override
  late final GeneratedColumn<String> receiverPhone = GeneratedColumn<String>(
    'receiver_phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ledgerIdMeta = const VerificationMeta(
    'ledgerId',
  );
  @override
  late final GeneratedColumn<String> ledgerId = GeneratedColumn<String>(
    'ledger_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ledger_mains (id)',
    ),
  );
  static const VerificationMeta _parcelTypeMeta = const VerificationMeta(
    'parcelType',
  );
  @override
  late final GeneratedColumn<String> parcelType = GeneratedColumn<String>(
    'parcel_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numberOfParcelsMeta = const VerificationMeta(
    'numberOfParcels',
  );
  @override
  late final GeneratedColumn<int> numberOfParcels = GeneratedColumn<int>(
    'number_of_parcels',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalChargesMeta = const VerificationMeta(
    'totalCharges',
  );
  @override
  late final GeneratedColumn<double> totalCharges = GeneratedColumn<double>(
    'total_charges',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentStatusMeta = const VerificationMeta(
    'paymentStatus',
  );
  @override
  late final GeneratedColumn<String> paymentStatus = GeneratedColumn<String>(
    'payment_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cashAdvanceMeta = const VerificationMeta(
    'cashAdvance',
  );
  @override
  late final GeneratedColumn<double> cashAdvance = GeneratedColumn<double>(
    'cash_advance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _remarkMeta = const VerificationMeta('remark');
  @override
  late final GeneratedColumn<String> remark = GeneratedColumn<String>(
    'remark',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('received'),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _arrivedAtMeta = const VerificationMeta(
    'arrivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> arrivedAt = GeneratedColumn<DateTime>(
    'arrived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _claimedAtMeta = const VerificationMeta(
    'claimedAt',
  );
  @override
  late final GeneratedColumn<DateTime> claimedAt = GeneratedColumn<DateTime>(
    'claimed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    trackingId,
    createdAt,
    fromTown,
    toTown,
    cityCode,
    accountCode,
    senderName,
    senderPhone,
    receiverName,
    receiverPhone,
    ledgerId,
    parcelType,
    numberOfParcels,
    totalCharges,
    paymentStatus,
    cashAdvance,
    remark,
    status,
    syncStatus,
    syncedAt,
    arrivedAt,
    claimedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parcels';
  @override
  VerificationContext validateIntegrity(
    Insertable<ParcelRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('tracking_id')) {
      context.handle(
        _trackingIdMeta,
        trackingId.isAcceptableOrUnknown(data['tracking_id']!, _trackingIdMeta),
      );
    } else if (isInserting) {
      context.missing(_trackingIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('from_town')) {
      context.handle(
        _fromTownMeta,
        fromTown.isAcceptableOrUnknown(data['from_town']!, _fromTownMeta),
      );
    } else if (isInserting) {
      context.missing(_fromTownMeta);
    }
    if (data.containsKey('to_town')) {
      context.handle(
        _toTownMeta,
        toTown.isAcceptableOrUnknown(data['to_town']!, _toTownMeta),
      );
    } else if (isInserting) {
      context.missing(_toTownMeta);
    }
    if (data.containsKey('city_code')) {
      context.handle(
        _cityCodeMeta,
        cityCode.isAcceptableOrUnknown(data['city_code']!, _cityCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_cityCodeMeta);
    }
    if (data.containsKey('account_code')) {
      context.handle(
        _accountCodeMeta,
        accountCode.isAcceptableOrUnknown(
          data['account_code']!,
          _accountCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accountCodeMeta);
    }
    if (data.containsKey('sender_name')) {
      context.handle(
        _senderNameMeta,
        senderName.isAcceptableOrUnknown(data['sender_name']!, _senderNameMeta),
      );
    } else if (isInserting) {
      context.missing(_senderNameMeta);
    }
    if (data.containsKey('sender_phone')) {
      context.handle(
        _senderPhoneMeta,
        senderPhone.isAcceptableOrUnknown(
          data['sender_phone']!,
          _senderPhoneMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_senderPhoneMeta);
    }
    if (data.containsKey('receiver_name')) {
      context.handle(
        _receiverNameMeta,
        receiverName.isAcceptableOrUnknown(
          data['receiver_name']!,
          _receiverNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_receiverNameMeta);
    }
    if (data.containsKey('receiver_phone')) {
      context.handle(
        _receiverPhoneMeta,
        receiverPhone.isAcceptableOrUnknown(
          data['receiver_phone']!,
          _receiverPhoneMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_receiverPhoneMeta);
    }
    if (data.containsKey('ledger_id')) {
      context.handle(
        _ledgerIdMeta,
        ledgerId.isAcceptableOrUnknown(data['ledger_id']!, _ledgerIdMeta),
      );
    }
    if (data.containsKey('parcel_type')) {
      context.handle(
        _parcelTypeMeta,
        parcelType.isAcceptableOrUnknown(data['parcel_type']!, _parcelTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_parcelTypeMeta);
    }
    if (data.containsKey('number_of_parcels')) {
      context.handle(
        _numberOfParcelsMeta,
        numberOfParcels.isAcceptableOrUnknown(
          data['number_of_parcels']!,
          _numberOfParcelsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_numberOfParcelsMeta);
    }
    if (data.containsKey('total_charges')) {
      context.handle(
        _totalChargesMeta,
        totalCharges.isAcceptableOrUnknown(
          data['total_charges']!,
          _totalChargesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalChargesMeta);
    }
    if (data.containsKey('payment_status')) {
      context.handle(
        _paymentStatusMeta,
        paymentStatus.isAcceptableOrUnknown(
          data['payment_status']!,
          _paymentStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentStatusMeta);
    }
    if (data.containsKey('cash_advance')) {
      context.handle(
        _cashAdvanceMeta,
        cashAdvance.isAcceptableOrUnknown(
          data['cash_advance']!,
          _cashAdvanceMeta,
        ),
      );
    }
    if (data.containsKey('remark')) {
      context.handle(
        _remarkMeta,
        remark.isAcceptableOrUnknown(data['remark']!, _remarkMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    if (data.containsKey('arrived_at')) {
      context.handle(
        _arrivedAtMeta,
        arrivedAt.isAcceptableOrUnknown(data['arrived_at']!, _arrivedAtMeta),
      );
    }
    if (data.containsKey('claimed_at')) {
      context.handle(
        _claimedAtMeta,
        claimedAt.isAcceptableOrUnknown(data['claimed_at']!, _claimedAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {trackingId};
  @override
  ParcelRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ParcelRow(
      trackingId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tracking_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      fromTown: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_town'],
      )!,
      toTown: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_town'],
      )!,
      cityCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city_code'],
      )!,
      accountCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_code'],
      )!,
      senderName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender_name'],
      )!,
      senderPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender_phone'],
      )!,
      receiverName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receiver_name'],
      )!,
      receiverPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receiver_phone'],
      )!,
      ledgerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ledger_id'],
      ),
      parcelType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parcel_type'],
      )!,
      numberOfParcels: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}number_of_parcels'],
      )!,
      totalCharges: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_charges'],
      )!,
      paymentStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_status'],
      )!,
      cashAdvance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cash_advance'],
      )!,
      remark: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remark'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
      arrivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}arrived_at'],
      ),
      claimedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}claimed_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ParcelsTable createAlias(String alias) {
    return $ParcelsTable(attachedDatabase, alias);
  }
}

class ParcelRow extends DataClass implements Insertable<ParcelRow> {
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
  const ParcelRow({
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
    required this.cashAdvance,
    this.remark,
    required this.status,
    required this.syncStatus,
    this.syncedAt,
    this.arrivedAt,
    this.claimedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['tracking_id'] = Variable<String>(trackingId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['from_town'] = Variable<String>(fromTown);
    map['to_town'] = Variable<String>(toTown);
    map['city_code'] = Variable<String>(cityCode);
    map['account_code'] = Variable<String>(accountCode);
    map['sender_name'] = Variable<String>(senderName);
    map['sender_phone'] = Variable<String>(senderPhone);
    map['receiver_name'] = Variable<String>(receiverName);
    map['receiver_phone'] = Variable<String>(receiverPhone);
    if (!nullToAbsent || ledgerId != null) {
      map['ledger_id'] = Variable<String>(ledgerId);
    }
    map['parcel_type'] = Variable<String>(parcelType);
    map['number_of_parcels'] = Variable<int>(numberOfParcels);
    map['total_charges'] = Variable<double>(totalCharges);
    map['payment_status'] = Variable<String>(paymentStatus);
    map['cash_advance'] = Variable<double>(cashAdvance);
    if (!nullToAbsent || remark != null) {
      map['remark'] = Variable<String>(remark);
    }
    map['status'] = Variable<String>(status);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    if (!nullToAbsent || arrivedAt != null) {
      map['arrived_at'] = Variable<DateTime>(arrivedAt);
    }
    if (!nullToAbsent || claimedAt != null) {
      map['claimed_at'] = Variable<DateTime>(claimedAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ParcelsCompanion toCompanion(bool nullToAbsent) {
    return ParcelsCompanion(
      trackingId: Value(trackingId),
      createdAt: Value(createdAt),
      fromTown: Value(fromTown),
      toTown: Value(toTown),
      cityCode: Value(cityCode),
      accountCode: Value(accountCode),
      senderName: Value(senderName),
      senderPhone: Value(senderPhone),
      receiverName: Value(receiverName),
      receiverPhone: Value(receiverPhone),
      ledgerId: ledgerId == null && nullToAbsent
          ? const Value.absent()
          : Value(ledgerId),
      parcelType: Value(parcelType),
      numberOfParcels: Value(numberOfParcels),
      totalCharges: Value(totalCharges),
      paymentStatus: Value(paymentStatus),
      cashAdvance: Value(cashAdvance),
      remark: remark == null && nullToAbsent
          ? const Value.absent()
          : Value(remark),
      status: Value(status),
      syncStatus: Value(syncStatus),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      arrivedAt: arrivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(arrivedAt),
      claimedAt: claimedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(claimedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ParcelRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ParcelRow(
      trackingId: serializer.fromJson<String>(json['trackingId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      fromTown: serializer.fromJson<String>(json['fromTown']),
      toTown: serializer.fromJson<String>(json['toTown']),
      cityCode: serializer.fromJson<String>(json['cityCode']),
      accountCode: serializer.fromJson<String>(json['accountCode']),
      senderName: serializer.fromJson<String>(json['senderName']),
      senderPhone: serializer.fromJson<String>(json['senderPhone']),
      receiverName: serializer.fromJson<String>(json['receiverName']),
      receiverPhone: serializer.fromJson<String>(json['receiverPhone']),
      ledgerId: serializer.fromJson<String?>(json['ledgerId']),
      parcelType: serializer.fromJson<String>(json['parcelType']),
      numberOfParcels: serializer.fromJson<int>(json['numberOfParcels']),
      totalCharges: serializer.fromJson<double>(json['totalCharges']),
      paymentStatus: serializer.fromJson<String>(json['paymentStatus']),
      cashAdvance: serializer.fromJson<double>(json['cashAdvance']),
      remark: serializer.fromJson<String?>(json['remark']),
      status: serializer.fromJson<String>(json['status']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      arrivedAt: serializer.fromJson<DateTime?>(json['arrivedAt']),
      claimedAt: serializer.fromJson<DateTime?>(json['claimedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'trackingId': serializer.toJson<String>(trackingId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'fromTown': serializer.toJson<String>(fromTown),
      'toTown': serializer.toJson<String>(toTown),
      'cityCode': serializer.toJson<String>(cityCode),
      'accountCode': serializer.toJson<String>(accountCode),
      'senderName': serializer.toJson<String>(senderName),
      'senderPhone': serializer.toJson<String>(senderPhone),
      'receiverName': serializer.toJson<String>(receiverName),
      'receiverPhone': serializer.toJson<String>(receiverPhone),
      'ledgerId': serializer.toJson<String?>(ledgerId),
      'parcelType': serializer.toJson<String>(parcelType),
      'numberOfParcels': serializer.toJson<int>(numberOfParcels),
      'totalCharges': serializer.toJson<double>(totalCharges),
      'paymentStatus': serializer.toJson<String>(paymentStatus),
      'cashAdvance': serializer.toJson<double>(cashAdvance),
      'remark': serializer.toJson<String?>(remark),
      'status': serializer.toJson<String>(status),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'arrivedAt': serializer.toJson<DateTime?>(arrivedAt),
      'claimedAt': serializer.toJson<DateTime?>(claimedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ParcelRow copyWith({
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
    Value<String?> ledgerId = const Value.absent(),
    String? parcelType,
    int? numberOfParcels,
    double? totalCharges,
    String? paymentStatus,
    double? cashAdvance,
    Value<String?> remark = const Value.absent(),
    String? status,
    String? syncStatus,
    Value<DateTime?> syncedAt = const Value.absent(),
    Value<DateTime?> arrivedAt = const Value.absent(),
    Value<DateTime?> claimedAt = const Value.absent(),
    DateTime? updatedAt,
  }) => ParcelRow(
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
    ledgerId: ledgerId.present ? ledgerId.value : this.ledgerId,
    parcelType: parcelType ?? this.parcelType,
    numberOfParcels: numberOfParcels ?? this.numberOfParcels,
    totalCharges: totalCharges ?? this.totalCharges,
    paymentStatus: paymentStatus ?? this.paymentStatus,
    cashAdvance: cashAdvance ?? this.cashAdvance,
    remark: remark.present ? remark.value : this.remark,
    status: status ?? this.status,
    syncStatus: syncStatus ?? this.syncStatus,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
    arrivedAt: arrivedAt.present ? arrivedAt.value : this.arrivedAt,
    claimedAt: claimedAt.present ? claimedAt.value : this.claimedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ParcelRow copyWithCompanion(ParcelsCompanion data) {
    return ParcelRow(
      trackingId: data.trackingId.present
          ? data.trackingId.value
          : this.trackingId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      fromTown: data.fromTown.present ? data.fromTown.value : this.fromTown,
      toTown: data.toTown.present ? data.toTown.value : this.toTown,
      cityCode: data.cityCode.present ? data.cityCode.value : this.cityCode,
      accountCode: data.accountCode.present
          ? data.accountCode.value
          : this.accountCode,
      senderName: data.senderName.present
          ? data.senderName.value
          : this.senderName,
      senderPhone: data.senderPhone.present
          ? data.senderPhone.value
          : this.senderPhone,
      receiverName: data.receiverName.present
          ? data.receiverName.value
          : this.receiverName,
      receiverPhone: data.receiverPhone.present
          ? data.receiverPhone.value
          : this.receiverPhone,
      ledgerId: data.ledgerId.present ? data.ledgerId.value : this.ledgerId,
      parcelType: data.parcelType.present
          ? data.parcelType.value
          : this.parcelType,
      numberOfParcels: data.numberOfParcels.present
          ? data.numberOfParcels.value
          : this.numberOfParcels,
      totalCharges: data.totalCharges.present
          ? data.totalCharges.value
          : this.totalCharges,
      paymentStatus: data.paymentStatus.present
          ? data.paymentStatus.value
          : this.paymentStatus,
      cashAdvance: data.cashAdvance.present
          ? data.cashAdvance.value
          : this.cashAdvance,
      remark: data.remark.present ? data.remark.value : this.remark,
      status: data.status.present ? data.status.value : this.status,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      arrivedAt: data.arrivedAt.present ? data.arrivedAt.value : this.arrivedAt,
      claimedAt: data.claimedAt.present ? data.claimedAt.value : this.claimedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ParcelRow(')
          ..write('trackingId: $trackingId, ')
          ..write('createdAt: $createdAt, ')
          ..write('fromTown: $fromTown, ')
          ..write('toTown: $toTown, ')
          ..write('cityCode: $cityCode, ')
          ..write('accountCode: $accountCode, ')
          ..write('senderName: $senderName, ')
          ..write('senderPhone: $senderPhone, ')
          ..write('receiverName: $receiverName, ')
          ..write('receiverPhone: $receiverPhone, ')
          ..write('ledgerId: $ledgerId, ')
          ..write('parcelType: $parcelType, ')
          ..write('numberOfParcels: $numberOfParcels, ')
          ..write('totalCharges: $totalCharges, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('cashAdvance: $cashAdvance, ')
          ..write('remark: $remark, ')
          ..write('status: $status, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('arrivedAt: $arrivedAt, ')
          ..write('claimedAt: $claimedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    trackingId,
    createdAt,
    fromTown,
    toTown,
    cityCode,
    accountCode,
    senderName,
    senderPhone,
    receiverName,
    receiverPhone,
    ledgerId,
    parcelType,
    numberOfParcels,
    totalCharges,
    paymentStatus,
    cashAdvance,
    remark,
    status,
    syncStatus,
    syncedAt,
    arrivedAt,
    claimedAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ParcelRow &&
          other.trackingId == this.trackingId &&
          other.createdAt == this.createdAt &&
          other.fromTown == this.fromTown &&
          other.toTown == this.toTown &&
          other.cityCode == this.cityCode &&
          other.accountCode == this.accountCode &&
          other.senderName == this.senderName &&
          other.senderPhone == this.senderPhone &&
          other.receiverName == this.receiverName &&
          other.receiverPhone == this.receiverPhone &&
          other.ledgerId == this.ledgerId &&
          other.parcelType == this.parcelType &&
          other.numberOfParcels == this.numberOfParcels &&
          other.totalCharges == this.totalCharges &&
          other.paymentStatus == this.paymentStatus &&
          other.cashAdvance == this.cashAdvance &&
          other.remark == this.remark &&
          other.status == this.status &&
          other.syncStatus == this.syncStatus &&
          other.syncedAt == this.syncedAt &&
          other.arrivedAt == this.arrivedAt &&
          other.claimedAt == this.claimedAt &&
          other.updatedAt == this.updatedAt);
}

class ParcelsCompanion extends UpdateCompanion<ParcelRow> {
  final Value<String> trackingId;
  final Value<DateTime> createdAt;
  final Value<String> fromTown;
  final Value<String> toTown;
  final Value<String> cityCode;
  final Value<String> accountCode;
  final Value<String> senderName;
  final Value<String> senderPhone;
  final Value<String> receiverName;
  final Value<String> receiverPhone;
  final Value<String?> ledgerId;
  final Value<String> parcelType;
  final Value<int> numberOfParcels;
  final Value<double> totalCharges;
  final Value<String> paymentStatus;
  final Value<double> cashAdvance;
  final Value<String?> remark;
  final Value<String> status;
  final Value<String> syncStatus;
  final Value<DateTime?> syncedAt;
  final Value<DateTime?> arrivedAt;
  final Value<DateTime?> claimedAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ParcelsCompanion({
    this.trackingId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.fromTown = const Value.absent(),
    this.toTown = const Value.absent(),
    this.cityCode = const Value.absent(),
    this.accountCode = const Value.absent(),
    this.senderName = const Value.absent(),
    this.senderPhone = const Value.absent(),
    this.receiverName = const Value.absent(),
    this.receiverPhone = const Value.absent(),
    this.ledgerId = const Value.absent(),
    this.parcelType = const Value.absent(),
    this.numberOfParcels = const Value.absent(),
    this.totalCharges = const Value.absent(),
    this.paymentStatus = const Value.absent(),
    this.cashAdvance = const Value.absent(),
    this.remark = const Value.absent(),
    this.status = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.arrivedAt = const Value.absent(),
    this.claimedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ParcelsCompanion.insert({
    required String trackingId,
    required DateTime createdAt,
    required String fromTown,
    required String toTown,
    required String cityCode,
    required String accountCode,
    required String senderName,
    required String senderPhone,
    required String receiverName,
    required String receiverPhone,
    this.ledgerId = const Value.absent(),
    required String parcelType,
    required int numberOfParcels,
    required double totalCharges,
    required String paymentStatus,
    this.cashAdvance = const Value.absent(),
    this.remark = const Value.absent(),
    this.status = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.arrivedAt = const Value.absent(),
    this.claimedAt = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : trackingId = Value(trackingId),
       createdAt = Value(createdAt),
       fromTown = Value(fromTown),
       toTown = Value(toTown),
       cityCode = Value(cityCode),
       accountCode = Value(accountCode),
       senderName = Value(senderName),
       senderPhone = Value(senderPhone),
       receiverName = Value(receiverName),
       receiverPhone = Value(receiverPhone),
       parcelType = Value(parcelType),
       numberOfParcels = Value(numberOfParcels),
       totalCharges = Value(totalCharges),
       paymentStatus = Value(paymentStatus),
       updatedAt = Value(updatedAt);
  static Insertable<ParcelRow> custom({
    Expression<String>? trackingId,
    Expression<DateTime>? createdAt,
    Expression<String>? fromTown,
    Expression<String>? toTown,
    Expression<String>? cityCode,
    Expression<String>? accountCode,
    Expression<String>? senderName,
    Expression<String>? senderPhone,
    Expression<String>? receiverName,
    Expression<String>? receiverPhone,
    Expression<String>? ledgerId,
    Expression<String>? parcelType,
    Expression<int>? numberOfParcels,
    Expression<double>? totalCharges,
    Expression<String>? paymentStatus,
    Expression<double>? cashAdvance,
    Expression<String>? remark,
    Expression<String>? status,
    Expression<String>? syncStatus,
    Expression<DateTime>? syncedAt,
    Expression<DateTime>? arrivedAt,
    Expression<DateTime>? claimedAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (trackingId != null) 'tracking_id': trackingId,
      if (createdAt != null) 'created_at': createdAt,
      if (fromTown != null) 'from_town': fromTown,
      if (toTown != null) 'to_town': toTown,
      if (cityCode != null) 'city_code': cityCode,
      if (accountCode != null) 'account_code': accountCode,
      if (senderName != null) 'sender_name': senderName,
      if (senderPhone != null) 'sender_phone': senderPhone,
      if (receiverName != null) 'receiver_name': receiverName,
      if (receiverPhone != null) 'receiver_phone': receiverPhone,
      if (ledgerId != null) 'ledger_id': ledgerId,
      if (parcelType != null) 'parcel_type': parcelType,
      if (numberOfParcels != null) 'number_of_parcels': numberOfParcels,
      if (totalCharges != null) 'total_charges': totalCharges,
      if (paymentStatus != null) 'payment_status': paymentStatus,
      if (cashAdvance != null) 'cash_advance': cashAdvance,
      if (remark != null) 'remark': remark,
      if (status != null) 'status': status,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (arrivedAt != null) 'arrived_at': arrivedAt,
      if (claimedAt != null) 'claimed_at': claimedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ParcelsCompanion copyWith({
    Value<String>? trackingId,
    Value<DateTime>? createdAt,
    Value<String>? fromTown,
    Value<String>? toTown,
    Value<String>? cityCode,
    Value<String>? accountCode,
    Value<String>? senderName,
    Value<String>? senderPhone,
    Value<String>? receiverName,
    Value<String>? receiverPhone,
    Value<String?>? ledgerId,
    Value<String>? parcelType,
    Value<int>? numberOfParcels,
    Value<double>? totalCharges,
    Value<String>? paymentStatus,
    Value<double>? cashAdvance,
    Value<String?>? remark,
    Value<String>? status,
    Value<String>? syncStatus,
    Value<DateTime?>? syncedAt,
    Value<DateTime?>? arrivedAt,
    Value<DateTime?>? claimedAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ParcelsCompanion(
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
      ledgerId: ledgerId ?? this.ledgerId,
      parcelType: parcelType ?? this.parcelType,
      numberOfParcels: numberOfParcels ?? this.numberOfParcels,
      totalCharges: totalCharges ?? this.totalCharges,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      cashAdvance: cashAdvance ?? this.cashAdvance,
      remark: remark ?? this.remark,
      status: status ?? this.status,
      syncStatus: syncStatus ?? this.syncStatus,
      syncedAt: syncedAt ?? this.syncedAt,
      arrivedAt: arrivedAt ?? this.arrivedAt,
      claimedAt: claimedAt ?? this.claimedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (trackingId.present) {
      map['tracking_id'] = Variable<String>(trackingId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (fromTown.present) {
      map['from_town'] = Variable<String>(fromTown.value);
    }
    if (toTown.present) {
      map['to_town'] = Variable<String>(toTown.value);
    }
    if (cityCode.present) {
      map['city_code'] = Variable<String>(cityCode.value);
    }
    if (accountCode.present) {
      map['account_code'] = Variable<String>(accountCode.value);
    }
    if (senderName.present) {
      map['sender_name'] = Variable<String>(senderName.value);
    }
    if (senderPhone.present) {
      map['sender_phone'] = Variable<String>(senderPhone.value);
    }
    if (receiverName.present) {
      map['receiver_name'] = Variable<String>(receiverName.value);
    }
    if (receiverPhone.present) {
      map['receiver_phone'] = Variable<String>(receiverPhone.value);
    }
    if (ledgerId.present) {
      map['ledger_id'] = Variable<String>(ledgerId.value);
    }
    if (parcelType.present) {
      map['parcel_type'] = Variable<String>(parcelType.value);
    }
    if (numberOfParcels.present) {
      map['number_of_parcels'] = Variable<int>(numberOfParcels.value);
    }
    if (totalCharges.present) {
      map['total_charges'] = Variable<double>(totalCharges.value);
    }
    if (paymentStatus.present) {
      map['payment_status'] = Variable<String>(paymentStatus.value);
    }
    if (cashAdvance.present) {
      map['cash_advance'] = Variable<double>(cashAdvance.value);
    }
    if (remark.present) {
      map['remark'] = Variable<String>(remark.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (arrivedAt.present) {
      map['arrived_at'] = Variable<DateTime>(arrivedAt.value);
    }
    if (claimedAt.present) {
      map['claimed_at'] = Variable<DateTime>(claimedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ParcelsCompanion(')
          ..write('trackingId: $trackingId, ')
          ..write('createdAt: $createdAt, ')
          ..write('fromTown: $fromTown, ')
          ..write('toTown: $toTown, ')
          ..write('cityCode: $cityCode, ')
          ..write('accountCode: $accountCode, ')
          ..write('senderName: $senderName, ')
          ..write('senderPhone: $senderPhone, ')
          ..write('receiverName: $receiverName, ')
          ..write('receiverPhone: $receiverPhone, ')
          ..write('ledgerId: $ledgerId, ')
          ..write('parcelType: $parcelType, ')
          ..write('numberOfParcels: $numberOfParcels, ')
          ..write('totalCharges: $totalCharges, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('cashAdvance: $cashAdvance, ')
          ..write('remark: $remark, ')
          ..write('status: $status, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('arrivedAt: $arrivedAt, ')
          ..write('claimedAt: $claimedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DriversTable drivers = $DriversTable(this);
  late final $LedgerMainsTable ledgerMains = $LedgerMainsTable(this);
  late final $ParcelsTable parcels = $ParcelsTable(this);
  late final DriversDao driversDao = DriversDao(this as AppDatabase);
  late final LedgerMainsDao ledgerMainsDao = LedgerMainsDao(
    this as AppDatabase,
  );
  late final ParcelsDao parcelsDao = ParcelsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    drivers,
    ledgerMains,
    parcels,
  ];
}

typedef $$DriversTableCreateCompanionBuilder =
    DriversCompanion Function({
      required String id,
      required String name,
      Value<String?> phone,
      Value<String?> vehicleNumber,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$DriversTableUpdateCompanionBuilder =
    DriversCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> phone,
      Value<String?> vehicleNumber,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$DriversTableReferences
    extends BaseReferences<_$AppDatabase, $DriversTable, DriverRow> {
  $$DriversTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LedgerMainsTable, List<LedgerMainRow>>
  _ledgerMainsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ledgerMains,
    aliasName: $_aliasNameGenerator(db.drivers.id, db.ledgerMains.driverId),
  );

  $$LedgerMainsTableProcessedTableManager get ledgerMainsRefs {
    final manager = $$LedgerMainsTableTableManager(
      $_db,
      $_db.ledgerMains,
    ).filter((f) => f.driverId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_ledgerMainsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DriversTableFilterComposer
    extends Composer<_$AppDatabase, $DriversTable> {
  $$DriversTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehicleNumber => $composableBuilder(
    column: $table.vehicleNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> ledgerMainsRefs(
    Expression<bool> Function($$LedgerMainsTableFilterComposer f) f,
  ) {
    final $$LedgerMainsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ledgerMains,
      getReferencedColumn: (t) => t.driverId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerMainsTableFilterComposer(
            $db: $db,
            $table: $db.ledgerMains,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DriversTableOrderingComposer
    extends Composer<_$AppDatabase, $DriversTable> {
  $$DriversTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehicleNumber => $composableBuilder(
    column: $table.vehicleNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DriversTableAnnotationComposer
    extends Composer<_$AppDatabase, $DriversTable> {
  $$DriversTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get vehicleNumber => $composableBuilder(
    column: $table.vehicleNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> ledgerMainsRefs<T extends Object>(
    Expression<T> Function($$LedgerMainsTableAnnotationComposer a) f,
  ) {
    final $$LedgerMainsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ledgerMains,
      getReferencedColumn: (t) => t.driverId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerMainsTableAnnotationComposer(
            $db: $db,
            $table: $db.ledgerMains,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DriversTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DriversTable,
          DriverRow,
          $$DriversTableFilterComposer,
          $$DriversTableOrderingComposer,
          $$DriversTableAnnotationComposer,
          $$DriversTableCreateCompanionBuilder,
          $$DriversTableUpdateCompanionBuilder,
          (DriverRow, $$DriversTableReferences),
          DriverRow,
          PrefetchHooks Function({bool ledgerMainsRefs})
        > {
  $$DriversTableTableManager(_$AppDatabase db, $DriversTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriversTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DriversTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DriversTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> vehicleNumber = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DriversCompanion(
                id: id,
                name: name,
                phone: phone,
                vehicleNumber: vehicleNumber,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> phone = const Value.absent(),
                Value<String?> vehicleNumber = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => DriversCompanion.insert(
                id: id,
                name: name,
                phone: phone,
                vehicleNumber: vehicleNumber,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DriversTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ledgerMainsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (ledgerMainsRefs) db.ledgerMains],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ledgerMainsRefs)
                    await $_getPrefetchedData<
                      DriverRow,
                      $DriversTable,
                      LedgerMainRow
                    >(
                      currentTable: table,
                      referencedTable: $$DriversTableReferences
                          ._ledgerMainsRefsTable(db),
                      managerFromTypedResult: (p0) => $$DriversTableReferences(
                        db,
                        table,
                        p0,
                      ).ledgerMainsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.driverId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DriversTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DriversTable,
      DriverRow,
      $$DriversTableFilterComposer,
      $$DriversTableOrderingComposer,
      $$DriversTableAnnotationComposer,
      $$DriversTableCreateCompanionBuilder,
      $$DriversTableUpdateCompanionBuilder,
      (DriverRow, $$DriversTableReferences),
      DriverRow,
      PrefetchHooks Function({bool ledgerMainsRefs})
    >;
typedef $$LedgerMainsTableCreateCompanionBuilder =
    LedgerMainsCompanion Function({
      required String id,
      required String driverId,
      required DateTime dispatchDate,
      Value<double?> commissionFee,
      Value<double?> laborFee,
      Value<double?> deliveryFee,
      Value<double?> otherFee,
      Value<String> status,
      Value<String?> note,
      Value<double?> settledTotalCharges,
      Value<double?> settledTotalCashAdvance,
      Value<double?> settledNetAmount,
      Value<int?> settledParcelCount,
      Value<DateTime?> settledAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$LedgerMainsTableUpdateCompanionBuilder =
    LedgerMainsCompanion Function({
      Value<String> id,
      Value<String> driverId,
      Value<DateTime> dispatchDate,
      Value<double?> commissionFee,
      Value<double?> laborFee,
      Value<double?> deliveryFee,
      Value<double?> otherFee,
      Value<String> status,
      Value<String?> note,
      Value<double?> settledTotalCharges,
      Value<double?> settledTotalCashAdvance,
      Value<double?> settledNetAmount,
      Value<int?> settledParcelCount,
      Value<DateTime?> settledAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$LedgerMainsTableReferences
    extends BaseReferences<_$AppDatabase, $LedgerMainsTable, LedgerMainRow> {
  $$LedgerMainsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DriversTable _driverIdTable(_$AppDatabase db) =>
      db.drivers.createAlias(
        $_aliasNameGenerator(db.ledgerMains.driverId, db.drivers.id),
      );

  $$DriversTableProcessedTableManager get driverId {
    final $_column = $_itemColumn<String>('driver_id')!;

    final manager = $$DriversTableTableManager(
      $_db,
      $_db.drivers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_driverIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ParcelsTable, List<ParcelRow>> _parcelsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.parcels,
    aliasName: $_aliasNameGenerator(db.ledgerMains.id, db.parcels.ledgerId),
  );

  $$ParcelsTableProcessedTableManager get parcelsRefs {
    final manager = $$ParcelsTableTableManager(
      $_db,
      $_db.parcels,
    ).filter((f) => f.ledgerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_parcelsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LedgerMainsTableFilterComposer
    extends Composer<_$AppDatabase, $LedgerMainsTable> {
  $$LedgerMainsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dispatchDate => $composableBuilder(
    column: $table.dispatchDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get commissionFee => $composableBuilder(
    column: $table.commissionFee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get laborFee => $composableBuilder(
    column: $table.laborFee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get deliveryFee => $composableBuilder(
    column: $table.deliveryFee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get otherFee => $composableBuilder(
    column: $table.otherFee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get settledTotalCharges => $composableBuilder(
    column: $table.settledTotalCharges,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get settledTotalCashAdvance => $composableBuilder(
    column: $table.settledTotalCashAdvance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get settledNetAmount => $composableBuilder(
    column: $table.settledNetAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get settledParcelCount => $composableBuilder(
    column: $table.settledParcelCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get settledAt => $composableBuilder(
    column: $table.settledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DriversTableFilterComposer get driverId {
    final $$DriversTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.driverId,
      referencedTable: $db.drivers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DriversTableFilterComposer(
            $db: $db,
            $table: $db.drivers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> parcelsRefs(
    Expression<bool> Function($$ParcelsTableFilterComposer f) f,
  ) {
    final $$ParcelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.parcels,
      getReferencedColumn: (t) => t.ledgerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParcelsTableFilterComposer(
            $db: $db,
            $table: $db.parcels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LedgerMainsTableOrderingComposer
    extends Composer<_$AppDatabase, $LedgerMainsTable> {
  $$LedgerMainsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dispatchDate => $composableBuilder(
    column: $table.dispatchDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get commissionFee => $composableBuilder(
    column: $table.commissionFee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get laborFee => $composableBuilder(
    column: $table.laborFee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get deliveryFee => $composableBuilder(
    column: $table.deliveryFee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get otherFee => $composableBuilder(
    column: $table.otherFee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get settledTotalCharges => $composableBuilder(
    column: $table.settledTotalCharges,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get settledTotalCashAdvance => $composableBuilder(
    column: $table.settledTotalCashAdvance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get settledNetAmount => $composableBuilder(
    column: $table.settledNetAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get settledParcelCount => $composableBuilder(
    column: $table.settledParcelCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get settledAt => $composableBuilder(
    column: $table.settledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DriversTableOrderingComposer get driverId {
    final $$DriversTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.driverId,
      referencedTable: $db.drivers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DriversTableOrderingComposer(
            $db: $db,
            $table: $db.drivers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LedgerMainsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LedgerMainsTable> {
  $$LedgerMainsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get dispatchDate => $composableBuilder(
    column: $table.dispatchDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get commissionFee => $composableBuilder(
    column: $table.commissionFee,
    builder: (column) => column,
  );

  GeneratedColumn<double> get laborFee =>
      $composableBuilder(column: $table.laborFee, builder: (column) => column);

  GeneratedColumn<double> get deliveryFee => $composableBuilder(
    column: $table.deliveryFee,
    builder: (column) => column,
  );

  GeneratedColumn<double> get otherFee =>
      $composableBuilder(column: $table.otherFee, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<double> get settledTotalCharges => $composableBuilder(
    column: $table.settledTotalCharges,
    builder: (column) => column,
  );

  GeneratedColumn<double> get settledTotalCashAdvance => $composableBuilder(
    column: $table.settledTotalCashAdvance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get settledNetAmount => $composableBuilder(
    column: $table.settledNetAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get settledParcelCount => $composableBuilder(
    column: $table.settledParcelCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get settledAt =>
      $composableBuilder(column: $table.settledAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$DriversTableAnnotationComposer get driverId {
    final $$DriversTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.driverId,
      referencedTable: $db.drivers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DriversTableAnnotationComposer(
            $db: $db,
            $table: $db.drivers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> parcelsRefs<T extends Object>(
    Expression<T> Function($$ParcelsTableAnnotationComposer a) f,
  ) {
    final $$ParcelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.parcels,
      getReferencedColumn: (t) => t.ledgerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParcelsTableAnnotationComposer(
            $db: $db,
            $table: $db.parcels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LedgerMainsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LedgerMainsTable,
          LedgerMainRow,
          $$LedgerMainsTableFilterComposer,
          $$LedgerMainsTableOrderingComposer,
          $$LedgerMainsTableAnnotationComposer,
          $$LedgerMainsTableCreateCompanionBuilder,
          $$LedgerMainsTableUpdateCompanionBuilder,
          (LedgerMainRow, $$LedgerMainsTableReferences),
          LedgerMainRow,
          PrefetchHooks Function({bool driverId, bool parcelsRefs})
        > {
  $$LedgerMainsTableTableManager(_$AppDatabase db, $LedgerMainsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LedgerMainsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LedgerMainsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LedgerMainsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> driverId = const Value.absent(),
                Value<DateTime> dispatchDate = const Value.absent(),
                Value<double?> commissionFee = const Value.absent(),
                Value<double?> laborFee = const Value.absent(),
                Value<double?> deliveryFee = const Value.absent(),
                Value<double?> otherFee = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<double?> settledTotalCharges = const Value.absent(),
                Value<double?> settledTotalCashAdvance = const Value.absent(),
                Value<double?> settledNetAmount = const Value.absent(),
                Value<int?> settledParcelCount = const Value.absent(),
                Value<DateTime?> settledAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LedgerMainsCompanion(
                id: id,
                driverId: driverId,
                dispatchDate: dispatchDate,
                commissionFee: commissionFee,
                laborFee: laborFee,
                deliveryFee: deliveryFee,
                otherFee: otherFee,
                status: status,
                note: note,
                settledTotalCharges: settledTotalCharges,
                settledTotalCashAdvance: settledTotalCashAdvance,
                settledNetAmount: settledNetAmount,
                settledParcelCount: settledParcelCount,
                settledAt: settledAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String driverId,
                required DateTime dispatchDate,
                Value<double?> commissionFee = const Value.absent(),
                Value<double?> laborFee = const Value.absent(),
                Value<double?> deliveryFee = const Value.absent(),
                Value<double?> otherFee = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<double?> settledTotalCharges = const Value.absent(),
                Value<double?> settledTotalCashAdvance = const Value.absent(),
                Value<double?> settledNetAmount = const Value.absent(),
                Value<int?> settledParcelCount = const Value.absent(),
                Value<DateTime?> settledAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LedgerMainsCompanion.insert(
                id: id,
                driverId: driverId,
                dispatchDate: dispatchDate,
                commissionFee: commissionFee,
                laborFee: laborFee,
                deliveryFee: deliveryFee,
                otherFee: otherFee,
                status: status,
                note: note,
                settledTotalCharges: settledTotalCharges,
                settledTotalCashAdvance: settledTotalCashAdvance,
                settledNetAmount: settledNetAmount,
                settledParcelCount: settledParcelCount,
                settledAt: settledAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LedgerMainsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({driverId = false, parcelsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (parcelsRefs) db.parcels],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (driverId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.driverId,
                                referencedTable: $$LedgerMainsTableReferences
                                    ._driverIdTable(db),
                                referencedColumn: $$LedgerMainsTableReferences
                                    ._driverIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (parcelsRefs)
                    await $_getPrefetchedData<
                      LedgerMainRow,
                      $LedgerMainsTable,
                      ParcelRow
                    >(
                      currentTable: table,
                      referencedTable: $$LedgerMainsTableReferences
                          ._parcelsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$LedgerMainsTableReferences(
                            db,
                            table,
                            p0,
                          ).parcelsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.ledgerId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LedgerMainsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LedgerMainsTable,
      LedgerMainRow,
      $$LedgerMainsTableFilterComposer,
      $$LedgerMainsTableOrderingComposer,
      $$LedgerMainsTableAnnotationComposer,
      $$LedgerMainsTableCreateCompanionBuilder,
      $$LedgerMainsTableUpdateCompanionBuilder,
      (LedgerMainRow, $$LedgerMainsTableReferences),
      LedgerMainRow,
      PrefetchHooks Function({bool driverId, bool parcelsRefs})
    >;
typedef $$ParcelsTableCreateCompanionBuilder =
    ParcelsCompanion Function({
      required String trackingId,
      required DateTime createdAt,
      required String fromTown,
      required String toTown,
      required String cityCode,
      required String accountCode,
      required String senderName,
      required String senderPhone,
      required String receiverName,
      required String receiverPhone,
      Value<String?> ledgerId,
      required String parcelType,
      required int numberOfParcels,
      required double totalCharges,
      required String paymentStatus,
      Value<double> cashAdvance,
      Value<String?> remark,
      Value<String> status,
      Value<String> syncStatus,
      Value<DateTime?> syncedAt,
      Value<DateTime?> arrivedAt,
      Value<DateTime?> claimedAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ParcelsTableUpdateCompanionBuilder =
    ParcelsCompanion Function({
      Value<String> trackingId,
      Value<DateTime> createdAt,
      Value<String> fromTown,
      Value<String> toTown,
      Value<String> cityCode,
      Value<String> accountCode,
      Value<String> senderName,
      Value<String> senderPhone,
      Value<String> receiverName,
      Value<String> receiverPhone,
      Value<String?> ledgerId,
      Value<String> parcelType,
      Value<int> numberOfParcels,
      Value<double> totalCharges,
      Value<String> paymentStatus,
      Value<double> cashAdvance,
      Value<String?> remark,
      Value<String> status,
      Value<String> syncStatus,
      Value<DateTime?> syncedAt,
      Value<DateTime?> arrivedAt,
      Value<DateTime?> claimedAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ParcelsTableReferences
    extends BaseReferences<_$AppDatabase, $ParcelsTable, ParcelRow> {
  $$ParcelsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LedgerMainsTable _ledgerIdTable(_$AppDatabase db) =>
      db.ledgerMains.createAlias(
        $_aliasNameGenerator(db.parcels.ledgerId, db.ledgerMains.id),
      );

  $$LedgerMainsTableProcessedTableManager? get ledgerId {
    final $_column = $_itemColumn<String>('ledger_id');
    if ($_column == null) return null;
    final manager = $$LedgerMainsTableTableManager(
      $_db,
      $_db.ledgerMains,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ledgerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ParcelsTableFilterComposer
    extends Composer<_$AppDatabase, $ParcelsTable> {
  $$ParcelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get trackingId => $composableBuilder(
    column: $table.trackingId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromTown => $composableBuilder(
    column: $table.fromTown,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toTown => $composableBuilder(
    column: $table.toTown,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cityCode => $composableBuilder(
    column: $table.cityCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountCode => $composableBuilder(
    column: $table.accountCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get senderName => $composableBuilder(
    column: $table.senderName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get senderPhone => $composableBuilder(
    column: $table.senderPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiverName => $composableBuilder(
    column: $table.receiverName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiverPhone => $composableBuilder(
    column: $table.receiverPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parcelType => $composableBuilder(
    column: $table.parcelType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numberOfParcels => $composableBuilder(
    column: $table.numberOfParcels,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalCharges => $composableBuilder(
    column: $table.totalCharges,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cashAdvance => $composableBuilder(
    column: $table.cashAdvance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remark => $composableBuilder(
    column: $table.remark,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get arrivedAt => $composableBuilder(
    column: $table.arrivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get claimedAt => $composableBuilder(
    column: $table.claimedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$LedgerMainsTableFilterComposer get ledgerId {
    final $$LedgerMainsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ledgerId,
      referencedTable: $db.ledgerMains,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerMainsTableFilterComposer(
            $db: $db,
            $table: $db.ledgerMains,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ParcelsTableOrderingComposer
    extends Composer<_$AppDatabase, $ParcelsTable> {
  $$ParcelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get trackingId => $composableBuilder(
    column: $table.trackingId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromTown => $composableBuilder(
    column: $table.fromTown,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toTown => $composableBuilder(
    column: $table.toTown,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cityCode => $composableBuilder(
    column: $table.cityCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountCode => $composableBuilder(
    column: $table.accountCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get senderName => $composableBuilder(
    column: $table.senderName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get senderPhone => $composableBuilder(
    column: $table.senderPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiverName => $composableBuilder(
    column: $table.receiverName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiverPhone => $composableBuilder(
    column: $table.receiverPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parcelType => $composableBuilder(
    column: $table.parcelType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get numberOfParcels => $composableBuilder(
    column: $table.numberOfParcels,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalCharges => $composableBuilder(
    column: $table.totalCharges,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cashAdvance => $composableBuilder(
    column: $table.cashAdvance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remark => $composableBuilder(
    column: $table.remark,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get arrivedAt => $composableBuilder(
    column: $table.arrivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get claimedAt => $composableBuilder(
    column: $table.claimedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$LedgerMainsTableOrderingComposer get ledgerId {
    final $$LedgerMainsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ledgerId,
      referencedTable: $db.ledgerMains,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerMainsTableOrderingComposer(
            $db: $db,
            $table: $db.ledgerMains,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ParcelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ParcelsTable> {
  $$ParcelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get trackingId => $composableBuilder(
    column: $table.trackingId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get fromTown =>
      $composableBuilder(column: $table.fromTown, builder: (column) => column);

  GeneratedColumn<String> get toTown =>
      $composableBuilder(column: $table.toTown, builder: (column) => column);

  GeneratedColumn<String> get cityCode =>
      $composableBuilder(column: $table.cityCode, builder: (column) => column);

  GeneratedColumn<String> get accountCode => $composableBuilder(
    column: $table.accountCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get senderName => $composableBuilder(
    column: $table.senderName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get senderPhone => $composableBuilder(
    column: $table.senderPhone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get receiverName => $composableBuilder(
    column: $table.receiverName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get receiverPhone => $composableBuilder(
    column: $table.receiverPhone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get parcelType => $composableBuilder(
    column: $table.parcelType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get numberOfParcels => $composableBuilder(
    column: $table.numberOfParcels,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalCharges => $composableBuilder(
    column: $table.totalCharges,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => column,
  );

  GeneratedColumn<double> get cashAdvance => $composableBuilder(
    column: $table.cashAdvance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get remark =>
      $composableBuilder(column: $table.remark, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get arrivedAt =>
      $composableBuilder(column: $table.arrivedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get claimedAt =>
      $composableBuilder(column: $table.claimedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$LedgerMainsTableAnnotationComposer get ledgerId {
    final $$LedgerMainsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ledgerId,
      referencedTable: $db.ledgerMains,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerMainsTableAnnotationComposer(
            $db: $db,
            $table: $db.ledgerMains,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ParcelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ParcelsTable,
          ParcelRow,
          $$ParcelsTableFilterComposer,
          $$ParcelsTableOrderingComposer,
          $$ParcelsTableAnnotationComposer,
          $$ParcelsTableCreateCompanionBuilder,
          $$ParcelsTableUpdateCompanionBuilder,
          (ParcelRow, $$ParcelsTableReferences),
          ParcelRow,
          PrefetchHooks Function({bool ledgerId})
        > {
  $$ParcelsTableTableManager(_$AppDatabase db, $ParcelsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ParcelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ParcelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ParcelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> trackingId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> fromTown = const Value.absent(),
                Value<String> toTown = const Value.absent(),
                Value<String> cityCode = const Value.absent(),
                Value<String> accountCode = const Value.absent(),
                Value<String> senderName = const Value.absent(),
                Value<String> senderPhone = const Value.absent(),
                Value<String> receiverName = const Value.absent(),
                Value<String> receiverPhone = const Value.absent(),
                Value<String?> ledgerId = const Value.absent(),
                Value<String> parcelType = const Value.absent(),
                Value<int> numberOfParcels = const Value.absent(),
                Value<double> totalCharges = const Value.absent(),
                Value<String> paymentStatus = const Value.absent(),
                Value<double> cashAdvance = const Value.absent(),
                Value<String?> remark = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<DateTime?> arrivedAt = const Value.absent(),
                Value<DateTime?> claimedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ParcelsCompanion(
                trackingId: trackingId,
                createdAt: createdAt,
                fromTown: fromTown,
                toTown: toTown,
                cityCode: cityCode,
                accountCode: accountCode,
                senderName: senderName,
                senderPhone: senderPhone,
                receiverName: receiverName,
                receiverPhone: receiverPhone,
                ledgerId: ledgerId,
                parcelType: parcelType,
                numberOfParcels: numberOfParcels,
                totalCharges: totalCharges,
                paymentStatus: paymentStatus,
                cashAdvance: cashAdvance,
                remark: remark,
                status: status,
                syncStatus: syncStatus,
                syncedAt: syncedAt,
                arrivedAt: arrivedAt,
                claimedAt: claimedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String trackingId,
                required DateTime createdAt,
                required String fromTown,
                required String toTown,
                required String cityCode,
                required String accountCode,
                required String senderName,
                required String senderPhone,
                required String receiverName,
                required String receiverPhone,
                Value<String?> ledgerId = const Value.absent(),
                required String parcelType,
                required int numberOfParcels,
                required double totalCharges,
                required String paymentStatus,
                Value<double> cashAdvance = const Value.absent(),
                Value<String?> remark = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<DateTime?> arrivedAt = const Value.absent(),
                Value<DateTime?> claimedAt = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ParcelsCompanion.insert(
                trackingId: trackingId,
                createdAt: createdAt,
                fromTown: fromTown,
                toTown: toTown,
                cityCode: cityCode,
                accountCode: accountCode,
                senderName: senderName,
                senderPhone: senderPhone,
                receiverName: receiverName,
                receiverPhone: receiverPhone,
                ledgerId: ledgerId,
                parcelType: parcelType,
                numberOfParcels: numberOfParcels,
                totalCharges: totalCharges,
                paymentStatus: paymentStatus,
                cashAdvance: cashAdvance,
                remark: remark,
                status: status,
                syncStatus: syncStatus,
                syncedAt: syncedAt,
                arrivedAt: arrivedAt,
                claimedAt: claimedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ParcelsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ledgerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ledgerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ledgerId,
                                referencedTable: $$ParcelsTableReferences
                                    ._ledgerIdTable(db),
                                referencedColumn: $$ParcelsTableReferences
                                    ._ledgerIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ParcelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ParcelsTable,
      ParcelRow,
      $$ParcelsTableFilterComposer,
      $$ParcelsTableOrderingComposer,
      $$ParcelsTableAnnotationComposer,
      $$ParcelsTableCreateCompanionBuilder,
      $$ParcelsTableUpdateCompanionBuilder,
      (ParcelRow, $$ParcelsTableReferences),
      ParcelRow,
      PrefetchHooks Function({bool ledgerId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DriversTableTableManager get drivers =>
      $$DriversTableTableManager(_db, _db.drivers);
  $$LedgerMainsTableTableManager get ledgerMains =>
      $$LedgerMainsTableTableManager(_db, _db.ledgerMains);
  $$ParcelsTableTableManager get parcels =>
      $$ParcelsTableTableManager(_db, _db.parcels);
}
