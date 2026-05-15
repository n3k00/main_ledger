import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/money_formatter.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/ledger_main.dart';
import '../../domain/ledger_status.dart';
import '../providers/ledger_providers.dart';

class SettleLedgerPage extends ConsumerStatefulWidget {
  const SettleLedgerPage({
    super.key,
    required this.ledger,
    required this.parcelCount,
    required this.totalCharges,
    required this.paidAmount,
    required this.collectAmount,
    required this.totalCashAdvance,
  });

  final LedgerMain ledger;
  final int parcelCount;
  final double totalCharges;
  final double paidAmount;
  final double collectAmount;
  final double totalCashAdvance;

  @override
  ConsumerState<SettleLedgerPage> createState() => _SettleLedgerPageState();
}

class _SettleLedgerPageState extends ConsumerState<SettleLedgerPage> {
  late final TextEditingController _commissionController;
  late final TextEditingController _laborController;
  late final TextEditingController _deliveryController;
  late final TextEditingController _otherController;
  late final TextEditingController _noteController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _commissionController = TextEditingController(
      text: _initialFeeText(widget.ledger.commissionFee),
    );
    _laborController = TextEditingController(
      text: _initialFeeText(widget.ledger.laborFee),
    );
    _deliveryController = TextEditingController(
      text: _initialFeeText(widget.ledger.deliveryFee),
    );
    _otherController = TextEditingController(
      text: _initialFeeText(widget.ledger.otherFee),
    );
    _noteController = TextEditingController(text: widget.ledger.note ?? '');
  }

  @override
  void dispose() {
    _commissionController.dispose();
    _laborController.dispose();
    _deliveryController.dispose();
    _otherController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.ledger.status == LedgerStatus.settled;
    final commissionFee = _readFee(_commissionController);
    final laborFee = _readFee(_laborController);
    final deliveryFee = _readFee(_deliveryController);
    final otherFee = _readFee(_otherController);
    final totalDeductions = _totalDeductions();
    final netAmount = widget.totalCharges - totalDeductions;
    final driverBalance = netAmount - widget.collectAmount;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Settlement' : 'Settle Ledger'),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton.icon(
              onPressed: _isSubmitting ? null : _settle,
              icon: _isSubmitting
                  ? const SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.done_all_outlined),
              label: Text(isEditing ? 'Save Changes' : 'Settle'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 760;
              final summary = _SettleSummaryPanel(
                parcelCount: widget.parcelCount,
                totalCharges: widget.totalCharges,
                paidAmount: widget.paidAmount,
                collectAmount: widget.collectAmount,
                totalCashAdvance: widget.totalCashAdvance,
                commissionFee: commissionFee,
                laborFee: laborFee,
                deliveryFee: deliveryFee,
                otherFee: otherFee,
                totalDeductions: totalDeductions,
                netAmount: netAmount,
                driverBalance: driverBalance,
              );
              final form = _buildForm();

              if (!isWide) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [summary, const SizedBox(height: 12), form],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 300, child: summary),
                  const SizedBox(width: 16),
                  Expanded(child: form),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    final isEditing = widget.ledger.status == LedgerStatus.settled;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: 294,
              child: _feeField('Commission fee', _commissionController),
            ),
            SizedBox(
              width: 294,
              child: _feeField('Labor fee', _laborController),
            ),
            SizedBox(
              width: 294,
              child: _feeField('Delivery fee', _deliveryController),
            ),
            SizedBox(
              width: 294,
              child: _feeField('Other fee', _otherController),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: AppTextField(
            controller: _noteController,
            labelText: 'Note',
            enabled: !_isSubmitting,
            textInputAction: TextInputAction.done,
            prefixIcon: const Icon(Icons.notes_outlined),
            onFieldSubmitted: (_) => _settle(),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: _isSubmitting ? null : () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: _isSubmitting ? null : _settle,
              icon: _isSubmitting
                  ? const SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.done_all_outlined),
              label: Text(isEditing ? 'Save Changes' : 'Settle'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _feeField(String label, TextEditingController controller) {
    return AppTextField(
      controller: controller,
      labelText: label,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.next,
      enabled: !_isSubmitting,
      prefixIcon: const Icon(Icons.payments_outlined),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
    );
  }

  double _readFee(TextEditingController controller) {
    return double.tryParse(controller.text.trim()) ?? 0;
  }

  double _totalDeductions() {
    return _readFee(_commissionController) +
        _readFee(_laborController) +
        _readFee(_deliveryController) +
        _readFee(_otherController);
  }

  Future<void> _settle() async {
    if (_isSubmitting) return;
    final isEditing = widget.ledger.status == LedgerStatus.settled;
    setState(() => _isSubmitting = true);
    final messenger = ScaffoldMessenger.of(context);
    final totalDeductions = _totalDeductions();
    final netAmount = widget.totalCharges - totalDeductions;

    LedgerMain? settledLedger;
    Object? settleError;
    try {
      settledLedger = await ref
          .read(localLedgerMainsProvider.notifier)
          .settleLedger(
            ledgerId: widget.ledger.id,
            commissionFee: _readFee(_commissionController),
            laborFee: _readFee(_laborController),
            deliveryFee: _readFee(_deliveryController),
            otherFee: _readFee(_otherController),
            note: _noteController.text,
            settledTotalCharges: widget.totalCharges,
            settledTotalCashAdvance: widget.totalCashAdvance,
            settledNetAmount: netAmount,
            settledParcelCount: widget.parcelCount,
          );
    } catch (error) {
      settleError = error;
    }

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (settleError is LedgerSettleConflictException) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            '${settleError.trackingId} is already attached to another ledger in Firebase.',
          ),
        ),
      );
      return;
    }
    if (settleError != null) {
      messenger.showSnackBar(
        SnackBar(content: Text('Settle failed: $settleError')),
      );
      return;
    }
    if (settledLedger == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Ledger not found.')),
      );
      return;
    }

    Navigator.pop(context);
    messenger.showSnackBar(
      SnackBar(
        content: Text(isEditing ? 'Settlement updated.' : 'Ledger settled.'),
      ),
    );
  }
}

class _SettleSummaryPanel extends StatelessWidget {
  const _SettleSummaryPanel({
    required this.parcelCount,
    required this.totalCharges,
    required this.paidAmount,
    required this.collectAmount,
    required this.totalCashAdvance,
    required this.commissionFee,
    required this.laborFee,
    required this.deliveryFee,
    required this.otherFee,
    required this.totalDeductions,
    required this.netAmount,
    required this.driverBalance,
  });

  final int parcelCount;
  final double totalCharges;
  final double paidAmount;
  final double collectAmount;
  final double totalCashAdvance;
  final double commissionFee;
  final double laborFee;
  final double deliveryFee;
  final double otherFee;
  final double totalDeductions;
  final double netAmount;
  final double driverBalance;

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
              'Summary',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            _SummaryLine(label: 'Parcels', value: parcelCount.toString()),
            _SummaryLine(
              label: 'Paid Amount',
              value: '${_formatAmount(paidAmount)} Ks',
            ),
            _SummaryLine(
              label: 'Unpaid Amount',
              value: '${_formatAmount(collectAmount)} Ks',
            ),
            _SummaryLine(
              label: 'Total Charges',
              value: '${_formatAmount(totalCharges)} Ks',
            ),
            _SummaryLine(
              label: 'Cash Advance',
              value: '${_formatAmount(totalCashAdvance)} Ks',
            ),
            _SummaryLine(
              label: 'Commission Fee',
              value: '- ${_formatAmount(commissionFee)} Ks',
            ),
            _SummaryLine(
              label: 'Labor Fee',
              value: '- ${_formatAmount(laborFee)} Ks',
            ),
            _SummaryLine(
              label: 'Delivery Fee',
              value: '- ${_formatAmount(deliveryFee)} Ks',
            ),
            _SummaryLine(
              label: 'Other Fee',
              value: '- ${_formatAmount(otherFee)} Ks',
            ),
            _SummaryLine(
              label: 'Total Fees',
              value: '${_formatAmount(totalDeductions)} Ks',
            ),
            const Divider(height: 18),
            _SummaryLine(
              label: 'Net Amount',
              value: '${_formatAmount(netAmount)} Ks',
            ),
            _SummaryLine(
              label: 'Pay / Receive Amount',
              value: _formatSignedAmount(driverBalance),
              isStrong: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({
    required this.label,
    required this.value,
    this.isStrong = false,
  });

  final String label;
  final String value;
  final bool isStrong;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontWeight: isStrong ? FontWeight.w800 : FontWeight.w500,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(value, style: style),
        ],
      ),
    );
  }
}

String _formatAmount(double value) {
  if (value == value.roundToDouble()) {
    return formatMoney(value.round());
  }
  return value.toStringAsFixed(2);
}

String _formatSignedAmount(double value) {
  if (value == 0) return '${_formatAmount(value)} Ks';
  final sign = value > 0 ? '+' : '-';
  return '$sign ${_formatAmount(value.abs())} Ks';
}

String _initialFeeText(double? value) {
  if (value == null || value == 0) return '';
  if (value == value.roundToDouble()) {
    return value.round().toString();
  }
  return value.toStringAsFixed(2);
}
