import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emily_marathon_split_calculator/utils/time_formatter.dart';
import 'package:emily_marathon_split_calculator/bloc/bloc_event.dart';
import 'package:emily_marathon_split_calculator/bloc/bloc_state.dart';

class RaceSettingsBloc extends Bloc<RaceSettingsEvent, RaceSettingsState> {
  RaceSettingsBloc() : super(RaceSettingsState()) {
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
      emit(state.copyWith(
          splitTimes: calculateSplits(state), settingsVisible: false));
    });
    on<ToggleSettingsVisibility>((event, emit) {
      emit(state.copyWith(settingsVisible: !state.settingsVisible));
    });
  }

  final Map<String, double> raceDistances = {
    '5K': 3.1,
    '10K': 6.2,
    'Half Marathon': 13.1,
    'Marathon': 26.2,
  };

  List<Map<String, dynamic>> calculateSplits(RaceSettingsState state) {
    final totalMiles = raceDistances[state.raceDistance] ?? 26.2;
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
    final keyDistances = {
      3.1: '5K',
      6.2: '10K',
      13.1: 'Half Marathon',
      26.2: 'Marathon',
    };

    for (int mile = 1; mile <= totalMiles.floor(); mile++) {
      // Update time and add regular mile marker
      currentTime = currentTime.add(paceDuration);
      totalElapsedTime += paceDuration;
      final elapsedText =
          "${totalElapsedTime.inHours}h ${totalElapsedTime.inMinutes % 60}m";
      final mileTimeText =
          "$mile mi: ${formatTime(currentTime)}  (Elapsed: $elapsedText)";

      splitTimes.add({
        'text': mileTimeText,
        'isBold': false,
      });

      // Check if we need to add any key distances inline
      for (var keyDistance in keyDistances.keys) {
        if (keyDistance > mile && keyDistance < mile + 1) {
          // Calculate time for the fractional distance
          final fractionalMile = keyDistance - mile;
          final fractionalTime = Duration(
            minutes: (state.paceMinutes * fractionalMile).toInt(),
            seconds: (state.paceSeconds * fractionalMile).toInt(),
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

    // Handle partial distance if it exists (e.g., for Marathon races)
    final partialMile = totalMiles - totalMiles.floor();
    if (partialMile > 0) {
      final partialTime = Duration(
        minutes: (state.paceMinutes * partialMile).toInt(),
        seconds: (state.paceSeconds * partialMile).toInt(),
      );

      final partialMileTime = currentTime.add(partialTime);
      totalElapsedTime += partialTime;
      final partialElapsedText =
          "${totalElapsedTime.inHours}h ${totalElapsedTime.inMinutes % 60}m";

      splitTimes.add({
        'text':
            "Mile ${totalMiles.toStringAsFixed(1)}: ${formatTime(partialMileTime)}  (Elapsed: $partialElapsedText)",
        'isBold': false,
      });
    }

    return splitTimes;
  }
}
