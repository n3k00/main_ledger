import 'package:flutter/material.dart';

import '../../../../core/utils/money_formatter.dart';
import '../../domain/parcel_entry.dart';

class ParcelTile extends StatelessWidget {
  const ParcelTile({super.key, required this.parcel});

  final ParcelEntry parcel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.black.withAlpha(18)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          child: const Icon(Icons.local_shipping_outlined),
        ),
        title: Text(
          parcel.customer,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${parcel.route}  |  ${parcel.parcelCount} parcels',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${formatMoney(parcel.balance)} Ks',
              style: textTheme.titleSmall?.copyWith(
                color: const Color(0xFF15803D),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '-${formatMoney(parcel.deductions)} Ks',
              style: textTheme.bodySmall?.copyWith(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
