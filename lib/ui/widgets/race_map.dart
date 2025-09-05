import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:emily_marathon_split_calculator/services/gpx_parser.dart';

class RaceMap extends StatelessWidget {
  final GPXRoute route;
  final List<GPXPoint>? mileMarkers;
  final bool showElevation;
  final Function(GPXPoint)? onMarkerTap;

  const RaceMap({
    super.key,
    required this.route,
    this.mileMarkers,
    this.showElevation = false,
    this.onMarkerTap,
  });

  @override
  Widget build(BuildContext context) {
    if (route.points.isEmpty) {
      return const Center(
        child: Text('No route data available'),
      );
    }

    // Calculate bounds
    final bounds = _calculateBounds(route.points);
    final center = bounds.center;

    return Column(
      children: [
        Container(
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FlutterMap(
              options: MapOptions(
                initialCenter: center,
                initialZoom: 12.0,
                minZoom: 5.0,
                maxZoom: 18.0,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
              ),
              children: [
                // Base map tiles - Using CartoDB for better appearance
                TileLayer(
                  urlTemplate:
                      'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                  subdomains: const ['a', 'b', 'c', 'd'],
                  userAgentPackageName: 'com.emily.marathon.calculator',
                  additionalOptions: const {
                    'attribution': '© OpenStreetMap contributors © CARTO',
                  },
                  retinaMode: RetinaMode.isHighDensity(context),
                ),

                // Route polyline with gradient effect
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: route.points.map((p) => p.latLng).toList(),
                      strokeWidth: 6.0,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    // Add a shadow/glow effect
                    Polyline(
                      points: route.points.map((p) => p.latLng).toList(),
                      strokeWidth: 8.0,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.3),
                    ),
                  ],
                ),

                // Start and finish markers
                MarkerLayer(
                  markers: [
                    // Start marker
                    Marker(
                      point: route.points.first.latLng,
                      width: 40,
                      height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    // Finish marker
                    Marker(
                      point: route.points.last.latLng,
                      width: 40,
                      height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.flag_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Mile markers
                if (mileMarkers != null)
                  MarkerLayer(
                    markers: mileMarkers!.asMap().entries.map((entry) {
                      final index = entry.key;
                      final point = entry.value;

                      return Marker(
                        point: point.latLng,
                        width: 36,
                        height: 36,
                        child: GestureDetector(
                          onTap: () {
                            if (onMarkerTap != null) {
                              onMarkerTap!(point);
                            }
                            _openInMaps(point.latLng);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ),
        if (showElevation) ...[
          const SizedBox(height: 16),
          ElevationProfile(
            route: route,
            mileMarkers: mileMarkers,
          ),
        ],
      ],
    );
  }

  LatLngBounds _calculateBounds(List<GPXPoint> points) {
    if (points.isEmpty) {
      return LatLngBounds(
        const LatLng(0, 0),
        const LatLng(0, 0),
      );
    }

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLon = points.first.longitude;
    double maxLon = points.first.longitude;

    for (final point in points) {
      minLat = minLat < point.latitude ? minLat : point.latitude;
      maxLat = maxLat > point.latitude ? maxLat : point.latitude;
      minLon = minLon < point.longitude ? minLon : point.longitude;
      maxLon = maxLon > point.longitude ? maxLon : point.longitude;
    }

    return LatLngBounds(
      LatLng(minLat, minLon),
      LatLng(maxLat, maxLon),
    );
  }

  void _openInMaps(LatLng point) async {
    final url =
        'https://www.google.com/maps?q=${point.latitude},${point.longitude}';
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class ElevationProfile extends StatelessWidget {
  final GPXRoute route;
  final List<GPXPoint>? mileMarkers;

  const ElevationProfile({
    super.key,
    required this.route,
    this.mileMarkers,
  });

  @override
  Widget build(BuildContext context) {
    if (route.points.isEmpty) {
      return const Center(
        child: Text('No route data available'),
      );
    }

    if (route.minElevation == null || route.maxElevation == null) {
      return const Center(
        child: Text('No elevation data available'),
      );
    }

    final points = route.points.where((p) => p.elevation != null).toList();

    if (points.isEmpty) {
      return const Center(
        child: Text('No elevation data available'),
      );
    }

    return Container(
      height: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Elevation Profile',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Min: ${route.minElevation!.toStringAsFixed(0)}m | '
            'Max: ${route.maxElevation!.toStringAsFixed(0)}m | '
            'Gain: ${route.elevationGain!.toStringAsFixed(0)}m',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: CustomPaint(
              painter: ElevationPainter(
                points: points,
                minElevation: route.minElevation!,
                maxElevation: route.maxElevation!,
                mileMarkers: mileMarkers,
                color: Theme.of(context).colorScheme.primary,
              ),
              size: Size.infinite,
            ),
          ),
        ],
      ),
    );
  }
}

class ElevationPainter extends CustomPainter {
  final List<GPXPoint> points;
  final double minElevation;
  final double maxElevation;
  final List<GPXPoint>? mileMarkers;
  final Color color;

  ElevationPainter({
    required this.points,
    required this.minElevation,
    required this.maxElevation,
    this.mileMarkers,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    final path = ui.Path();
    final fillPath = ui.Path();

    final elevationRange = maxElevation - minElevation;
    final totalDistance = points.last.distance ?? 0;

    // Start the path
    final firstPoint = points.first;
    final firstX = (firstPoint.distance ?? 0) / totalDistance * size.width;
    final firstY = size.height -
        ((firstPoint.elevation! - minElevation) / elevationRange * size.height);

    path.moveTo(firstX, firstY);
    fillPath.moveTo(firstX, size.height);
    fillPath.lineTo(firstX, firstY);

    // Draw the elevation line
    for (int i = 1; i < points.length; i++) {
      final point = points[i];
      final x = (point.distance ?? 0) / totalDistance * size.width;
      final y = size.height -
          ((point.elevation! - minElevation) / elevationRange * size.height);

      path.lineTo(x, y);
      fillPath.lineTo(x, y);
    }

    // Complete the fill path
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // Draw fill and stroke
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    // Draw mile markers
    if (mileMarkers != null) {
      final markerPaint = Paint()
        ..color = Colors.red
        ..style = PaintingStyle.fill;

      for (final marker in mileMarkers!) {
        final x = (marker.distance ?? 0) / totalDistance * size.width;
        final y = size.height -
            ((marker.elevation ?? minElevation) - minElevation) /
                elevationRange *
                size.height;

        canvas.drawCircle(Offset(x, y), 3, markerPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
