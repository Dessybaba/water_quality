import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/water_quality_record.dart';
import '../services/storage_service.dart';
import '../services/wqi_calculator.dart';
import '../services/location_service.dart';
import '../theme/app_theme.dart';

class DataFormScreen extends StatefulWidget {
  final WaterQualityRecord? record;

  const DataFormScreen({super.key, this.record});

  @override
  State<DataFormScreen> createState() => _DataFormScreenState();
}

class _DataFormScreenState extends State<DataFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isLoading = false;
  bool _isGettingLocation = false;

  double? _latitude;
  double? _longitude;
  String? _address;

  // Form values
  double? pH;
  double? electricalConductivity;
  double? totalDissolvedSolids;
  double? biologicalOxygenDemand;
  double? chemicalOxygenDemand;
  double? dissolvedOxygen;
  double? turbidity;
  double? totalColiform;
  double? fecalColiform;
  double? nitrate;
  double? phosphate;

  @override
  void initState() {
    super.initState();
    if (widget.record != null) {
      _loadRecordData();
    }
  }

  void _loadRecordData() {
    final record = widget.record!;
    _locationController.text = record.locationName;
    _notesController.text = record.notes ?? '';
    _latitude = record.latitude;
    _longitude = record.longitude;
    _address = record.address;
    pH = record.pH;
    electricalConductivity = record.electricalConductivity;
    totalDissolvedSolids = record.totalDissolvedSolids;
    biologicalOxygenDemand = record.biologicalOxygenDemand;
    chemicalOxygenDemand = record.chemicalOxygenDemand;
    dissolvedOxygen = record.dissolvedOxygen;
    turbidity = record.turbidity;
    totalColiform = record.totalColiform;
    fecalColiform = record.fecalColiform;
    nitrate = record.nitrate;
    phosphate = record.phosphate;
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
    });

    try {
      final position = await LocationService.getCurrentPosition();
      if (position != null) {
        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;
        });

        final address = await LocationService.getAddressFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (address != null) {
          setState(() {
            _address = address;
          });
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Unable to get location. Please check permissions.',
              ),
              backgroundColor: AppTheme.errorRed,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error getting location: $e'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGettingLocation = false;
        });
      }
    }
  }

  void _calculateAndSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a location name'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final record = WaterQualityRecord(
      id: widget.record?.id ?? const Uuid().v4(),
      locationName: _locationController.text.trim(),
      latitude: _latitude,
      longitude: _longitude,
      address: _address,
      pH: pH,
      electricalConductivity: electricalConductivity,
      totalDissolvedSolids: totalDissolvedSolids,
      biologicalOxygenDemand: biologicalOxygenDemand,
      chemicalOxygenDemand: chemicalOxygenDemand,
      dissolvedOxygen: dissolvedOxygen,
      turbidity: turbidity,
      totalColiform: totalColiform,
      fecalColiform: fecalColiform,
      nitrate: nitrate,
      phosphate: phosphate,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      createdAt: widget.record?.createdAt ?? DateTime.now(),
    );

    // Calculate WQI
    final wqi = WQICalculator.calculateWQI(record);
    record.waterQualityIndex = wqi;
    record.waterQualityClass = WQICalculator.getClassification(wqi);

    // Save to storage
    final storageService = context.read<StorageService>();
    storageService
        .saveRecord(record)
        .then((_) {
          setState(() {
            _isLoading = false;
          });

          if (mounted) {
            Navigator.pop(context, true);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  widget.record != null
                      ? 'Record updated successfully'
                      : 'Record saved successfully',
                ),
                backgroundColor: AppTheme.successGreen,
              ),
            );
          }
        })
        .catchError((error) {
          setState(() {
            _isLoading = false;
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error saving record: $error'),
                backgroundColor: AppTheme.errorRed,
              ),
            );
          }
        });
  }

  @override
  void dispose() {
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.record != null ? 'Edit Record' : 'New Assessment'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Location Section
            _buildSectionHeader('Location Information'),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location Name *',
                hintText: 'Enter sampling location',
                prefixIcon: Icon(Icons.location_on),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter location name';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isGettingLocation ? null : _getCurrentLocation,
                    icon: _isGettingLocation
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Icon(Icons.my_location),
                    label: Text(
                      _isGettingLocation ? 'Getting...' : 'Get GPS Location',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentTeal,
                    ),
                  ),
                ),
              ],
            ),
            if (_latitude != null && _longitude != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Coordinates',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${_latitude!.toStringAsFixed(6)}, ${_longitude!.toStringAsFixed(6)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (_address != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        _address!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),

            // Basic Parameters
            _buildSectionHeader('Basic Parameters'),
            _buildNumberField(
              label: 'pH',
              hint: '6.5 - 8.5',
              value: pH,
              onChanged: (value) => pH = value,
              min: 0,
              max: 14,
            ),
            _buildNumberField(
              label: 'Electrical Conductivity (EC)',
              hint: 'µS/cm',
              value: electricalConductivity,
              onChanged: (value) => electricalConductivity = value,
              suffix: 'µS/cm',
            ),
            _buildNumberField(
              label: 'Total Dissolved Solids (TDS)',
              hint: 'mg/L',
              value: totalDissolvedSolids,
              onChanged: (value) => totalDissolvedSolids = value,
              suffix: 'mg/L',
            ),
            const SizedBox(height: 24),

            // Oxygen Parameters
            _buildSectionHeader('Oxygen Parameters'),
            _buildNumberField(
              label: 'Dissolved Oxygen (DO)',
              hint: 'mg/L',
              value: dissolvedOxygen,
              onChanged: (value) => dissolvedOxygen = value,
              suffix: 'mg/L',
            ),
            _buildNumberField(
              label: 'Biological Oxygen Demand (BOD)',
              hint: 'mg/L',
              value: biologicalOxygenDemand,
              onChanged: (value) => biologicalOxygenDemand = value,
              suffix: 'mg/L',
            ),
            _buildNumberField(
              label: 'Chemical Oxygen Demand (COD)',
              hint: 'mg/L',
              value: chemicalOxygenDemand,
              onChanged: (value) => chemicalOxygenDemand = value,
              suffix: 'mg/L',
            ),
            const SizedBox(height: 24),

            // Other Parameters
            _buildSectionHeader('Other Parameters'),
            _buildNumberField(
              label: 'Turbidity',
              hint: 'NTU',
              value: turbidity,
              onChanged: (value) => turbidity = value,
              suffix: 'NTU',
            ),
            _buildNumberField(
              label: 'Total Coliform',
              hint: 'MPN/100mL',
              value: totalColiform,
              onChanged: (value) => totalColiform = value,
              suffix: 'MPN/100mL',
            ),
            _buildNumberField(
              label: 'Fecal Coliform',
              hint: 'MPN/100mL',
              value: fecalColiform,
              onChanged: (value) => fecalColiform = value,
              suffix: 'MPN/100mL',
            ),
            _buildNumberField(
              label: 'Nitrate (NO₃)',
              hint: 'mg/L',
              value: nitrate,
              onChanged: (value) => nitrate = value,
              suffix: 'mg/L',
            ),
            _buildNumberField(
              label: 'Phosphate (PO₄)',
              hint: 'mg/L',
              value: phosphate,
              onChanged: (value) => phosphate = value,
              suffix: 'mg/L',
            ),
            const SizedBox(height: 24),

            // Notes
            _buildSectionHeader('Notes (Optional)'),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Additional Notes',
                hintText: 'Enter any additional information...',
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 32),

            // Save Button
            ElevatedButton(
              onPressed: _isLoading ? null : _calculateAndSave,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      widget.record != null
                          ? 'Update Record'
                          : 'Calculate & Save',
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryBlue,
        ),
      ),
    );
  }

  Widget _buildNumberField({
    required String label,
    String? hint,
    String? suffix,
    double? value,
    required Function(double?) onChanged,
    double? min,
    double? max,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        initialValue: value?.toString(),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          suffixText: suffix,
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        validator: (value) {
          if (value != null && value.isNotEmpty) {
            final numValue = double.tryParse(value);
            if (numValue == null) {
              return 'Please enter a valid number';
            }
            if (min != null && numValue < min) {
              return 'Value must be >= $min';
            }
            if (max != null && numValue > max) {
              return 'Value must be <= $max';
            }
          }
          return null;
        },
        onChanged: (value) {
          if (value.isEmpty) {
            onChanged(null);
          } else {
            final numValue = double.tryParse(value);
            onChanged(numValue);
          }
        },
      ),
    );
  }
}
