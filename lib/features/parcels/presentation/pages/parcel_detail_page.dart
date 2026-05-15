import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../drivers/presentation/providers/driver_providers.dart';
import '../../../ledger/presentation/providers/ledger_providers.dart';
import '../../domain/parcel.dart';

class ParcelDetailPage extends ConsumerWidget {
  const ParcelDetailPage({super.key, required this.parcel});

  final Parcel parcel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ledger = parcel.ledgerId == null
        ? null
        : ref
              .watch(localLedgerMainsProvider)
              .where((ledger) => ledger.id == parcel.ledgerId)
              .firstOrNull;
    final driver = ledger == null
        ? null
        : ref
              .watch(localDriversProvider)
              .where((driver) => driver.id == ledger.driverId)
              .firstOrNull;
    final driverText = parcel.ledgerId == null
        ? 'Not attached'
        : driver?.name ?? 'Unknown driver';

    return Scaffold(
      appBar: AppBar(title: const Text('Parcel Detail'), centerTitle: false),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _Section(
              title: parcel.trackingId,
              rows: [
                _InfoRow(label: 'Status', value: parcel.status),
                _InfoRow(label: 'Driver', value: driverText),
                if (ledger != null)
                  _InfoRow(
                    label: 'Dispatch',
                    value: formatDate(ledger.dispatchDate),
                  ),
                _InfoRow(label: 'Created', value: formatDate(parcel.createdAt)),
              ],
            ),
            const SizedBox(height: 12),
            _Section(
              title: 'Route',
              rows: [
                _InfoRow(label: 'From', value: parcel.fromTown),
                _InfoRow(label: 'To', value: parcel.toTown),
              ],
            ),
            const SizedBox(height: 12),
            _Section(
              title: 'People',
              rows: [
                _InfoRow(label: 'Sender', value: parcel.senderName),
                _InfoRow(label: 'Sender Phone', value: parcel.senderPhone),
                _InfoRow(label: 'Receiver', value: parcel.receiverName),
                _InfoRow(label: 'Receiver Phone', value: parcel.receiverPhone),
              ],
            ),
            const SizedBox(height: 12),
            _Section(
              title: 'Charges',
              rows: [
                _InfoRow(label: 'Payment', value: parcel.paymentStatus),
                _InfoRow(label: 'Parcel Type', value: parcel.parcelType),
                _InfoRow(
                  label: 'Qty',
                  value: parcel.numberOfParcels.toString(),
                ),
                _InfoRow(
                  label: 'Charges',
                  value: '${formatMoney(parcel.totalCharges.round())} Ks',
                ),
                _InfoRow(
                  label: 'Cash Advance',
                  value: '${formatMoney(parcel.cashAdvance.round())} Ks',
                ),
              ],
            ),
            if (parcel.remark != null && parcel.remark!.trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              _Section(
                title: 'Remark',
                rows: [_InfoRow(label: 'Note', value: parcel.remark!)],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.rows});

  final String title;
  final List<_InfoRow> rows;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withAlpha(18)),
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            ...rows,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
