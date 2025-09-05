import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emily_marathon_split_calculator/services/gpx_parser.dart';

// Events
abstract class RaceSpecificEvent {}

class LoadAvailableRaces extends RaceSpecificEvent {}

class SelectRace extends RaceSpecificEvent {
  final String raceFileName;
  SelectRace(this.raceFileName);
}

class ToggleElevationDisplay extends RaceSpecificEvent {}

class ToggleElevationAdjustment extends RaceSpecificEvent {}

class SetTargetPace extends RaceSpecificEvent {
  final int hours;
  final int minutes;
  final int seconds;
  SetTargetPace({
    required this.hours,
    required this.minutes,
    required this.seconds,
  });
}

class SetPacePerMile extends RaceSpecificEvent {
  final int minutes;
  final int seconds;
  SetPacePerMile({
    required this.minutes,
    required this.seconds,
  });
}

class SetRaceStartTime extends RaceSpecificEvent {
  final int hours;
  final int minutes;
  SetRaceStartTime({
    required this.hours,
    required this.minutes,
  });
}

class CalculateRaceSplits extends RaceSpecificEvent {}

// States
abstract class RaceSpecificState {}

class RaceSpecificInitial extends RaceSpecificState {}

class RaceSpecificLoading extends RaceSpecificState {}

class RaceSpecificLoaded extends RaceSpecificState {
  final List<Map<String, String>> availableRaces;
  final String? selectedRaceFileName;
  final GPXRoute? selectedRoute;
  final bool showElevation;
  final int targetHours;
  final int targetMinutes;
  final int targetSeconds;
  final int paceMinutes;
  final int paceSeconds;
  final int startHours;
  final int startMinutes;
  final bool useElevationAdjustment;
  final List<SplitTime>? calculatedSplits;

  RaceSpecificLoaded({
    required this.availableRaces,
    this.selectedRaceFileName,
    this.selectedRoute,
    this.showElevation = false,
    this.targetHours = 0,
    this.targetMinutes = 0,
    this.targetSeconds = 0,
    this.paceMinutes = 8,
    this.paceSeconds = 0,
    this.startHours = 8,
    this.startMinutes = 0,
    this.useElevationAdjustment = false,
    this.calculatedSplits,
  });

  RaceSpecificLoaded copyWith({
    List<Map<String, String>>? availableRaces,
    String? selectedRaceFileName,
    GPXRoute? selectedRoute,
    bool? showElevation,
    int? targetHours,
    int? targetMinutes,
    int? targetSeconds,
    int? paceMinutes,
    int? paceSeconds,
    int? startHours,
    int? startMinutes,
    bool? useElevationAdjustment,
    List<SplitTime>? calculatedSplits,
  }) {
    return RaceSpecificLoaded(
      availableRaces: availableRaces ?? this.availableRaces,
      selectedRaceFileName: selectedRaceFileName ?? this.selectedRaceFileName,
      selectedRoute: selectedRoute ?? this.selectedRoute,
      showElevation: showElevation ?? this.showElevation,
      targetHours: targetHours ?? this.targetHours,
      targetMinutes: targetMinutes ?? this.targetMinutes,
      targetSeconds: targetSeconds ?? this.targetSeconds,
      paceMinutes: paceMinutes ?? this.paceMinutes,
      paceSeconds: paceSeconds ?? this.paceSeconds,
      startHours: startHours ?? this.startHours,
      startMinutes: startMinutes ?? this.startMinutes,
      useElevationAdjustment:
          useElevationAdjustment ?? this.useElevationAdjustment,
      calculatedSplits: calculatedSplits ?? this.calculatedSplits,
    );
  }
}

class RaceSpecificError extends RaceSpecificState {
  final String message;
  RaceSpecificError(this.message);
}

class SplitTime {
  final double distance; // in meters
  final int hours;
  final int minutes;
  final int seconds;
  final double? elevation;
  final String markerName;
  final int? arrivalHours;
  final int? arrivalMinutes;
  final int? arrivalSeconds;
  final double latitude;
  final double longitude;

  SplitTime({
    required this.distance,
    required this.hours,
    required this.minutes,
    required this.seconds,
    this.elevation,
    required this.markerName,
    this.arrivalHours,
    this.arrivalMinutes,
    this.arrivalSeconds,
    required this.latitude,
    required this.longitude,
  });

  String get formattedTime {
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  String get formattedArrivalTime {
    if (arrivalHours == null ||
        arrivalMinutes == null ||
        arrivalSeconds == null) {
      return 'N/A';
    }

    if (arrivalHours! > 0) {
      return '${arrivalHours.toString().padLeft(2, '0')}:${arrivalMinutes.toString().padLeft(2, '0')}:${arrivalSeconds.toString().padLeft(2, '0')}';
    } else {
      return '${arrivalMinutes.toString().padLeft(2, '0')}:${arrivalSeconds.toString().padLeft(2, '0')}';
    }
  }

  String get distanceDisplay {
    if (distance >= 1000) {
      return '${(distance / 1000).toStringAsFixed(1)} km';
    } else {
      return '${distance.toStringAsFixed(0)} m';
    }
  }
}

class RaceSpecificBloc extends Bloc<RaceSpecificEvent, RaceSpecificState> {
  RaceSpecificBloc() : super(RaceSpecificInitial()) {
    on<LoadAvailableRaces>(_onLoadAvailableRaces);
    on<SelectRace>(_onSelectRace);
    on<ToggleElevationDisplay>(_onToggleElevationDisplay);
    on<ToggleElevationAdjustment>(_onToggleElevationAdjustment);
    on<SetTargetPace>(_onSetTargetPace);
    on<SetPacePerMile>(_onSetPacePerMile);
    on<SetRaceStartTime>(_onSetRaceStartTime);
    on<CalculateRaceSplits>(_onCalculateRaceSplits);
  }

  Future<void> _onLoadAvailableRaces(
    LoadAvailableRaces event,
    Emitter<RaceSpecificState> emit,
  ) async {
    emit(RaceSpecificLoading());

    try {
      final races = await GPXParser.getAvailableRaces();
      emit(RaceSpecificLoaded(availableRaces: races));
    } catch (e) {
      emit(RaceSpecificError('Failed to load available races: $e'));
    }
  }

  Future<void> _onSelectRace(
    SelectRace event,
    Emitter<RaceSpecificState> emit,
  ) async {
    if (state is! RaceSpecificLoaded) return;

    final currentState = state as RaceSpecificLoaded;
    emit(currentState.copyWith(selectedRaceFileName: event.raceFileName));

    try {
      final route = await GPXParser.parseGPXFile(event.raceFileName);
      emit(currentState.copyWith(
        selectedRaceFileName: event.raceFileName,
        selectedRoute: route,
        calculatedSplits: null, // Reset splits when changing race
      ));
    } catch (e) {
      emit(RaceSpecificError('Failed to load race data: $e'));
    }
  }

  void _onToggleElevationDisplay(
    ToggleElevationDisplay event,
    Emitter<RaceSpecificState> emit,
  ) {
    if (state is! RaceSpecificLoaded) return;

    final currentState = state as RaceSpecificLoaded;
    emit(currentState.copyWith(showElevation: !currentState.showElevation));
  }

  void _onToggleElevationAdjustment(
    ToggleElevationAdjustment event,
    Emitter<RaceSpecificState> emit,
  ) {
    if (state is! RaceSpecificLoaded) return;

    final currentState = state as RaceSpecificLoaded;
    emit(currentState.copyWith(
      useElevationAdjustment: !currentState.useElevationAdjustment,
      calculatedSplits: null, // Reset splits when changing elevation adjustment
    ));
  }

  void _onSetTargetPace(
    SetTargetPace event,
    Emitter<RaceSpecificState> emit,
  ) {
    if (state is! RaceSpecificLoaded) return;

    final currentState = state as RaceSpecificLoaded;
    emit(currentState.copyWith(
      targetHours: event.hours,
      targetMinutes: event.minutes,
      targetSeconds: event.seconds,
      calculatedSplits: null, // Reset splits when changing pace
    ));
  }

  void _onSetPacePerMile(
    SetPacePerMile event,
    Emitter<RaceSpecificState> emit,
  ) {
    if (state is! RaceSpecificLoaded) return;

    final currentState = state as RaceSpecificLoaded;
    emit(currentState.copyWith(
      paceMinutes: event.minutes,
      paceSeconds: event.seconds,
      calculatedSplits: null, // Reset splits when changing pace
    ));
  }

  void _onSetRaceStartTime(
    SetRaceStartTime event,
    Emitter<RaceSpecificState> emit,
  ) {
    if (state is! RaceSpecificLoaded) return;

    final currentState = state as RaceSpecificLoaded;
    emit(currentState.copyWith(
      startHours: event.hours,
      startMinutes: event.minutes,
      calculatedSplits: null, // Reset splits when changing start time
    ));
  }

  void _onCalculateRaceSplits(
    CalculateRaceSplits event,
    Emitter<RaceSpecificState> emit,
  ) {
    if (state is! RaceSpecificLoaded) return;

    final currentState = state as RaceSpecificLoaded;
    if (currentState.selectedRoute == null) return;

    final route = currentState.selectedRoute!;
    final paceSeconds =
        currentState.paceMinutes * 60 + currentState.paceSeconds;
    final startTimeSeconds =
        currentState.startHours * 3600 + currentState.startMinutes * 60;

    if (paceSeconds == 0) return;

    final splits = <SplitTime>[];
    final mileMarkers = route.getMileMarkers();

    if (currentState.useElevationAdjustment) {
      // Use elevation-adjusted calculations
      final elevationSplits = _calculateElevationAdjustedSplits(
        basePaceSeconds: paceSeconds,
        route: route,
        mileMarkers: mileMarkers,
        startTimeSeconds: startTimeSeconds,
      );
      splits.addAll(elevationSplits);
    } else {
      // Use simple pace calculations
      for (int i = 0; i < mileMarkers.length; i++) {
        final marker = mileMarkers[i];
        final miles = marker.distance! / 1609.34; // Convert meters to miles
        final splitTimeSeconds = (miles * paceSeconds).round();

        final hours = splitTimeSeconds ~/ 3600;
        final minutes = (splitTimeSeconds % 3600) ~/ 60;
        final seconds = splitTimeSeconds % 60;

        // Calculate arrival time
        final arrivalTimeSeconds = startTimeSeconds + splitTimeSeconds;
        final arrivalHours = arrivalTimeSeconds ~/ 3600;
        final arrivalMinutes = (arrivalTimeSeconds % 3600) ~/ 60;
        final arrivalSeconds = arrivalTimeSeconds % 60;

        splits.add(SplitTime(
          distance: marker.distance!,
          hours: hours,
          minutes: minutes,
          seconds: seconds,
          elevation: marker.elevation,
          markerName: 'Mile ${i + 1}',
          arrivalHours: arrivalHours,
          arrivalMinutes: arrivalMinutes,
          arrivalSeconds: arrivalSeconds,
          latitude: marker.latitude,
          longitude: marker.longitude,
        ));
      }
    }

    emit(currentState.copyWith(calculatedSplits: splits));
  }

  List<SplitTime> _calculateElevationAdjustedSplits({
    required int basePaceSeconds,
    required GPXRoute route,
    required List<GPXPoint> mileMarkers,
    required int startTimeSeconds,
  }) {
    final splits = <SplitTime>[];
    int cumulativeTimeSeconds = 0;

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
      final adjustedPace = _calculateAdjustedPace(
        basePaceSeconds: basePaceSeconds,
        elevationGain: elevationGain,
        elevationLoss: elevationLoss,
        distanceMiles: miles,
      );

      // Calculate split time for this segment
      final segmentTimeSeconds = (miles * adjustedPace).round();
      cumulativeTimeSeconds += segmentTimeSeconds;

      final hours = cumulativeTimeSeconds ~/ 3600;
      final minutes = (cumulativeTimeSeconds % 3600) ~/ 60;
      final seconds = cumulativeTimeSeconds % 60;

      // Calculate arrival time
      final arrivalTimeSeconds = startTimeSeconds + cumulativeTimeSeconds;
      final arrivalHours = arrivalTimeSeconds ~/ 3600;
      final arrivalMinutes = (arrivalTimeSeconds % 3600) ~/ 60;
      final arrivalSeconds = arrivalTimeSeconds % 60;

      splits.add(SplitTime(
        distance: marker.distance!,
        hours: hours,
        minutes: minutes,
        seconds: seconds,
        elevation: marker.elevation,
        markerName: 'Mile ${i + 1}',
        arrivalHours: arrivalHours,
        arrivalMinutes: arrivalMinutes,
        arrivalSeconds: arrivalSeconds,
        latitude: marker.latitude,
        longitude: marker.longitude,
      ));
    }

    return splits;
  }

  int _calculateAdjustedPace({
    required int basePaceSeconds,
    required double elevationGain,
    required double elevationLoss,
    required double distanceMiles,
  }) {
    if (distanceMiles <= 0) return basePaceSeconds;

    // Elevation adjustment factors
    const double uphillFactor = 0.15; // 15% slower per 100m elevation gain
    const double downhillFactor = 0.05; // 5% faster per 100m elevation loss

    // Calculate elevation change per mile
    final elevationGainPerMile = elevationGain / distanceMiles;
    final elevationLossPerMile = elevationLoss / distanceMiles;

    // Calculate pace adjustment
    final uphillAdjustment =
        elevationGainPerMile * uphillFactor / 100; // per 100m
    final downhillAdjustment =
        elevationLossPerMile * downhillFactor / 100; // per 100m

    final totalAdjustment = uphillAdjustment - downhillAdjustment;

    // Apply adjustment (positive = slower, negative = faster)
    final adjustedPace = basePaceSeconds * (1 + totalAdjustment);

    return adjustedPace.round();
  }
}
