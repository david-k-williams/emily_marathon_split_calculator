import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emily_marathon_split_calculator/services/race_service.dart';
import 'package:emily_marathon_split_calculator/models/race.dart';

// Events
abstract class PaceCalculatorEvent {}

class SetPaceCalculatorDistance extends PaceCalculatorEvent {
  final double distance;
  SetPaceCalculatorDistance(this.distance);
}

class SetPaceCalculatorHours extends PaceCalculatorEvent {
  final int hours;
  SetPaceCalculatorHours(this.hours);
}

class SetPaceCalculatorMinutes extends PaceCalculatorEvent {
  final int minutes;
  SetPaceCalculatorMinutes(this.minutes);
}

class SetPaceCalculatorUnits extends PaceCalculatorEvent {
  final bool useMetricUnits;
  SetPaceCalculatorUnits(this.useMetricUnits);
}

class CalculatePaceCalculator extends PaceCalculatorEvent {}

// State
class PaceCalculatorState {
  final double selectedDistance;
  final int hours;
  final int minutes;
  final bool useMetricUnits;
  final Duration? calculatedPace;
  final String? errorMessage;
  final bool isLoading;

  const PaceCalculatorState({
    this.selectedDistance = 0.0,
    this.hours = 0,
    this.minutes = 0,
    this.useMetricUnits = false,
    this.calculatedPace,
    this.errorMessage,
    this.isLoading = false,
  });

  PaceCalculatorState copyWith({
    double? selectedDistance,
    int? hours,
    int? minutes,
    bool? useMetricUnits,
    Duration? calculatedPace,
    String? errorMessage,
    bool? isLoading,
  }) {
    return PaceCalculatorState(
      selectedDistance: selectedDistance ?? this.selectedDistance,
      hours: hours ?? this.hours,
      minutes: minutes ?? this.minutes,
      useMetricUnits: useMetricUnits ?? this.useMetricUnits,
      calculatedPace: calculatedPace ?? this.calculatedPace,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Bloc
class PaceCalculatorBloc
    extends Bloc<PaceCalculatorEvent, PaceCalculatorState> {
  List<Race> _races = [];

  PaceCalculatorBloc() : super(const PaceCalculatorState()) {
    _loadRaces();

    on<SetPaceCalculatorDistance>((event, emit) {
      emit(state.copyWith(selectedDistance: event.distance));
    });

    on<SetPaceCalculatorHours>((event, emit) {
      emit(state.copyWith(hours: event.hours));
    });

    on<SetPaceCalculatorMinutes>((event, emit) {
      emit(state.copyWith(minutes: event.minutes));
    });

    on<SetPaceCalculatorUnits>((event, emit) {
      emit(state.copyWith(useMetricUnits: event.useMetricUnits));
    });

    on<CalculatePaceCalculator>((event, emit) async {
      if (state.selectedDistance <= 0) {
        emit(state.copyWith(
          errorMessage: 'Please select a distance',
        ));
        return;
      }

      final totalSeconds = state.hours * 3600 + state.minutes * 60;
      if (totalSeconds <= 0) {
        emit(state.copyWith(
          errorMessage: 'Please enter a valid time',
        ));
        return;
      }

      final pacePerUnit = totalSeconds / state.selectedDistance;
      final paceMinutes = (pacePerUnit / 60).floor();
      final paceSeconds = (pacePerUnit % 60).round();

      emit(state.copyWith(
        calculatedPace: Duration(minutes: paceMinutes, seconds: paceSeconds),
        errorMessage: null,
      ));
    });
  }

  Future<void> _loadRaces() async {
    try {
      _races = await RaceService.getRaces();
    } catch (e) {
      // Handle error if needed
    }
  }

  List<Race> get races => _races;
}
