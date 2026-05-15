import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../drivers/domain/driver.dart';
import '../../../parcels/domain/parcel.dart';
import '../../domain/ledger_main.dart';

class LedgerPrintService {
  const LedgerPrintService();

  Future<void> printLedger({
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
    final pdfBytes = await _buildLedgerPdf(
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

    await Printing.layoutPdf(
      name: 'main_ledger_${ledger.id}.pdf',
      format: PdfPageFormat.a4.landscape,
      onLayout: (_) async => pdfBytes,
    );
  }

  Future<Uint8List> _buildLedgerPdf({
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
    final baseFontData = await rootBundle.load(
      'assets/fonts/NotoSans-Regular.ttf',
    );
    final myanmarFontData = await rootBundle.load(
      'assets/fonts/NotoSansMyanmar-Regular.ttf',
    );
    final baseFont = pw.Font.ttf(baseFontData);
    final myanmarFont = pw.Font.ttf(myanmarFontData);
    final document = pw.Document();
    final theme = pw.ThemeData.withFont(
      base: baseFont,
      bold: baseFont,
      fontFallback: [myanmarFont],
    );

    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(22),
        theme: theme,
        header: (context) => _buildHeader(
          ledger: ledger,
          driver: driver,
          pageNumber: context.pageNumber,
          pagesCount: context.pagesCount,
        ),
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'Page ${context.pageNumber} / ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 8),
          ),
        ),
        build: (context) => [
          _buildParcelTable(parcels),
          pw.SizedBox(height: 8),
          _buildSettlementRows(
            parcelCount: parcelCount,
            paidAmount: paidAmount,
            unpaidAmount: unpaidAmount,
            totalCharges: totalCharges,
            totalCashAdvance: totalCashAdvance,
            commissionFee: ledger.commissionFee ?? 0,
            laborFee: ledger.laborFee ?? 0,
            deliveryFee: ledger.deliveryFee ?? 0,
            otherFee: ledger.otherFee ?? 0,
            netAmount: netAmount,
            payReceiveAmount: payReceiveAmount,
          ),
          if (ledger.note != null && ledger.note!.trim().isNotEmpty) ...[
            pw.SizedBox(height: 8),
            pw.Text(
              'Note: ${ledger.note}',
              style: const pw.TextStyle(fontSize: 9),
            ),
          ],
        ],
      ),
    );

    return document.save();
  }

  pw.Widget _buildHeader({
    required LedgerMain ledger,
    required Driver driver,
    required int pageNumber,
    required int pagesCount,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 8),
      margin: const pw.EdgeInsets.only(bottom: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.grey400, width: 0.6),
        ),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Main Ledger',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Wrap(
                  spacing: 16,
                  runSpacing: 4,
                  children: [
                    _metaText('Driver', driver.name),
                    _metaText('Phone', driver.phone ?? '-'),
                    _metaText('Vehicle', driver.vehicleNumber ?? '-'),
                    _metaText('Dispatch', formatDate(ledger.dispatchDate)),
                    _metaText('Status', ledger.status.value),
                    _metaText('Settled At', _formatDateTime(ledger.settledAt)),
                  ],
                ),
              ],
            ),
          ),
          pw.Text(
            'Page $pageNumber / $pagesCount',
            style: const pw.TextStyle(fontSize: 8),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildParcelTable(List<Parcel> parcels) {
    final headers = [
      'No',
      'Tracking ID',
      'Receiver',
      'Phone',
      'To',
      'Type',
      'Qty',
      'Charges',
      'Payment',
      'Cash Advance',
    ];

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: [
        for (var index = 0; index < parcels.length; index++)
          [
            '${index + 1}',
            parcels[index].trackingId,
            parcels[index].receiverName,
            parcels[index].receiverPhone,
            parcels[index].toTown,
            parcels[index].parcelType,
            parcels[index].numberOfParcels.toString(),
            _formatAmount(parcels[index].totalCharges),
            parcels[index].paymentStatus,
            _formatAmount(parcels[index].cashAdvance),
          ],
      ],
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.4),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
      headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
      cellStyle: const pw.TextStyle(fontSize: 7.5),
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      columnWidths: {
        0: const pw.FixedColumnWidth(24),
        1: const pw.FixedColumnWidth(82),
        2: const pw.FixedColumnWidth(54),
        3: const pw.FixedColumnWidth(72),
        4: const pw.FixedColumnWidth(62),
        5: const pw.FlexColumnWidth(1.2),
        6: const pw.FixedColumnWidth(28),
        7: const pw.FixedColumnWidth(70),
        8: const pw.FixedColumnWidth(58),
        9: const pw.FixedColumnWidth(76),
      },
      cellAlignments: {
        0: pw.Alignment.centerRight,
        6: pw.Alignment.centerRight,
        7: pw.Alignment.centerRight,
        9: pw.Alignment.centerRight,
      },
    );
  }

  pw.Widget _buildSettlementRows({
    required int parcelCount,
    required double paidAmount,
    required double unpaidAmount,
    required double totalCharges,
    required double totalCashAdvance,
    required double commissionFee,
    required double laborFee,
    required double deliveryFee,
    required double otherFee,
    required double netAmount,
    required double payReceiveAmount,
  }) {
    final rows = [
      _summaryRow('Parcel Count', parcelCount.toString()),
      _summaryRow('Paid Amount', _formatCurrency(paidAmount)),
      _summaryRow('Unpaid Amount', _formatCurrency(unpaidAmount)),
      _summaryRow('Total Charges', _formatCurrency(totalCharges), strong: true),
      _summaryRow('Commission Fee', _formatDeduction(commissionFee)),
      _summaryRow('Labor Fee', _formatDeduction(laborFee)),
      _summaryRow('Delivery Fee', _formatDeduction(deliveryFee)),
      _summaryRow('Other Fee', _formatDeduction(otherFee)),
      _summaryRow('Net Amount', _formatCurrency(netAmount), strong: true),
      _summaryRow('Unpaid Amount', _formatDeduction(unpaidAmount)),
      _summaryRow(
        'Pay / Receive Amount',
        _formatSignedCurrency(payReceiveAmount),
        strong: true,
      ),
      _summaryRow('Cash Advance', _formatCurrency(totalCashAdvance)),
    ];

    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.SizedBox(
        width: 420,
        child: pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.4),
          columnWidths: const {
            0: pw.FlexColumnWidth(),
            1: pw.FixedColumnWidth(150),
          },
          children: rows,
        ),
      ),
    );
  }

  pw.TableRow _summaryRow(String label, String value, {bool strong = false}) {
    final style = pw.TextStyle(
      fontSize: 8.5,
      fontWeight: strong ? pw.FontWeight.bold : pw.FontWeight.normal,
    );
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: pw.Text(label, style: style),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: pw.Text(value, textAlign: pw.TextAlign.right, style: style),
        ),
      ],
    );
  }

  pw.Widget _metaText(String label, String value) {
    return pw.Text('$label: $value', style: const pw.TextStyle(fontSize: 8.5));
  }

  String _formatCurrency(double value) {
    return '${_formatAmount(value)} Ks';
  }

  String _formatAmount(double value) {
    if (value == value.roundToDouble()) {
      return formatMoney(value.round());
    }
    return value.toStringAsFixed(2);
  }

  String _formatDeduction(double value) {
    if (value == 0) return _formatCurrency(value);
    return '- ${_formatCurrency(value)}';
  }

  String _formatSignedCurrency(double value) {
    if (value == 0) return _formatCurrency(value);
    final sign = value > 0 ? '+' : '-';
    return '$sign ${_formatCurrency(value.abs())}';
  }

  String _formatDateTime(DateTime? value) {
    if (value == null) return '-';
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '${formatDate(value)} $hour:$minute';
  }
}
