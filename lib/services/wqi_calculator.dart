import '../models/water_quality_record.dart';

class WQICalculator {
  // Weighted Arithmetic Water Quality Index (WQI) Calculation
  // Based on standard water quality parameters and their weights

  static const Map<String, double> weights = {
    'pH': 0.11,
    'dissolvedOxygen': 0.17,
    'biologicalOxygenDemand': 0.11,
    'chemicalOxygenDemand': 0.10,
    'totalDissolvedSolids': 0.08,
    'electricalConductivity': 0.07,
    'turbidity': 0.09,
    'totalColiform': 0.12,
    'fecalColiform': 0.10,
    'nitrate': 0.03,
    'phosphate': 0.02,
  };

  // Standard values for calculation (ideal/recommended values)
  static const Map<String, double> standardValues = {
    'pH': 7.0,
    'dissolvedOxygen': 6.0, // mg/L
    'biologicalOxygenDemand': 3.0, // mg/L
    'chemicalOxygenDemand': 10.0, // mg/L
    'totalDissolvedSolids': 500.0, // mg/L
    'electricalConductivity': 300.0, // µS/cm
    'turbidity': 5.0, // NTU
    'totalColiform': 0.0, // MPN/100mL (ideal is 0)
    'fecalColiform': 0.0, // MPN/100mL (ideal is 0)
    'nitrate': 10.0, // mg/L
    'phosphate': 0.1, // mg/L
  };

  // Maximum permissible values
  static const Map<String, double> maxValues = {
    'pH': 14.0,
    'dissolvedOxygen': 10.0,
    'biologicalOxygenDemand': 30.0,
    'chemicalOxygenDemand': 100.0,
    'totalDissolvedSolids': 2000.0,
    'electricalConductivity': 1500.0,
    'turbidity': 50.0,
    'totalColiform': 5000.0,
    'fecalColiform': 2000.0,
    'nitrate': 50.0,
    'phosphate': 2.0,
  };

  static double calculateWQI(WaterQualityRecord record) {
    double totalWQI = 0.0;
    int parameterCount = 0;

    // pH calculation (optimal range: 6.5-8.5)
    if (record.pH != null) {
      double qpH = _calculateQpH(record.pH!);
      totalWQI += qpH * weights['pH']!;
      parameterCount++;
    }

    // Dissolved Oxygen (higher is better)
    if (record.dissolvedOxygen != null) {
      double qDO = _calculateQDO(record.dissolvedOxygen!);
      totalWQI += qDO * weights['dissolvedOxygen']!;
      parameterCount++;
    }

    // BOD (lower is better)
    if (record.biologicalOxygenDemand != null) {
      double qBOD = _calculateQBOD(record.biologicalOxygenDemand!);
      totalWQI += qBOD * weights['biologicalOxygenDemand']!;
      parameterCount++;
    }

    // COD (lower is better)
    if (record.chemicalOxygenDemand != null) {
      double qCOD = _calculateQCOD(record.chemicalOxygenDemand!);
      totalWQI += qCOD * weights['chemicalOxygenDemand']!;
      parameterCount++;
    }

    // TDS (lower is better)
    if (record.totalDissolvedSolids != null) {
      double qTDS = _calculateQTDS(record.totalDissolvedSolids!);
      totalWQI += qTDS * weights['totalDissolvedSolids']!;
      parameterCount++;
    }

    // EC (lower is better)
    if (record.electricalConductivity != null) {
      double qEC = _calculateQEC(record.electricalConductivity!);
      totalWQI += qEC * weights['electricalConductivity']!;
      parameterCount++;
    }

    // Turbidity (lower is better)
    if (record.turbidity != null) {
      double qTurbidity = _calculateQTurbidity(record.turbidity!);
      totalWQI += qTurbidity * weights['turbidity']!;
      parameterCount++;
    }

    // Total Coliform (lower is better)
    if (record.totalColiform != null) {
      double qColiform = _calculateQColiform(record.totalColiform!, true);
      totalWQI += qColiform * weights['totalColiform']!;
      parameterCount++;
    }

    // Fecal Coliform (lower is better)
    if (record.fecalColiform != null) {
      double qFecal = _calculateQColiform(record.fecalColiform!, false);
      totalWQI += qFecal * weights['fecalColiform']!;
      parameterCount++;
    }

    // Nitrate (lower is better)
    if (record.nitrate != null) {
      double qNitrate = _calculateQNitrate(record.nitrate!);
      totalWQI += qNitrate * weights['nitrate']!;
      parameterCount++;
    }

    // Phosphate (lower is better)
    if (record.phosphate != null) {
      double qPhosphate = _calculateQPhosphate(record.phosphate!);
      totalWQI += qPhosphate * weights['phosphate']!;
      parameterCount++;
    }

    // Normalize if not all parameters were provided
    if (parameterCount > 0 && parameterCount < 11) {
      double weightSum = 0.0;
      // Recalculate weight sum based on available parameters
      if (record.pH != null) weightSum += weights['pH']!;
      if (record.dissolvedOxygen != null)
        weightSum += weights['dissolvedOxygen']!;
      if (record.biologicalOxygenDemand != null)
        weightSum += weights['biologicalOxygenDemand']!;
      if (record.chemicalOxygenDemand != null)
        weightSum += weights['chemicalOxygenDemand']!;
      if (record.totalDissolvedSolids != null)
        weightSum += weights['totalDissolvedSolids']!;
      if (record.electricalConductivity != null)
        weightSum += weights['electricalConductivity']!;
      if (record.turbidity != null) weightSum += weights['turbidity']!;
      if (record.totalColiform != null) weightSum += weights['totalColiform']!;
      if (record.fecalColiform != null) weightSum += weights['fecalColiform']!;
      if (record.nitrate != null) weightSum += weights['nitrate']!;
      if (record.phosphate != null) weightSum += weights['phosphate']!;

      if (weightSum > 0) {
        totalWQI = (totalWQI / weightSum) * 100;
      }
    }

    return totalWQI.clamp(0.0, 100.0);
  }

  static double _calculateQpH(double value) {
    // Optimal pH range: 6.5-8.5 (Q = 100)
    // Outside range: Q decreases
    if (value >= 6.5 && value <= 8.5) return 100.0;
    if (value < 6.5) {
      return ((value / 6.5) * 100).clamp(0.0, 100.0);
    } else {
      return (((8.5 - (value - 8.5)) / 8.5) * 100).clamp(0.0, 100.0);
    }
  }

  static double _calculateQDO(double value) {
    // DO: 6-10 mg/L is excellent (Q = 100)
    if (value >= 6.0) return 100.0;
    return ((value / 6.0) * 100).clamp(0.0, 100.0);
  }

  static double _calculateQBOD(double value) {
    // BOD: 0-3 is excellent (Q = 100), >30 is very poor (Q = 0)
    if (value <= 3.0) return 100.0;
    if (value >= 30.0) return 0.0;
    return 100.0 - ((value - 3.0) / 27.0 * 100).clamp(0.0, 100.0);
  }

  static double _calculateQCOD(double value) {
    // COD: 0-10 is excellent (Q = 100), >100 is very poor (Q = 0)
    if (value <= 10.0) return 100.0;
    if (value >= 100.0) return 0.0;
    return 100.0 - ((value - 10.0) / 90.0 * 100).clamp(0.0, 100.0);
  }

  static double _calculateQTDS(double value) {
    // TDS: 0-500 is excellent (Q = 100), >2000 is very poor (Q = 0)
    if (value <= 500.0) return 100.0;
    if (value >= 2000.0) return 0.0;
    return 100.0 - ((value - 500.0) / 1500.0 * 100).clamp(0.0, 100.0);
  }

  static double _calculateQEC(double value) {
    // EC: 0-300 is excellent (Q = 100), >1500 is very poor (Q = 0)
    if (value <= 300.0) return 100.0;
    if (value >= 1500.0) return 0.0;
    return 100.0 - ((value - 300.0) / 1200.0 * 100).clamp(0.0, 100.0);
  }

  static double _calculateQTurbidity(double value) {
    // Turbidity: 0-5 is excellent (Q = 100), >50 is very poor (Q = 0)
    if (value <= 5.0) return 100.0;
    if (value >= 50.0) return 0.0;
    return 100.0 - ((value - 5.0) / 45.0 * 100).clamp(0.0, 100.0);
  }

  static double _calculateQColiform(double value, bool isTotal) {
    // Coliform: 0 is excellent (Q = 100)
    // Total: >5000 is very poor (Q = 0)
    // Fecal: >2000 is very poor (Q = 0)
    double maxValue = isTotal ? 5000.0 : 2000.0;
    if (value == 0.0) return 100.0;
    if (value >= maxValue) return 0.0;
    return 100.0 - ((value / maxValue) * 100).clamp(0.0, 100.0);
  }

  static double _calculateQNitrate(double value) {
    // Nitrate: 0-10 is excellent (Q = 100), >50 is very poor (Q = 0)
    if (value <= 10.0) return 100.0;
    if (value >= 50.0) return 0.0;
    return 100.0 - ((value - 10.0) / 40.0 * 100).clamp(0.0, 100.0);
  }

  static double _calculateQPhosphate(double value) {
    // Phosphate: 0-0.1 is excellent (Q = 100), >2.0 is very poor (Q = 0)
    if (value <= 0.1) return 100.0;
    if (value >= 2.0) return 0.0;
    return 100.0 - ((value - 0.1) / 1.9 * 100).clamp(0.0, 100.0);
  }

  static String getClassification(double wqi) {
    if (wqi >= 90) return 'Excellent';
    if (wqi >= 70) return 'Good';
    if (wqi >= 50) return 'Poor';
    return 'Very Poor';
  }
}
