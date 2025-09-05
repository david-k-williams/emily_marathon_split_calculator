import 'package:emily_marathon_split_calculator/services/gpx_parser.dart';

class ElevationPaceService {
  // Elevation adjustment factors based on research
  // These are rough estimates - actual impact varies by individual fitness
  static const double _uphillFactor =
      0.15; // 15% slower per 100m elevation gain
  static const double _downhillFactor =
      0.05; // 5% faster per 100m elevation loss

  /// Calculate elevation-adjusted pace for a given segment
  ///
  /// [basePaceSeconds] - Base pace per mile in seconds
  /// [elevationGain] - Elevation gain in meters
  /// [elevationLoss] - Elevation loss in meters
  /// [distanceMiles] - Distance of the segment in miles
  ///
  /// Returns adjusted pace in seconds per mile
  static int calculateAdjustedPace({
    required int basePaceSeconds,
    required double elevationGain,
    required double elevationLoss,
    required double distanceMiles,
  }) {
    if (distanceMiles <= 0) return basePaceSeconds;

    // Calculate elevation change per mile
    final elevationGainPerMile = elevationGain / distanceMiles;
    final elevationLossPerMile = elevationLoss / distanceMiles;

    // Calculate pace adjustment
    final uphillAdjustment =
        elevationGainPerMile * _uphillFactor / 100; // per 100m
    final downhillAdjustment =
        elevationLossPerMile * _downhillFactor / 100; // per 100m

    final totalAdjustment = uphillAdjustment - downhillAdjustment;

    // Apply adjustment (positive = slower, negative = faster)
    final adjustedPace = basePaceSeconds * (1 + totalAdjustment);

    return adjustedPace.round();
  }

  /// Calculate elevation-adjusted splits for a route
  ///
  /// [basePaceSeconds] - Base pace per mile in seconds
  /// [route] - GPX route with elevation data
  /// [mileMarkers] - Mile markers along the route
  ///
  /// Returns list of adjusted split times
  static List<ElevationAdjustedSplit> calculateElevationAdjustedSplits({
    required int basePaceSeconds,
    required GPXRoute route,
    required List<GPXPoint> mileMarkers,
  }) {
    final splits = <ElevationAdjustedSplit>[];

    for (int i = 0; i < mileMarkers.length; i++) {
      final marker = mileMarkers[i];
      final distance = marker.distance!;
      final miles = distance / 1609.34; // Convert meters to miles

      // Calculate elevation change for this segment
      double elevationGain = 0;
      double elevationLoss = 0;

      if (i == 0) {
        // First mile - from start to first marker
        final startElevation = route.points.first.elevation ?? 0;
        final endElevation = marker.elevation ?? 0;
        final elevationChange = endElevation - startElevation;

        if (elevationChange > 0) {
          elevationGain = elevationChange;
        } else {
          elevationLoss = -elevationChange;
        }
      } else {
        // Subsequent miles - from previous marker to current marker
        final prevMarker = mileMarkers[i - 1];
        final prevElevation = prevMarker.elevation ?? 0;
        final currentElevation = marker.elevation ?? 0;
        final elevationChange = currentElevation - prevElevation;

        if (elevationChange > 0) {
          elevationGain = elevationChange;
        } else {
          elevationLoss = -elevationChange;
        }
      }

      // Calculate adjusted pace for this segment
      final adjustedPace = calculateAdjustedPace(
        basePaceSeconds: basePaceSeconds,
        elevationGain: elevationGain,
        elevationLoss: elevationLoss,
        distanceMiles: miles,
      );

      // Calculate split time
      final splitTimeSeconds = (miles * adjustedPace).round();
      final hours = splitTimeSeconds ~/ 3600;
      final minutes = (splitTimeSeconds % 3600) ~/ 60;
      final seconds = splitTimeSeconds % 60;

      splits.add(ElevationAdjustedSplit(
        distance: distance,
        hours: hours,
        minutes: minutes,
        seconds: seconds,
        elevation: marker.elevation,
        markerName: 'Mile ${i + 1}',
        elevationGain: elevationGain,
        elevationLoss: elevationLoss,
        adjustedPaceSeconds: adjustedPace,
        basePaceSeconds: basePaceSeconds,
      ));
    }

    return splits;
  }
}

class ElevationAdjustedSplit {
  final double distance;
  final int hours;
  final int minutes;
  final int seconds;
  final double? elevation;
  final String markerName;
  final double elevationGain;
  final double elevationLoss;
  final int adjustedPaceSeconds;
  final int basePaceSeconds;

  ElevationAdjustedSplit({
    required this.distance,
    required this.hours,
    required this.minutes,
    required this.seconds,
    this.elevation,
    required this.markerName,
    required this.elevationGain,
    required this.elevationLoss,
    required this.adjustedPaceSeconds,
    required this.basePaceSeconds,
  });

  String get formattedTime {
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  String get formattedAdjustedPace {
    final adjMinutes = adjustedPaceSeconds ~/ 60;
    final adjSeconds = adjustedPaceSeconds % 60;
    return '$adjMinutes:${adjSeconds.toString().padLeft(2, '0')}';
  }

  String get formattedBasePace {
    final baseMinutes = basePaceSeconds ~/ 60;
    final baseSeconds = basePaceSeconds % 60;
    return '$baseMinutes:${baseSeconds.toString().padLeft(2, '0')}';
  }

  String get distanceDisplay {
    if (distance >= 1000) {
      return '${(distance / 1000).toStringAsFixed(1)} km';
    } else {
      return '${distance.toStringAsFixed(0)} m';
    }
  }

  String get elevationChangeDisplay {
    if (elevationGain > 0) {
      return '+${elevationGain.toStringAsFixed(0)}m';
    } else if (elevationLoss > 0) {
      return '-${elevationLoss.toStringAsFixed(0)}m';
    } else {
      return '0m';
    }
  }
}
