import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emily_marathon_split_calculator/services/prediction_service.dart';

// Events
abstract class PredictionEvent {}

class SetInputDistance extends PredictionEvent {
  final String distance;
  SetInputDistance(this.distance);
}

class SetInputTime extends PredictionEvent {
  final Duration time;
  SetInputTime(this.time);
}

class SetPredictionFormula extends PredictionEvent {
  final PredictionFormula formula;
  SetPredictionFormula(this.formula);
}

class CalculatePredictions extends PredictionEvent {}

// State
class PredictionState {
  final String inputDistance;
  final Duration inputTime;
  final PredictionFormula selectedFormula;
  final Map<String, PredictionResult> predictions;
  final bool isLoading;
  final String? errorMessage;

  const PredictionState({
    this.inputDistance = '5K',
    this.inputTime = const Duration(minutes: 20),
    this.selectedFormula = PredictionFormula.riegel,
    this.predictions = const {},
    this.isLoading = false,
    this.errorMessage,
  });

  PredictionState copyWith({
    String? inputDistance,
    Duration? inputTime,
    PredictionFormula? selectedFormula,
    Map<String, PredictionResult>? predictions,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PredictionState(
      inputDistance: inputDistance ?? this.inputDistance,
      inputTime: inputTime ?? this.inputTime,
      selectedFormula: selectedFormula ?? this.selectedFormula,
      predictions: predictions ?? this.predictions,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Bloc
class PredictionBloc extends Bloc<PredictionEvent, PredictionState> {
  PredictionBloc() : super(const PredictionState()) {
    on<SetInputDistance>((event, emit) {
      emit(state.copyWith(
        inputDistance: event.distance,
        errorMessage: null,
      ));
    });

    on<SetInputTime>((event, emit) {
      emit(state.copyWith(
        inputTime: event.time,
        errorMessage: null,
      ));
    });

    on<SetPredictionFormula>((event, emit) {
      emit(state.copyWith(
        selectedFormula: event.formula,
        errorMessage: null,
      ));
    });

    on<CalculatePredictions>((event, emit) {
      if (state.inputTime.inSeconds <= 0) {
        emit(state.copyWith(
          errorMessage: 'Please enter a valid time',
        ));
        return;
      }

      emit(state.copyWith(isLoading: true));

      try {
        final predictions = PredictionService.calculatePredictions(
          state.inputDistance,
          state.inputTime,
          state.selectedFormula,
        );

        emit(state.copyWith(
          predictions: predictions,
          isLoading: false,
          errorMessage: null,
        ));
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Error calculating predictions: $e',
        ));
      }
    });
  }
}
