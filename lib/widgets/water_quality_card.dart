import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/water_quality_record.dart';
import '../theme/app_theme.dart';

class WaterQualityCard extends StatelessWidget {
  final WaterQualityRecord record;
  final VoidCallback onTap;

  const WaterQualityCard({
    super.key,
    required this.record,
    required this.onTap,
  });

  Color _getWQIColor(double? wqi) {
    if (wqi == null) return AppTheme.textLight;
    if (wqi >= 90) return AppTheme.excellentGreen;
    if (wqi >= 70) return AppTheme.goodBlue;
    if (wqi >= 50) return AppTheme.poorOrange;
    return AppTheme.veryPoorRed;
  }

  @override
  Widget build(BuildContext context) {
    final wqi = record.waterQualityIndex;
    final color = _getWQIColor(wqi);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.locationName,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat(
                            'MMM dd, yyyy • hh:mm a',
                          ).format(record.createdAt),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      record.waterQualityClass,
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildInfoItem(
                    context,
                    Icons.science,
                    'WQI',
                    wqi != null ? wqi.toStringAsFixed(1) : 'N/A',
                  ),
                  const SizedBox(width: 16),
                  if (record.pH != null)
                    _buildInfoItem(
                      context,
                      Icons.eco,
                      'pH',
                      record.pH!.toStringAsFixed(1),
                    ),
                  const Spacer(),
                  if (record.address != null)
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppTheme.textLight,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.textLight),
        const SizedBox(width: 4),
        Text('$label: ', style: Theme.of(context).textTheme.bodySmall),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
