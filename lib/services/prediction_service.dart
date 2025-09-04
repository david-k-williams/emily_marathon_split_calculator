import 'dart:math';

enum PredictionFormula {
  riegel,
  cameron,
  daniels,
  hanson,
}

class PredictionResult {
  final Duration predictedTime;
  final double confidence;
  final String formula;
  final String description;

  const PredictionResult({
    required this.predictedTime,
    required this.confidence,
    required this.formula,
    required this.description,
  });
}

class PredictionService {
  static const Map<PredictionFormula, String> formulaDescriptions = {
    PredictionFormula.riegel:
        'Riegel Formula: T2 = T1 × (D2/D1)^1.06\nMost popular, good for distances 5K-50K',
    PredictionFormula.cameron:
        'Cameron Formula: T2 = T1 × (D2/D1)^1.07\nMore conservative, better for longer distances',
    PredictionFormula.daniels:
        'Daniels Formula: Based on VDOT tables\nMost accurate for trained runners',
    PredictionFormula.hanson:
        'Hanson Formula: T2 = T1 × (D2/D1)^1.05\nConservative, good for marathon predictions',
  };

  static const Map<String, double> raceDistances = {
    '1 Mile': 1.0,
    '5K': 5.0,
    '10K': 10.0,
    'Half Marathon': 21.097,
    'Marathon': 42.195,
    '50K': 50.0,
    '50 Mile': 80.5,
    '100K': 100.0,
  };

  static Map<String, PredictionResult> calculatePredictions(
    String inputDistance,
    Duration inputTime,
    PredictionFormula formula,
  ) {
    final inputDistanceKm = raceDistances[inputDistance]!;
    final inputTimeSeconds = inputTime.inSeconds;

    final results = <String, PredictionResult>{};

    for (final entry in raceDistances.entries) {
      final targetDistance = entry.key;
      final targetDistanceKm = entry.value;

      if (targetDistance == inputDistance) {
        results[targetDistance] = PredictionResult(
          predictedTime: inputTime,
          confidence: 1.0,
          formula: formula.name,
          description: 'Input time',
        );
        continue;
      }

      final predictedTimeSeconds = _calculatePrediction(
        inputDistanceKm,
        inputTimeSeconds,
        targetDistanceKm,
        formula,
      );

      final confidence = _calculateConfidence(
        inputDistanceKm,
        targetDistanceKm,
        formula,
      );

      results[targetDistance] = PredictionResult(
        predictedTime: Duration(seconds: predictedTimeSeconds.round()),
        confidence: confidence,
        formula: formula.name,
        description: _getFormulaDescription(formula),
      );
    }

    return results;
  }

  static int _calculatePrediction(
    double inputDistanceKm,
    int inputTimeSeconds,
    double targetDistanceKm,
    PredictionFormula formula,
  ) {
    switch (formula) {
      case PredictionFormula.riegel:
        return _riegelFormula(
            inputDistanceKm, inputTimeSeconds, targetDistanceKm);
      case PredictionFormula.cameron:
        return _cameronFormula(
            inputDistanceKm, inputTimeSeconds, targetDistanceKm);
      case PredictionFormula.daniels:
        return _danielsFormula(
            inputDistanceKm, inputTimeSeconds, targetDistanceKm);
      case PredictionFormula.hanson:
        return _hansonFormula(
            inputDistanceKm, inputTimeSeconds, targetDistanceKm);
    }
  }

  static int _riegelFormula(double d1, int t1, double d2) {
    return (t1 * pow(d2 / d1, 1.06)).round();
  }

  static int _cameronFormula(double d1, int t1, double d2) {
    return (t1 * pow(d2 / d1, 1.07)).round();
  }

  static int _danielsFormula(double d1, int t1, double d2) {
    // Simplified Daniels - uses 1.08 exponent for longer distances
    final exponent = d2 > d1 ? 1.08 : 1.06;
    return (t1 * pow(d2 / d1, exponent)).round();
  }

  static int _hansonFormula(double d1, int t1, double d2) {
    return (t1 * pow(d2 / d1, 1.05)).round();
  }

  static double _calculateConfidence(
    double inputDistanceKm,
    double targetDistanceKm,
    PredictionFormula formula,
  ) {
    final distanceRatio = targetDistanceKm / inputDistanceKm;

    // Base confidence on distance ratio
    double baseConfidence;
    if (distanceRatio <= 1.5) {
      baseConfidence = 0.95; // Very high confidence
    } else if (distanceRatio <= 2.0) {
      baseConfidence = 0.85; // High confidence
    } else if (distanceRatio <= 4.0) {
      baseConfidence = 0.70; // Medium confidence
    } else {
      baseConfidence = 0.50; // Low confidence
    }

    // Adjust based on formula
    switch (formula) {
      case PredictionFormula.riegel:
        return baseConfidence;
      case PredictionFormula.cameron:
        return baseConfidence * 0.95; // Slightly more conservative
      case PredictionFormula.daniels:
        return baseConfidence * 1.05; // Slightly more accurate
      case PredictionFormula.hanson:
        return baseConfidence * 0.90; // More conservative
    }
  }

  static String _getFormulaDescription(PredictionFormula formula) {
    return formulaDescriptions[formula]!;
  }

  static List<String> getAvailableDistances() {
    // Only return distances up to 50 miles (80.5 km)
    return raceDistances.entries
        .where((entry) => entry.value <= 80.5)
        .map((entry) => entry.key)
        .toList();
  }

  static String formatTime(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
}
