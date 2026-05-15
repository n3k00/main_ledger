import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import '../../../../core/localization/app_language.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../drivers/domain/driver.dart';
import '../../../parcels/data/parcel_repository.dart';
import '../../../parcels/domain/parcel.dart';
import '../../../parcels/presentation/providers/parcel_providers.dart';
import '../../domain/ledger_main.dart';
import '../../domain/ledger_status.dart';
import '../providers/ledger_providers.dart';
import '../services/ledger_print_service.dart';
import 'settle_ledger_page.dart';

class LedgerDetailPage extends ConsumerStatefulWidget {
  const LedgerDetailPage({
    super.key,
    required this.ledger,
    required this.driver,
  });

  final LedgerMain ledger;
  final Driver driver;

  @override
  ConsumerState<LedgerDetailPage> createState() => _LedgerDetailPageState();
}

class _LedgerDetailPageState extends ConsumerState<LedgerDetailPage> {
  final _pageScanFocusNode = FocusNode();
  final _pageScanBuffer = StringBuffer();
  bool _isScanDialogOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _pageScanFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _pageScanFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final currentLedger = ref
        .watch(localLedgerMainsProvider)
        .firstWhere(
          (item) => item.id == widget.ledger.id,
          orElse: () => widget.ledger,
        );
    final parcels = ref.watch(ledgerParcelsProvider(currentLedger.id));
    final parcelCount = parcels.fold<int>(
      0,
      (total, parcel) => total + parcel.numberOfParcels,
    );
    final totalCharges = parcels.fold<double>(
      0,
      (total, parcel) => total + parcel.totalCharges,
    );
    final totalCashAdvance = parcels.fold<double>(
      0,
      (total, parcel) => total + parcel.cashAdvance,
    );
    final paidAmount = parcels.fold<double>(
      0,
      (total, parcel) =>
          _isPaidParcel(parcel) ? total + parcel.totalCharges : total,
    );
    final collectAmount = parcels.fold<double>(
      0,
      (total, parcel) =>
          _isPaidParcel(parcel) ? total : total + parcel.totalCharges,
    );
    final netAmount = totalCharges - currentLedger.totalDeductions;
    final driverBalance = netAmount - collectAmount;

    return KeyboardListener(
      focusNode: _pageScanFocusNode,
      autofocus: true,
      onKeyEvent: (event) => _handlePageScanKey(event, currentLedger),
      child: Scaffold(
        appBar: AppBar(
          title: Text(strings.ledgerDetail),
          centerTitle: false,
          actions: [
            TextButton.icon(
              onPressed: () => _printLedger(
                ledger: currentLedger,
                driver: widget.driver,
                parcels: parcels,
                parcelCount: parcelCount,
                paidAmount: paidAmount,
                unpaidAmount: collectAmount,
                totalCharges: totalCharges,
                totalCashAdvance: totalCashAdvance,
                netAmount: netAmount,
                payReceiveAmount: driverBalance,
              ),
              icon: const Icon(Icons.print_outlined),
              label: Text(strings.print),
            ),
            TextButton.icon(
              onPressed: currentLedger.status == LedgerStatus.settled
                  ? null
                  : () => _openScanDialog(currentLedger.id),
              icon: const Icon(Icons.qr_code_scanner),
              label: Text(strings.scanParcel),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => SettleLedgerPage(
                      ledger: currentLedger,
                      parcelCount: parcelCount,
                      totalCharges: totalCharges,
                      paidAmount: paidAmount,
                      collectAmount: collectAmount,
                      totalCashAdvance: totalCashAdvance,
                    ),
                  ),
                ),
                icon: Icon(
                  currentLedger.status == LedgerStatus.settled
                      ? Icons.edit_note_outlined
                      : Icons.done_all_outlined,
                ),
                label: Text(
                  currentLedger.status == LedgerStatus.settled
                      ? strings.editSettlement
                      : strings.settle,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _LedgerMetaBar(
                  ledger: currentLedger,
                  driver: widget.driver,
                  parcelCount: parcelCount,
                  netAmount: netAmount,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: _ParcelDataTable(
                    ledgerId: currentLedger.id,
                    ledger: currentLedger,
                    parcels: parcels,
                    isSettled: currentLedger.status == LedgerStatus.settled,
                    totalCharges: totalCharges,
                    paidAmount: paidAmount,
                    collectAmount: collectAmount,
                    totalCashAdvance: totalCashAdvance,
                    netAmount: netAmount,
                    driverBalance: driverBalance,
                    strings: strings,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handlePageScanKey(KeyEvent event, LedgerMain currentLedger) {
    if (event is! KeyDownEvent ||
        _isScanDialogOpen ||
        currentLedger.status == LedgerStatus.settled ||
        _isTextInputFocused()) {
      return;
    }

    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      final trackingId = _pageScanBuffer.toString().trim();
      _pageScanBuffer.clear();
      if (trackingId.isNotEmpty) {
        unawaited(_openScanDialog(currentLedger.id, trackingId: trackingId));
      }
      return;
    }

    if (event.logicalKey == LogicalKeyboardKey.backspace) {
      final current = _pageScanBuffer.toString();
      _pageScanBuffer.clear();
      if (current.isNotEmpty) {
        _pageScanBuffer.write(current.substring(0, current.length - 1));
      }
      return;
    }

    final character = event.character;
    if (character != null && character.isNotEmpty) {
      _pageScanBuffer.write(character);
    }
  }

  bool _isTextInputFocused() {
    final focusedContext = FocusManager.instance.primaryFocus?.context;
    final focusedWidget = focusedContext?.widget;
    return focusedWidget is EditableText ||
        focusedContext?.findAncestorWidgetOfExactType<EditableText>() != null;
  }

  Future<void> _openScanDialog(String ledgerId, {String? trackingId}) async {
    if (_isScanDialogOpen || !mounted) return;
    _isScanDialogOpen = true;
    await _showScanParcelDialog(
      context,
      ref,
      ledgerId,
      initialTrackingId: trackingId,
    );
    _isScanDialogOpen = false;
    if (mounted) {
      _pageScanFocusNode.requestFocus();
    }
  }

  Future<void> _printLedger({
    required LedgerMain ledger,
    required Driver driver,
    required List<Parcel> parcels,
    required int parcelCount,
    required double paidAmount,
    required double unpaidAmount,
    required double totalCharges,
    required double totalCashAdvance,
    required double netAmount,
    required double payReceiveAmount,
  }) async {
    try {
      await const LedgerPrintService().printLedger(
        ledger: ledger,
        driver: driver,
        parcels: parcels,
        parcelCount: parcelCount,
        paidAmount: paidAmount,
        unpaidAmount: unpaidAmount,
        totalCharges: totalCharges,
        totalCashAdvance: totalCashAdvance,
        netAmount: netAmount,
        payReceiveAmount: payReceiveAmount,
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Print failed: $error')));
    }

    if (mounted) {
      _pageScanFocusNode.requestFocus();
    }
  }
}

class _LedgerMetaBar extends ConsumerWidget {
  const _LedgerMetaBar({
    required this.ledger,
    required this.driver,
    required this.parcelCount,
    required this.netAmount,
  });

  final LedgerMain ledger;
  final Driver driver;
  final int parcelCount;
  final double netAmount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withAlpha(18)),
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Wrap(
        spacing: 20,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _MetaText(label: strings.driver, value: driver.name),
          _MetaText(
            label: strings.dispatch,
            value: formatDate(ledger.dispatchDate),
          ),
          _MetaText(
            label: strings.status,
            value: strings.statusValue(ledger.status.value),
          ),
          _MetaText(label: strings.parcels, value: parcelCount.toString()),
          _MetaText(
            label: strings.netAmount,
            value: '${_formatAmount(netAmount)} Ks',
          ),
          if (ledger.status == LedgerStatus.settled)
            Text(
              strings.settlementCompleted,
              style: textTheme.bodySmall?.copyWith(color: Colors.black54),
            ),
        ],
      ),
    );
  }
}

class _MetaText extends StatelessWidget {
  const _MetaText({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return RichText(
      text: TextSpan(
        style: textTheme.bodyMedium?.copyWith(color: Colors.black87),
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}

Future<void> _showScanParcelDialog(
  BuildContext context,
  WidgetRef ref,
  String ledgerId, {
  String? initialTrackingId,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return _ScanParcelDialog(
        ledgerId: ledgerId,
        ref: ref,
        initialTrackingId: initialTrackingId,
      );
    },
  );
}

class _ScanParcelDialog extends StatefulWidget {
  const _ScanParcelDialog({
    required this.ledgerId,
    required this.ref,
    this.initialTrackingId,
  });

  final String ledgerId;
  final WidgetRef ref;
  final String? initialTrackingId;

  @override
  State<_ScanParcelDialog> createState() => _ScanParcelDialogState();
}

class _ScanParcelDialogState extends State<_ScanParcelDialog> {
  final _focusNode = FocusNode();
  final _buffer = StringBuffer();
  Parcel? _parcel;
  String? _lastScan;
  bool _isLookingUp = false;
  bool _notFound = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
        final initialTrackingId = widget.initialTrackingId;
        if (initialTrackingId != null && initialTrackingId.trim().isNotEmpty) {
          _lookupParcel(initialTrackingId);
        }
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = widget.ref.read(appStringsProvider);
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: AlertDialog(
        title: Text(strings.scanParcel),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_parcel == null) ...[
                const Icon(Icons.qr_code_scanner, size: 44),
                const SizedBox(height: 12),
                Text(
                  _isLookingUp
                      ? 'Looking up parcel...'
                      : 'Waiting for scanner...',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Scan the barcode or QR code with the physical scanner.',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.black54),
                ),
              ],
              if (_lastScan != null) ...[
                const SizedBox(height: 12),
                _InfoLine(label: strings.trackingId, value: _lastScan!),
              ],
              if (_notFound) ...[
                const SizedBox(height: 12),
                Text(
                  'Parcel not found. Create the voucher in the mobile app first.',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              if (_parcel != null) ...[
                _InfoLine(
                  label: strings.trackingId,
                  value: _parcel!.trackingId,
                ),
                _InfoLine(
                  label: strings.receiver,
                  value: _parcel!.receiverName,
                ),
                _InfoLine(label: strings.to, value: _parcel!.toTown),
                _InfoLine(
                  label: strings.parcelType,
                  value: _parcel!.parcelType,
                ),
                _InfoLine(
                  label: strings.qty,
                  value: _parcel!.numberOfParcels.toString(),
                ),
                _InfoLine(
                  label: strings.charges,
                  value: '${_formatAmount(_parcel!.totalCharges)} Ks',
                ),
                _InfoLine(
                  label: strings.cashAdvance,
                  value: '${_formatAmount(_parcel!.cashAdvance)} Ks',
                ),
                _InfoLine(
                  label: strings.payment,
                  value: strings.paymentValue(_parcel!.paymentStatus),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(strings.cancel),
          ),
          FilledButton(
            onPressed: _parcel == null ? null : _attachParcel,
            child: Text(strings.ok),
          ),
        ],
      ),
    );
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent || _isLookingUp) return;

    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      final trackingId = _buffer.toString().trim();
      _buffer.clear();
      if (trackingId.isNotEmpty) {
        _lookupParcel(trackingId);
      }
      return;
    }

    if (event.logicalKey == LogicalKeyboardKey.backspace) {
      final current = _buffer.toString();
      _buffer.clear();
      if (current.isNotEmpty) {
        _buffer.write(current.substring(0, current.length - 1));
      }
      return;
    }

    final character = event.character;
    if (character != null && character.isNotEmpty) {
      _buffer.write(character);
    }
  }

  Future<void> _lookupParcel(String trackingId) async {
    setState(() {
      _isLookingUp = true;
      _notFound = false;
      _parcel = null;
      _lastScan = trackingId;
    });

    Parcel? parcel;
    Object? lookupError;
    try {
      parcel = await widget.ref
          .read(parcelLookupServiceProvider)
          .lookupAndCache(trackingId);
    } catch (error) {
      lookupError = error;
    }

    if (!mounted) return;
    setState(() {
      _isLookingUp = false;
      _parcel = parcel;
      _notFound = parcel == null;
    });

    if (lookupError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Parcel lookup failed: $lookupError')),
      );
    }

    if (parcel == null) {
      _focusNode.requestFocus();
    }
  }

  Future<void> _attachParcel() async {
    final parcel = _parcel;
    if (parcel == null) return;

    final result = await widget.ref
        .read(parcelRepositoryProvider)
        .attachToLedger(
          trackingId: parcel.trackingId,
          ledgerId: widget.ledgerId,
        );

    if (!mounted) return;

    if (result != ParcelAttachResult.attached) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_attachResultMessage(result))));
      _focusNode.requestFocus();
      return;
    }

    await widget.ref
        .read(ledgerParcelsProvider(widget.ledgerId).notifier)
        .reload();

    if (mounted) {
      Navigator.pop(context);
    }
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value});

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
            width: 110,
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

class _ParcelDataTable extends StatefulWidget {
  const _ParcelDataTable({
    required this.ledgerId,
    required this.ledger,
    required this.parcels,
    required this.isSettled,
    required this.totalCharges,
    required this.paidAmount,
    required this.collectAmount,
    required this.totalCashAdvance,
    required this.netAmount,
    required this.driverBalance,
    required this.strings,
  });

  final String ledgerId;
  final LedgerMain ledger;
  final List<Parcel> parcels;
  final bool isSettled;
  final double totalCharges;
  final double paidAmount;
  final double collectAmount;
  final double totalCashAdvance;
  final double netAmount;
  final double driverBalance;
  final AppStrings strings;

  @override
  State<_ParcelDataTable> createState() => _ParcelDataTableState();
}

class _ParcelDataTableState extends State<_ParcelDataTable> {
  final _horizontalController = ScrollController();
  final _verticalController = ScrollController();

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withAlpha(18)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: widget.parcels.isEmpty
                  ? const AppEmptyState(
                      icon: Icons.inventory_2_outlined,
                      title: 'No parcels attached yet',
                      message:
                          'Use Scan Parcel to attach parcels to this ledger.',
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final layout = _ParcelTableLayout.forWidth(
                          constraints.maxWidth,
                        );
                        final contentWidth =
                            layout.tableWidth < constraints.maxWidth
                            ? constraints.maxWidth
                            : layout.tableWidth;

                        return Scrollbar(
                          controller: _horizontalController,
                          thumbVisibility: constraints.maxWidth < 760,
                          notificationPredicate: (notification) =>
                              notification.metrics.axis == Axis.horizontal,
                          child: SingleChildScrollView(
                            controller: _horizontalController,
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: constraints.maxWidth,
                              ),
                              child: Scrollbar(
                                controller: _verticalController,
                                thumbVisibility: true,
                                child: SingleChildScrollView(
                                  controller: _verticalController,
                                  child: SizedBox(
                                    width: contentWidth,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        DataTable(
                                          showCheckboxColumn: false,
                                          horizontalMargin:
                                              layout.horizontalMargin,
                                          columnSpacing: layout.columnSpacing,
                                          headingRowHeight: 40,
                                          dataRowMinHeight: 42,
                                          dataRowMaxHeight: 48,
                                          headingRowColor:
                                              WidgetStatePropertyAll(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .surfaceContainerHighest,
                                              ),
                                          columns: [
                                            DataColumn(
                                              label: _SizedHeader(
                                                width: layout.no,
                                                label: 'No',
                                              ),
                                            ),
                                            DataColumn(
                                              label: _SizedHeader(
                                                width: layout.trackingId,
                                                label: 'Tracking ID',
                                              ),
                                            ),
                                            DataColumn(
                                              label: _SizedHeader(
                                                width: layout.receiver,
                                                label: widget.strings.receiver,
                                              ),
                                            ),
                                            DataColumn(
                                              label: _SizedHeader(
                                                width: layout.toTown,
                                                label: widget.strings.to,
                                              ),
                                            ),
                                            DataColumn(
                                              label: _SizedHeader(
                                                width: layout.parcelType,
                                                label: widget.strings.type,
                                              ),
                                            ),
                                            DataColumn(
                                              numeric: true,
                                              label: _SizedHeader(
                                                width: layout.qty,
                                                label: widget.strings.qty,
                                                alignEnd: true,
                                              ),
                                            ),
                                            DataColumn(
                                              numeric: true,
                                              label: _SizedHeader(
                                                width: layout.charges,
                                                label: widget.strings.charges,
                                                alignEnd: true,
                                              ),
                                            ),
                                            DataColumn(
                                              numeric: true,
                                              label: _SizedHeader(
                                                width: layout.cashAdvance,
                                                label: widget
                                                    .strings
                                                    .advanceHeader,
                                                alignEnd: true,
                                              ),
                                            ),
                                            DataColumn(
                                              label: _SizedHeader(
                                                width: layout.payment,
                                                label: widget.strings.payment,
                                              ),
                                            ),
                                            DataColumn(
                                              label: SizedBox(
                                                width: layout.menu,
                                              ),
                                            ),
                                          ],
                                          rows: [
                                            for (
                                              var index = 0;
                                              index < widget.parcels.length;
                                              index++
                                            )
                                              _buildParcelRow(
                                                index,
                                                widget.parcels[index],
                                                widget.ledgerId,
                                                widget.isSettled,
                                                layout,
                                              ),
                                          ],
                                        ),
                                        if (widget.isSettled)
                                          _SettlementSummaryBar(
                                            totalCharges: widget.totalCharges,
                                            paidAmount: widget.paidAmount,
                                            collectAmount: widget.collectAmount,
                                            totalCashAdvance:
                                                widget.totalCashAdvance,
                                            commissionFee:
                                                widget.ledger.commissionFee ??
                                                0,
                                            laborFee:
                                                widget.ledger.laborFee ?? 0,
                                            deliveryFee:
                                                widget.ledger.deliveryFee ?? 0,
                                            otherFee:
                                                widget.ledger.otherFee ?? 0,
                                            netAmount: widget.netAmount,
                                            driverBalance: widget.driverBalance,
                                            strings: widget.strings,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildParcelRow(
    int index,
    Parcel parcel,
    String ledgerId,
    bool isSettled,
    _ParcelTableLayout layout,
  ) {
    return DataRow(
      onSelectChanged: (_) =>
          _showParcelDetailDialog(context, parcel, widget.strings),
      cells: [
        DataCell(_SizedCell(width: layout.no, value: '${index + 1}')),
        DataCell(
          _SizedCell(width: layout.trackingId, value: parcel.trackingId),
        ),
        DataCell(
          _SizedCell(width: layout.receiver, value: parcel.receiverName),
        ),
        DataCell(_SizedCell(width: layout.toTown, value: parcel.toTown)),
        DataCell(
          _SizedCell(width: layout.parcelType, value: parcel.parcelType),
        ),
        DataCell(
          _SizedCell(
            width: layout.qty,
            value: parcel.numberOfParcels.toString(),
            alignEnd: true,
          ),
        ),
        DataCell(
          _SizedCell(
            width: layout.charges,
            value: _formatAmount(parcel.totalCharges),
            alignEnd: true,
          ),
        ),
        DataCell(
          _SizedCell(
            width: layout.cashAdvance,
            value: _formatAmount(parcel.cashAdvance),
            alignEnd: true,
          ),
        ),
        DataCell(
          _SizedCell(
            width: layout.payment,
            value: widget.strings.paymentValue(parcel.paymentStatus),
          ),
        ),
        DataCell(
          SizedBox(
            width: layout.menu,
            child: _ParcelRowMenu(
              ledgerId: ledgerId,
              parcel: parcel,
              isSettled: isSettled,
            ),
          ),
        ),
      ],
    );
  }
}

class _SettlementSummaryBar extends StatelessWidget {
  const _SettlementSummaryBar({
    required this.totalCharges,
    required this.paidAmount,
    required this.collectAmount,
    required this.totalCashAdvance,
    required this.commissionFee,
    required this.laborFee,
    required this.deliveryFee,
    required this.otherFee,
    required this.netAmount,
    required this.driverBalance,
    required this.strings,
  });

  final double totalCharges;
  final double paidAmount;
  final double collectAmount;
  final double totalCashAdvance;
  final double commissionFee;
  final double laborFee;
  final double deliveryFee;
  final double otherFee;
  final double netAmount;
  final double driverBalance;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CalculationLine(
          label: strings.paidAmount,
          value: '${_formatAmount(paidAmount)} Ks',
        ),
        _CalculationLine(
          label: strings.unpaidAmount,
          value: '${_formatAmount(collectAmount)} Ks',
        ),
        _CalculationLine(
          label: strings.totalCharges,
          value: '${_formatAmount(totalCharges)} Ks',
          emphasized: true,
        ),
        _CalculationLine(
          label: strings.commissionFee,
          value: _formatDeduction(commissionFee),
        ),
        _CalculationLine(
          label: strings.laborFee,
          value: _formatDeduction(laborFee),
        ),
        _CalculationLine(
          label: strings.deliveryFee,
          value: _formatDeduction(deliveryFee),
        ),
        _CalculationLine(
          label: strings.otherFee,
          value: _formatDeduction(otherFee),
        ),
        _CalculationLine(
          label: strings.netAmount,
          value: '${_formatAmount(netAmount)} Ks',
          emphasized: true,
        ),
        _CalculationLine(
          label: strings.unpaidAmount,
          value: _formatDeduction(collectAmount),
        ),
        _CalculationLine(
          label: strings.payReceiveAmount,
          value: _formatSignedAmount(driverBalance),
          emphasized: true,
        ),
        _CalculationLine(
          label: strings.cashAdvance,
          value: '${_formatAmount(totalCashAdvance)} Ks',
        ),
      ],
    );
  }
}

class _CalculationLine extends StatelessWidget {
  const _CalculationLine({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final style = textTheme.bodyMedium?.copyWith(
      fontWeight: emphasized ? FontWeight.w800 : FontWeight.w500,
    );
    final borderColor = Colors.black.withAlpha(18);

    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: borderColor)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const SizedBox(width: 52),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style,
            ),
          ),
          SizedBox(
            width: 180,
            child: Text(value, textAlign: TextAlign.end, style: style),
          ),
          const SizedBox(width: 52),
        ],
      ),
    );
  }
}

class _SizedHeader extends StatelessWidget {
  const _SizedHeader({
    required this.width,
    required this.label,
    this.alignEnd = false,
  });

  final double width;
  final String label;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: alignEnd ? TextAlign.end : TextAlign.start,
      ),
    );
  }
}

class _SizedCell extends StatelessWidget {
  const _SizedCell({
    required this.width,
    required this.value,
    this.alignEnd = false,
  });

  final double width;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: alignEnd ? TextAlign.end : TextAlign.start,
      ),
    );
  }
}

class _ParcelTableLayout {
  const _ParcelTableLayout({
    required this.horizontalMargin,
    required this.columnSpacing,
    required this.no,
    required this.trackingId,
    required this.receiver,
    required this.toTown,
    required this.parcelType,
    required this.qty,
    required this.charges,
    required this.cashAdvance,
    required this.payment,
    required this.menu,
  });

  final double horizontalMargin;
  final double columnSpacing;
  final double no;
  final double trackingId;
  final double receiver;
  final double toTown;
  final double parcelType;
  final double qty;
  final double charges;
  final double cashAdvance;
  final double payment;
  final double menu;

  double get tableWidth =>
      horizontalMargin * 2 +
      columnSpacing * 9 +
      no +
      trackingId +
      receiver +
      toTown +
      parcelType +
      qty +
      charges +
      cashAdvance +
      payment +
      menu;

  static _ParcelTableLayout forWidth(double width) {
    const horizontalMargin = 8.0;
    const columnSpacing = 8.0;
    const no = 34.0;
    const qty = 34.0;
    const menu = 40.0;
    const spacingTotal = horizontalMargin * 2 + columnSpacing * 9;
    const fixedTotal = no + qty + menu;
    final remaining = (width - spacingTotal - fixedTotal)
        .clamp(560.0, 900.0)
        .toDouble();

    return _ParcelTableLayout(
      horizontalMargin: horizontalMargin,
      columnSpacing: columnSpacing,
      no: no,
      trackingId: remaining * 0.15,
      receiver: remaining * 0.21,
      toTown: remaining * 0.13,
      parcelType: remaining * 0.12,
      qty: qty,
      charges: remaining * 0.13,
      cashAdvance: remaining * 0.12,
      payment: remaining * 0.14,
      menu: menu,
    );
  }
}

class _ParcelRowMenu extends ConsumerWidget {
  const _ParcelRowMenu({
    required this.ledgerId,
    required this.parcel,
    required this.isSettled,
  });

  final String ledgerId;
  final Parcel parcel;
  final bool isSettled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    return PopupMenuButton<String>(
      tooltip: 'Parcel options',
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'view',
          child: _ParcelMenuItem(
            icon: Icons.visibility_outlined,
            label: strings.view,
          ),
        ),
        if (!isSettled)
          PopupMenuItem(
            value: 'remove',
            child: _ParcelMenuItem(
              icon: Icons.link_off_outlined,
              label: strings.remove,
            ),
          ),
      ],
      onSelected: (value) async {
        if (value == 'view') {
          _showParcelDetailDialog(context, parcel, strings);
          return;
        }

        await _removeParcelFromLedger(
          context: context,
          ref: ref,
          ledgerId: ledgerId,
          parcel: parcel,
        );
      },
    );
  }
}

class _ParcelMenuItem extends StatelessWidget {
  const _ParcelMenuItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [Icon(icon, size: 18), const SizedBox(width: 10), Text(label)],
    );
  }
}

Future<void> _removeParcelFromLedger({
  required BuildContext context,
  required WidgetRef ref,
  required String ledgerId,
  required Parcel parcel,
}) async {
  await ref.read(parcelRepositoryProvider).removeFromLedger(parcel.trackingId);
  await ref.read(ledgerParcelsProvider(ledgerId).notifier).reload();

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${parcel.trackingId} removed from ledger.')),
    );
  }
}

Future<void> _showParcelDetailDialog(
  BuildContext context,
  Parcel parcel,
  AppStrings strings,
) {
  return showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(parcel.trackingId),
        content: SizedBox(
          width: 460,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _InfoLine(label: strings.receiver, value: parcel.receiverName),
                _InfoLine(
                  label: strings.receiverPhone,
                  value: parcel.receiverPhone,
                ),
                _InfoLine(label: strings.sender, value: parcel.senderName),
                _InfoLine(
                  label: strings.senderPhone,
                  value: parcel.senderPhone,
                ),
                _InfoLine(label: strings.from, value: parcel.fromTown),
                _InfoLine(label: strings.to, value: parcel.toTown),
                _InfoLine(label: strings.parcelType, value: parcel.parcelType),
                _InfoLine(
                  label: strings.qty,
                  value: parcel.numberOfParcels.toString(),
                ),
                _InfoLine(
                  label: strings.charges,
                  value: '${_formatAmount(parcel.totalCharges)} Ks',
                ),
                _InfoLine(
                  label: strings.cashAdvance,
                  value: '${_formatAmount(parcel.cashAdvance)} Ks',
                ),
                _InfoLine(
                  label: strings.payment,
                  value: strings.paymentValue(parcel.paymentStatus),
                ),
                _InfoLine(
                  label: strings.status,
                  value: strings.statusValue(parcel.status),
                ),
                if (parcel.remark != null && parcel.remark!.trim().isNotEmpty)
                  _InfoLine(label: strings.remark, value: parcel.remark!),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(strings.close),
          ),
        ],
      );
    },
  );
}

String _attachResultMessage(ParcelAttachResult result) {
  switch (result) {
    case ParcelAttachResult.attached:
      return 'Parcel attached.';
    case ParcelAttachResult.notFound:
      return 'Parcel not found.';
    case ParcelAttachResult.alreadyAttached:
      return 'Already attached.';
    case ParcelAttachResult.attachedToAnotherLedger:
      return 'Already attached to another ledger.';
  }
}

String _formatAmount(double value) {
  if (value == value.roundToDouble()) {
    return formatMoney(value.round());
  }
  return value.toStringAsFixed(2);
}

String _formatDeduction(double value) {
  if (value == 0) return '${_formatAmount(value)} Ks';
  return '- ${_formatAmount(value)} Ks';
}

String _formatSignedAmount(double value) {
  if (value == 0) return '${_formatAmount(value)} Ks';
  final sign = value > 0 ? '+' : '-';
  return '$sign ${_formatAmount(value.abs())} Ks';
}

bool _isPaidParcel(Parcel parcel) {
  return parcel.paymentStatus.trim().toLowerCase() == 'paid';
}
