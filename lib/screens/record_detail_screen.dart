import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/storage_service.dart';
import '../services/pdf_service.dart';
import '../theme/app_theme.dart';
import 'data_form_screen.dart';

class RecordDetailScreen extends StatelessWidget {
  final String recordId;

  const RecordDetailScreen({super.key, required this.recordId});

  Color _getWQIColor(double? wqi) {
    if (wqi == null) return AppTheme.textLight;
    if (wqi >= 90) return AppTheme.excellentGreen;
    if (wqi >= 70) return AppTheme.goodBlue;
    if (wqi >= 50) return AppTheme.poorOrange;
    return AppTheme.veryPoorRed;
  }

  @override
  Widget build(BuildContext context) {
    final storageService = context.watch<StorageService>();
    final record = storageService.getRecordById(recordId);

    if (record == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Record Not Found')),
        body: const Center(child: Text('Record not found')),
      );
    }

    final wqi = record.waterQualityIndex;
    final wqiColor = _getWQIColor(wqi);
    final dateFormat = DateFormat('MMMM dd, yyyy • hh:mm a');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DataFormScreen(record: record),
                ),
              );
              if (result == true && context.mounted) {
                Navigator.pop(context, true);
              }
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'pdf',
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf, color: AppTheme.primaryBlue),
                    SizedBox(width: 8),
                    Text('Generate PDF'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: AppTheme.errorRed),
                    SizedBox(width: 8),
                    Text('Delete'),
                  ],
                ),
              ),
            ],
            onSelected: (value) async {
              if (value == 'delete') {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Record'),
                    content: const Text(
                      'Are you sure you want to delete this record?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.errorRed,
                        ),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (confirm == true && context.mounted) {
                  await storageService.deleteRecord(recordId);
                  if (context.mounted) {
                    Navigator.pop(context, true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Record deleted'),
                        backgroundColor: AppTheme.successGreen,
                      ),
                    );
                  }
                }
              } else if (value == 'pdf') {
                await PDFService.generateAndSharePDF(record);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // WQI Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: wqiColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'Water Quality Index',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    wqi?.toStringAsFixed(2) ?? 'N/A',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    record.waterQualityClass,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Location Information
            _buildSection(context, 'Location Information', [
              _buildInfoRow('Location', record.locationName),
              if (record.address != null)
                _buildInfoRow('Address', record.address!),
              if (record.latitude != null && record.longitude != null)
                _buildInfoRow(
                  'Coordinates',
                  '${record.latitude!.toStringAsFixed(6)}, ${record.longitude!.toStringAsFixed(6)}',
                ),
              _buildInfoRow('Date & Time', dateFormat.format(record.createdAt)),
            ]),

            // Water Quality Parameters
            _buildSection(context, 'Water Quality Parameters', [
              if (record.pH != null)
                _buildParameterRow('pH', record.pH!.toStringAsFixed(2), ''),
              if (record.electricalConductivity != null)
                _buildParameterRow(
                  'Electrical Conductivity',
                  record.electricalConductivity!.toStringAsFixed(2),
                  'µS/cm',
                ),
              if (record.totalDissolvedSolids != null)
                _buildParameterRow(
                  'Total Dissolved Solids (TDS)',
                  record.totalDissolvedSolids!.toStringAsFixed(2),
                  'mg/L',
                ),
              if (record.dissolvedOxygen != null)
                _buildParameterRow(
                  'Dissolved Oxygen (DO)',
                  record.dissolvedOxygen!.toStringAsFixed(2),
                  'mg/L',
                ),
              if (record.biologicalOxygenDemand != null)
                _buildParameterRow(
                  'Biological Oxygen Demand (BOD)',
                  record.biologicalOxygenDemand!.toStringAsFixed(2),
                  'mg/L',
                ),
              if (record.chemicalOxygenDemand != null)
                _buildParameterRow(
                  'Chemical Oxygen Demand (COD)',
                  record.chemicalOxygenDemand!.toStringAsFixed(2),
                  'mg/L',
                ),
              if (record.turbidity != null)
                _buildParameterRow(
                  'Turbidity',
                  record.turbidity!.toStringAsFixed(2),
                  'NTU',
                ),
              if (record.totalColiform != null)
                _buildParameterRow(
                  'Total Coliform',
                  record.totalColiform!.toStringAsFixed(2),
                  'MPN/100mL',
                ),
              if (record.fecalColiform != null)
                _buildParameterRow(
                  'Fecal Coliform',
                  record.fecalColiform!.toStringAsFixed(2),
                  'MPN/100mL',
                ),
              if (record.nitrate != null)
                _buildParameterRow(
                  'Nitrate (NO₃)',
                  record.nitrate!.toStringAsFixed(2),
                  'mg/L',
                ),
              if (record.phosphate != null)
                _buildParameterRow(
                  'Phosphate (PO₄)',
                  record.phosphate!.toStringAsFixed(2),
                  'mg/L',
                ),
            ]),

            // Notes
            if (record.notes != null && record.notes!.isNotEmpty)
              _buildSection(context, 'Notes', [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    record.notes!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ]),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await PDFService.generateAndSharePDF(record);
                    },
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Generate PDF'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppTheme.primaryBlue),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBlue,
                  ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(color: AppTheme.textLight, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParameterRow(String parameter, String value, String unit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(parameter, style: const TextStyle(fontSize: 14)),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          if (unit.isNotEmpty) ...[
            const SizedBox(width: 4),
            Text(
              unit,
              style: const TextStyle(color: AppTheme.textLight, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}
