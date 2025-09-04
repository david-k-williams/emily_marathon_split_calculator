class Race {
  final String name;
  final double distanceKm;
  final double distanceMiles;
  final String category;
  final List<RaceMilestone> milestones;

  Race({
    required this.name,
    required this.distanceKm,
    required this.distanceMiles,
    required this.category,
    required this.milestones,
  });

  factory Race.fromJson(Map<String, dynamic> json) {
    return Race(
      name: json['name'] as String,
      distanceKm: (json['distance_km'] as num).toDouble(),
      distanceMiles: (json['distance_miles'] as num).toDouble(),
      category: json['category'] as String,
      milestones: (json['milestones'] as List)
          .map((milestone) => RaceMilestone.fromJson(milestone))
          .toList(),
    );
  }

  double getDistance(bool useMetricUnits) {
    return useMetricUnits ? distanceKm : distanceMiles;
  }

  String getDistanceLabel(bool useMetricUnits) {
    return useMetricUnits ? 'km' : 'mi';
  }
}

class RaceMilestone {
  final String name;
  final double km;
  final double miles;

  RaceMilestone({
    required this.name,
    required this.km,
    required this.miles,
  });

  factory RaceMilestone.fromJson(Map<String, dynamic> json) {
    return RaceMilestone(
      name: json['name'] as String,
      km: (json['km'] as num).toDouble(),
      miles: (json['miles'] as num).toDouble(),
    );
  }

  double getDistance(bool useMetricUnits) {
    return useMetricUnits ? km : miles;
  }
}
