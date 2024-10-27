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
    final keyDistances = {
      3: '5K',
      6: '10K',
      13: 'Half Marathon',
      26: 'Marathon',
    };

    for (int mile = 1; mile <= totalMiles.floor(); mile++) {
      currentTime = currentTime.add(paceDuration);
      totalElapsedTime += paceDuration;

      final elapsedText =
          "${totalElapsedTime.inHours}h ${totalElapsedTime.inMinutes % 60}m";
      final mileTimeText =
          "$mile mi: ${formatTime(currentTime)}  (Elapsed: $elapsedText)";

      // Regular mile marker
      splitTimes.add({
        'text': mileTimeText,
        'isBold': false,
      });

      // Insert key distance markers inline (like 5K, 10K, etc.)
      if (keyDistances.containsKey(mile)) {
        final keyDistance = keyDistances[mile]!;
        final keyDistanceText = "$keyDistance: ${formatTime(currentTime)}";
        splitTimes.add({
          'text': keyDistanceText,
          'isBold': true,
        });
      }
    }

    return splitTimes;
  }
}
