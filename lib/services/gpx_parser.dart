import 'package:flutter/services.dart';
import 'package:geoxml/geoxml.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class GPXPoint {
  final double latitude;
  final double longitude;
  final double? elevation;
  final double? distance; // Distance from start in meters

  GPXPoint({
    required this.latitude,
    required this.longitude,
    this.elevation,
    this.distance,
  });

  LatLng get latLng => LatLng(latitude, longitude);
}

class GPXRoute {
  final String name;
  final List<GPXPoint> points;
  final double totalDistance; // in meters
  final double? minElevation;
  final double? maxElevation;
  final double? elevationGain;

  GPXRoute({
    required this.name,
    required this.points,
    required this.totalDistance,
    this.minElevation,
    this.maxElevation,
    this.elevationGain,
  });

  // Get points at specific mile markers
  List<GPXPoint> getMileMarkers() {
    final mileMarkers = <GPXPoint>[];
    const double mileInMeters = 1609.34;

    for (int mile = 1; mile <= (totalDistance / mileInMeters).floor(); mile++) {
      final targetDistance = mile * mileInMeters;
      final point = _getPointAtDistance(targetDistance);
      if (point != null) {
        mileMarkers.add(point);
      }
    }

    return mileMarkers;
  }

  // Get points at specific kilometer markers
  List<GPXPoint> getKilometerMarkers() {
    final kmMarkers = <GPXPoint>[];
    const double kmInMeters = 1000.0;

    for (int km = 1; km <= (totalDistance / kmInMeters).floor(); km++) {
      final targetDistance = km * kmInMeters;
      final point = _getPointAtDistance(targetDistance);
      if (point != null) {
        kmMarkers.add(point);
      }
    }

    return kmMarkers;
  }

  GPXPoint? _getPointAtDistance(double targetDistance) {
    for (int i = 0; i < points.length - 1; i++) {
      final currentPoint = points[i];
      final nextPoint = points[i + 1];

      if (currentPoint.distance != null && nextPoint.distance != null) {
        if (currentPoint.distance! <= targetDistance &&
            nextPoint.distance! >= targetDistance) {
          // Interpolate between points
          final ratio = (targetDistance - currentPoint.distance!) /
              (nextPoint.distance! - currentPoint.distance!);

          final lat = currentPoint.latitude +
              (nextPoint.latitude - currentPoint.latitude) * ratio;
          final lon = currentPoint.longitude +
              (nextPoint.longitude - currentPoint.longitude) * ratio;
          final elev =
              currentPoint.elevation != null && nextPoint.elevation != null
                  ? currentPoint.elevation! +
                      (nextPoint.elevation! - currentPoint.elevation!) * ratio
                  : null;

          return GPXPoint(
            latitude: lat,
            longitude: lon,
            elevation: elev,
            distance: targetDistance,
          );
        }
      }
    }
    return null;
  }
}

class GPXParser {
  static Future<List<Map<String, String>>> getAvailableRaces() async {
    // For now, return the known race file with a user-friendly name
    // In a real app, you might want to maintain a list of available races
    return [
      {
        'fileName': '20250905103842-42193-data.gpx',
        'displayName': 'Marine Corps Marathon',
      },
      {
        'fileName': '20250905103959-42193-data.gpx',
        'displayName': 'Cherry Blossom 10 Miler',
      },
      {
        'fileName': '20250905104220-42193-data.gpx',
        'displayName': 'NYC Half Marathon',
      },
    ];
  }

  static Future<GPXRoute> parseGPXFile(String fileName) async {
    try {
      final content = await rootBundle.loadString('assets/races/$fileName');
      return await parseGPXContent(content, fileName);
    } catch (e) {
      throw Exception('Failed to load file: $e');
    }
  }

  static Future<GPXRoute> parseGPXContent(
      String content, String fileName) async {
    // Detect file type based on extension
    if (fileName.toLowerCase().endsWith('.gpx')) {
      return await _parseGPXFile(content);
    } else if (fileName.toLowerCase().endsWith('.kml')) {
      return await _parseKMLFile(content);
    } else {
      throw Exception('Unsupported file type: $fileName');
    }
  }

  static Future<GPXRoute> _parseKMLFile(String content) async {
    final kml = await KmlReader().fromString(content);

    // Try to access the KML data structure
    if (kml.toString().isEmpty) {
      throw Exception('No data found in KML file');
    }

    // For now, let's use a simpler approach and parse the coordinates directly from the content
    // This is a temporary solution until we figure out the correct API
    final coordinatesMatch =
        RegExp(r'<coordinates>(.*?)</coordinates>', dotAll: true)
            .firstMatch(content);

    if (coordinatesMatch == null) {
      throw Exception('No coordinates found in KML file');
    }

    final coordinatesString = coordinatesMatch.group(1)!.trim();
    final coordinatePairs = coordinatesString.split(RegExp(r'\s+'));

    if (coordinatePairs.isEmpty) {
      throw Exception('No coordinate pairs found in KML file');
    }

    // Extract track name
    final nameMatch =
        RegExp(r'<name><!\[CDATA\[(.*?)\]\]></name>').firstMatch(content);
    final trackName = nameMatch?.group(1) ?? 'Unknown Track';

    final points = <GPXPoint>[];
    double cumulativeDistance = 0.0;
    double? minElevation;
    double? maxElevation;
    double elevationGain = 0.0;
    GPXPoint? previousPoint;

    for (final coordString in coordinatePairs) {
      if (coordString.trim().isEmpty) continue;

      final parts = coordString.split(',');
      if (parts.length < 2) continue;

      final lon = double.tryParse(parts[0]) ?? 0.0;
      final lat = double.tryParse(parts[1]) ?? 0.0;
      final elevation = parts.length > 2 ? double.tryParse(parts[2]) : null;

      // Calculate distance from previous point
      if (previousPoint != null) {
        final distance = Geolocator.distanceBetween(
          previousPoint.latitude,
          previousPoint.longitude,
          lat,
          lon,
        );
        cumulativeDistance += distance;

        // Calculate elevation gain
        if (elevation != null && previousPoint.elevation != null) {
          final elevDiff = elevation - previousPoint.elevation!;
          if (elevDiff > 0) {
            elevationGain += elevDiff;
          }
        }
      }

      // Update min/max elevation
      if (elevation != null) {
        minElevation = minElevation == null
            ? elevation
            : (elevation < minElevation ? elevation : minElevation);
        maxElevation = maxElevation == null
            ? elevation
            : (elevation > maxElevation ? elevation : maxElevation);
      }

      final point = GPXPoint(
        latitude: lat,
        longitude: lon,
        elevation: elevation,
        distance: cumulativeDistance,
      );

      points.add(point);
      previousPoint = point;
    }

    return GPXRoute(
      name: trackName,
      points: points,
      totalDistance: cumulativeDistance,
      minElevation: minElevation,
      maxElevation: maxElevation,
      elevationGain: elevationGain,
    );
  }

  static Future<GPXRoute> _parseGPXFile(String content) async {
    final gpx = await GpxReader().fromString(content);

    // Try to access the GPX data structure
    if (gpx.toString().isEmpty) {
      throw Exception('No data found in GPX file');
    }

    // Extract track name
    final nameMatch = RegExp(r'<name>(.*?)</name>').firstMatch(content);
    final trackName = nameMatch?.group(1) ?? 'Unknown Track';

    // Extract track points using regex (similar to KML approach)
    final trkptMatches = RegExp(
            r'<trkpt[^>]*lat="([^"]*)"[^>]*lon="([^"]*)"[^>]*>(.*?)</trkpt>',
            dotAll: true)
        .allMatches(content);

    if (trkptMatches.isEmpty) {
      throw Exception('No track points found in GPX file');
    }

    print('DEBUG: Found ${trkptMatches.length} track points in GPX file');

    final points = <GPXPoint>[];
    double cumulativeDistance = 0.0;
    double? minElevation;
    double? maxElevation;
    double elevationGain = 0.0;
    GPXPoint? previousPoint;

    for (final match in trkptMatches) {
      final lat = double.tryParse(match.group(1)!) ?? 0.0;
      final lon = double.tryParse(match.group(2)!) ?? 0.0;

      // Extract elevation from the track point
      final eleMatch = RegExp(r'<ele>(.*?)</ele>').firstMatch(match.group(3)!);
      final elevation =
          eleMatch != null ? double.tryParse(eleMatch.group(1)!) : null;

      // Debug logging for first few points
      if (points.length < 3) {
        print(
            'DEBUG: GPX Point ${points.length + 1}: lat=$lat, lon=$lon, elevation=$elevation');
      }

      // Calculate distance from previous point
      if (previousPoint != null) {
        final distance = Geolocator.distanceBetween(
          previousPoint.latitude,
          previousPoint.longitude,
          lat,
          lon,
        );
        cumulativeDistance += distance;

        // Calculate elevation gain
        if (elevation != null && previousPoint.elevation != null) {
          final elevDiff = elevation - previousPoint.elevation!;
          if (elevDiff > 0) {
            elevationGain += elevDiff;
          }
        }
      }

      // Update min/max elevation
      if (elevation != null) {
        minElevation = minElevation == null
            ? elevation
            : (elevation < minElevation ? elevation : minElevation);
        maxElevation = maxElevation == null
            ? elevation
            : (elevation > maxElevation ? elevation : maxElevation);
      }

      final point = GPXPoint(
        latitude: lat,
        longitude: lon,
        elevation: elevation,
        distance: cumulativeDistance,
      );

      points.add(point);
      previousPoint = point;
    }

    return GPXRoute(
      name: trackName,
      points: points,
      totalDistance: cumulativeDistance,
      minElevation: minElevation,
      maxElevation: maxElevation,
      elevationGain: elevationGain,
    );
  }
}
