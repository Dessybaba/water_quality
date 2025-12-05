import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../models/water_quality_record.dart';
import '../theme/app_theme.dart';

class PDFService {
  static Future<void> generateAndSharePDF(WaterQualityRecord record) async {
    final pdf = await _generatePDF(record);
    await _sharePDF(pdf, record);
  }

  static Future<void> generateAndSavePDF(WaterQualityRecord record) async {
    final pdf = await _generatePDF(record);
    await _savePDF(pdf, record);
  }

  static Future<pw.Document> _generatePDF(WaterQualityRecord record) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('MMMM dd, yyyy • hh:mm a');

    PdfColor getWQIColor(double? wqi) {
      if (wqi == null) return PdfColors.grey;
      if (wqi >= 90) return PdfColors.green;
      if (wqi >= 70) return PdfColors.blue;
      if (wqi >= 50) return PdfColors.orange;
      return PdfColors.red;
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
            // Header
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Water Quality Assessment Report',
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        dateFormat.format(record.createdAt),
                        style: pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            // Location Information
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: PdfColors.blue50,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Location Information',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text('Location: ${record.locationName}'),
                  if (record.address != null)
                    pw.Text('Address: ${record.address}'),
                  if (record.latitude != null && record.longitude != null)
                    pw.Text(
                      'Coordinates: ${record.latitude!.toStringAsFixed(6)}, ${record.longitude!.toStringAsFixed(6)}',
                    ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            // WQI Summary
            pw.Container(
              padding: const pw.EdgeInsets.all(20),
              decoration: pw.BoxDecoration(
                color: getWQIColor(record.waterQualityIndex),
                borderRadius: pw.BorderRadius.circular(12),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Column(
                    children: [
                      pw.Text(
                        'Water Quality Index',
                        style: pw.TextStyle(
                          fontSize: 14,
                          color: PdfColors.white,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        record.waterQualityIndex?.toStringAsFixed(2) ?? 'N/A',
                        style: pw.TextStyle(
                          fontSize: 48,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        record.waterQualityClass,
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            // Water Quality Parameters
            pw.Text(
              'Water Quality Parameters',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 12),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              children: [
                _buildTableRow('Parameter', 'Value', 'Unit', isHeader: true),
                if (record.pH != null)
                  _buildTableRow('pH', record.pH!.toStringAsFixed(2), ''),
                if (record.electricalConductivity != null)
                  _buildTableRow(
                    'Electrical Conductivity',
                    record.electricalConductivity!.toStringAsFixed(2),
                    'µS/cm',
                  ),
                if (record.totalDissolvedSolids != null)
                  _buildTableRow(
                    'Total Dissolved Solids (TDS)',
                    record.totalDissolvedSolids!.toStringAsFixed(2),
                    'mg/L',
                  ),
                if (record.biologicalOxygenDemand != null)
                  _buildTableRow(
                    'Biological Oxygen Demand (BOD)',
                    record.biologicalOxygenDemand!.toStringAsFixed(2),
                    'mg/L',
                  ),
                if (record.chemicalOxygenDemand != null)
                  _buildTableRow(
                    'Chemical Oxygen Demand (COD)',
                    record.chemicalOxygenDemand!.toStringAsFixed(2),
                    'mg/L',
                  ),
                if (record.dissolvedOxygen != null)
                  _buildTableRow(
                    'Dissolved Oxygen (DO)',
                    record.dissolvedOxygen!.toStringAsFixed(2),
                    'mg/L',
                  ),
                if (record.turbidity != null)
                  _buildTableRow(
                    'Turbidity',
                    record.turbidity!.toStringAsFixed(2),
                    'NTU',
                  ),
                if (record.totalColiform != null)
                  _buildTableRow(
                    'Total Coliform',
                    record.totalColiform!.toStringAsFixed(2),
                    'MPN/100mL',
                  ),
                if (record.fecalColiform != null)
                  _buildTableRow(
                    'Fecal Coliform',
                    record.fecalColiform!.toStringAsFixed(2),
                    'MPN/100mL',
                  ),
                if (record.nitrate != null)
                  _buildTableRow(
                    'Nitrate (NO₃)',
                    record.nitrate!.toStringAsFixed(2),
                    'mg/L',
                  ),
                if (record.phosphate != null)
                  _buildTableRow(
                    'Phosphate (PO₄)',
                    record.phosphate!.toStringAsFixed(2),
                    'mg/L',
                  ),
              ],
            ),

            if (record.notes != null && record.notes!.isNotEmpty) ...[
              pw.SizedBox(height: 20),
              pw.Text(
                'Notes',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Text(record.notes!),
              ),
            ],
          ];
        },
      ),
    );

    return pdf;
  }

  static pw.TableRow _buildTableRow(
    String param,
    String value,
    String unit, {
    bool isHeader = false,
  }) {
    return pw.TableRow(
      decoration: isHeader ? pw.BoxDecoration(color: PdfColors.grey200) : null,
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            param,
            style: pw.TextStyle(
              fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            value,
            style: pw.TextStyle(
              fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
            textAlign: pw.TextAlign.center,
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            unit,
            style: pw.TextStyle(
              fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
            textAlign: pw.TextAlign.center,
          ),
        ),
      ],
    );
  }

  static Future<void> _sharePDF(
    pw.Document pdf,
    WaterQualityRecord record,
  ) async {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  static Future<void> _savePDF(
    pw.Document pdf,
    WaterQualityRecord record,
  ) async {
    final directory = await getApplicationDocumentsDirectory();
    final dateFormat = DateFormat('yyyyMMdd_HHmmss');
    final fileName =
        'WQI_${record.locationName.replaceAll(' ', '_')}_${dateFormat.format(record.createdAt)}.pdf';
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
  }
}
