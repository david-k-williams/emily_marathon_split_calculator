import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emily_marathon_split_calculator/utils/time_formatter.dart';
import 'package:emily_marathon_split_calculator/bloc/bloc_event.dart';
import 'package:emily_marathon_split_calculator/bloc/bloc_state.dart';
import 'package:emily_marathon_split_calculator/services/race_service.dart';
import 'package:emily_marathon_split_calculator/models/race.dart';

class RaceSettingsBloc extends Bloc<RaceSettingsEvent, RaceSettingsState> {
  List<Race> _races = [];

  RaceSettingsBloc() : super(RaceSettingsState()) {
    _loadRaces();
    on<SetPaceMinutes>((event, emit) {
      emit(state.copyWith(paceMinutes: event.minutes));
    });
    on<SetPaceSeconds>((event, emit) {
      emit(state.copyWith(paceSeconds: event.seconds));
    });
    on<SetStartTime>((event, emit) {
      emit(state.copyWith(startTime: event.time));
    });
    on<SetRaceDistance>((event, emit) {
      emit(state.copyWith(raceDistance: event.distance));
    });
    on<CalculateSplitsEvent>((event, emit) {
      // Validate pace inputs
      if (state.paceMinutes < 3 || state.paceMinutes > 20) {
        emit(state.copyWith(
          errorMessage: 'Pace must be between 3:00 and 20:00 per mile',
          settingsVisible: true,
        ));
        return;
      }

      if (state.paceSeconds < 0 || state.paceSeconds >= 60) {
        emit(state.copyWith(
          errorMessage: 'Seconds must be between 0 and 59',
          settingsVisible: true,
        ));
        return;
      }

      // Clear any previous error and calculate splits
      emit(state.copyWith(
        splitTimes: calculateSplits(state),
        settingsVisible: false,
        errorMessage: null,
      ));
    });
    on<ToggleSettingsVisibility>((event, emit) {
      emit(state.copyWith(settingsVisible: !state.settingsVisible));
    });
    on<ToggleUnits>((event, emit) {
      emit(state.copyWith(useMetricUnits: !state.useMetricUnits));
    });
    on<SetSelectedTab>((event, emit) {
      emit(state.copyWith(selectedTabIndex: event.tabIndex));
    });
    on<SetCalculatorHours>((event, emit) {
      emit(state.copyWith(calculatorHours: event.hours));
    });
    on<SetCalculatorMinutes>((event, emit) {
      emit(state.copyWith(calculatorMinutes: event.minutes));
    });
    on<SetCalculatorSeconds>((event, emit) {
      emit(state.copyWith(calculatorSeconds: event.seconds));
    });
    on<SetCalculatorDistance>((event, emit) {
      emit(state.copyWith(calculatorDistance: event.distance));
    });
    on<CalculatePace>((event, emit) {
      if (state.calculatorDistance <= 0) {
        emit(state.copyWith(
          errorMessage: 'Distance must be greater than 0',
          settingsVisible: true,
        ));
        return;
      }

      final totalSeconds = state.calculatorHours * 3600 +
          state.calculatorMinutes * 60 +
          state.calculatorSeconds;

      if (totalSeconds <= 0) {
        emit(state.copyWith(
          errorMessage: 'Time must be greater than 0',
          settingsVisible: true,
        ));
        return;
      }

      final pacePerUnit = totalSeconds / state.calculatorDistance;
      final paceMinutes = (pacePerUnit / 60).floor();
      final paceSeconds = (pacePerUnit % 60).round();

      emit(state.copyWith(
        paceMinutes: paceMinutes,
        paceSeconds: paceSeconds,
        errorMessage: null,
      ));
    });
    on<ExportSplits>((event, emit) {
      // This will be handled in the UI layer
    });
  }

  final Map<String, double> raceDistances = {
    '5K': 3.1,
    '10K': 6.2,
    'Half Marathon': 13.1,
    'Marathon': 26.2,
  };

  final Map<String, double> raceDistancesKm = {
    '5K': 5.0,
    '10K': 10.0,
    'Half Marathon': 21.1,
    'Marathon': 42.2,
  };

  List<Map<String, dynamic>> calculateSplits(RaceSettingsState state) {
    final totalDistance = state.useMetricUnits
        ? raceDistancesKm[state.raceDistance] ?? 42.2
        : raceDistances[state.raceDistance] ?? 26.2;
    final paceDuration =
        Duration(minutes: state.paceMinutes, seconds: state.paceSeconds);
    DateTime currentTime =
        DateTime(2024, 1, 1, state.startTime.hour, state.startTime.minute);
    Duration totalElapsedTime = Duration.zero;

    List<Map<String, dynamic>> splitTimes = [];

    // Add Start Time
    splitTimes.add({
      'text': "Start: ${formatTime(currentTime)}",
      'isBold': true,
    });

    // Key distances with precise fractional values
    final keyDistances = state.useMetricUnits
        ? {
            5.0: '5K',
            10.0: '10K',
            21.1: 'Half Marathon',
            42.2: 'Marathon',
          }
        : {
            3.1: '5K',
            6.2: '10K',
            13.1: 'Half Marathon',
            26.2: 'Marathon',
          };

    final unitLabel = state.useMetricUnits ? 'km' : 'mi';
    final distanceStep = state.useMetricUnits ? 1.0 : 1.0;

    for (double distance = distanceStep;
        distance <= totalDistance;
        distance += distanceStep) {
      // Update time and add regular distance marker
      currentTime = currentTime.add(paceDuration);
      totalElapsedTime += paceDuration;
      final elapsedText =
          "${totalElapsedTime.inHours}h ${totalElapsedTime.inMinutes % 60}m";
      final distanceTimeText =
          "${distance.toInt()}$unitLabel: ${formatTime(currentTime)}  (Elapsed: $elapsedText)";

      splitTimes.add({
        'text': distanceTimeText,
        'isBold': false,
      });

      // Check if we need to add any key distances inline
      for (var keyDistance in keyDistances.keys) {
        if (keyDistance > distance && keyDistance < distance + 1) {
          // Calculate time for the fractional distance
          final fractionalDistance = keyDistance - distance;
          final fractionalTime = Duration(
            minutes: (state.paceMinutes * fractionalDistance).toInt(),
            seconds: (state.paceSeconds * fractionalDistance).toInt(),
          );

          final keyDistanceTime = currentTime.add(fractionalTime);
          final keyElapsedTime = totalElapsedTime + fractionalTime;

          final keyElapsedText =
              "${keyElapsedTime.inHours}h ${keyElapsedTime.inMinutes % 60}m";
          final keyDistanceText =
              "${keyDistances[keyDistance]}: ${formatTime(keyDistanceTime)} (Elapsed: $keyElapsedText)";

          splitTimes.add({
            'text': keyDistanceText,
            'isBold': true,
          });
        }
      }
    }

    // Handle partial distance if it exists
    final partialDistance = totalDistance - totalDistance.floor();
    if (partialDistance > 0) {
      final partialTime = Duration(
        minutes: (state.paceMinutes * partialDistance).toInt(),
        seconds: (state.paceSeconds * partialDistance).toInt(),
      );

      final partialDistanceTime = currentTime.add(partialTime);
      totalElapsedTime += partialTime;
      final partialElapsedText =
          "${totalElapsedTime.inHours}h ${totalElapsedTime.inMinutes % 60}m";

      splitTimes.add({
        'text':
            "${totalDistance.toStringAsFixed(1)}$unitLabel: ${formatTime(partialDistanceTime)}  (Elapsed: $partialElapsedText)",
        'isBold': false,
      });
    }

    return splitTimes;
  }

  Future<void> _loadRaces() async {
    try {
      _races = await RaceService.getRaces();
    } catch (e) {
      // Handle error - races will remain empty
      print('Error loading races: $e');
    }
  }

  Race? _getCurrentRace() {
    if (_races.isEmpty) return null;
    try {
      return _races.firstWhere((race) => race.name == state.raceDistance);
    } catch (e) {
      return _races.first; // Fallback to first race
    }
  }
}
