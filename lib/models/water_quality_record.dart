import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class WaterQualityRecord extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String locationName;

  @HiveField(2)
  double? latitude;

  @HiveField(3)
  double? longitude;

  @HiveField(4)
  String? address;

  @HiveField(5)
  double? pH;

  @HiveField(6)
  double? electricalConductivity; // EC in µS/cm

  @HiveField(7)
  double? totalDissolvedSolids; // TDS in mg/L

  @HiveField(8)
  double? biologicalOxygenDemand; // BOD in mg/L

  @HiveField(9)
  double? chemicalOxygenDemand; // COD in mg/L

  @HiveField(10)
  double? dissolvedOxygen; // DO in mg/L

  @HiveField(11)
  double? turbidity; // NTU

  @HiveField(12)
  double? totalColiform; // MPN/100mL

  @HiveField(13)
  double? fecalColiform; // MPN/100mL

  @HiveField(14)
  double? nitrate; // NO3 in mg/L

  @HiveField(15)
  double? phosphate; // PO4 in mg/L

  @HiveField(16)
  double? waterQualityIndex; // WQI

  @HiveField(17)
  String waterQualityClass; // Classification

  @HiveField(18)
  DateTime createdAt;

  @HiveField(19)
  String? notes;

  WaterQualityRecord({
    required this.id,
    required this.locationName,
    this.latitude,
    this.longitude,
    this.address,
    this.pH,
    this.electricalConductivity,
    this.totalDissolvedSolids,
    this.biologicalOxygenDemand,
    this.chemicalOxygenDemand,
    this.dissolvedOxygen,
    this.turbidity,
    this.totalColiform,
    this.fecalColiform,
    this.nitrate,
    this.phosphate,
    this.waterQualityIndex = 0.0,
    this.waterQualityClass = 'Not Calculated',
    DateTime? createdAt,
    this.notes,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'locationName': locationName,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'pH': pH,
      'electricalConductivity': electricalConductivity,
      'totalDissolvedSolids': totalDissolvedSolids,
      'biologicalOxygenDemand': biologicalOxygenDemand,
      'chemicalOxygenDemand': chemicalOxygenDemand,
      'dissolvedOxygen': dissolvedOxygen,
      'turbidity': turbidity,
      'totalColiform': totalColiform,
      'fecalColiform': fecalColiform,
      'nitrate': nitrate,
      'phosphate': phosphate,
      'waterQualityIndex': waterQualityIndex,
      'waterQualityClass': waterQualityClass,
      'createdAt': createdAt.toIso8601String(),
      'notes': notes,
    };
  }
}
