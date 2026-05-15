import 'package:flutter/material.dart';

import '../../../../core/utils/money_formatter.dart';
import '../../domain/parcel_date_group.dart';
import 'parcel_tile.dart';

class ParcelDateSection extends StatelessWidget {
  const ParcelDateSection({super.key, required this.group});

  final ParcelDateGroup group;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                group.dateLabel,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Divider(color: Colors.black.withAlpha(24), height: 1),
              ),
              const SizedBox(width: 10),
              Text(
                '${group.parcelTotal} parcels  |  '
                '${formatMoney(group.balanceTotal)} Ks',
                style: textTheme.bodySmall?.copyWith(color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final parcel in group.parcels) ParcelTile(parcel: parcel),
        ],
      ),
    );
  }
}
