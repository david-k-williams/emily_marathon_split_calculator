import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class AppEvent {}

class SetSelectedTab extends AppEvent {
  final int tabIndex;
  SetSelectedTab(this.tabIndex);
}

class SetUnits extends AppEvent {
  final bool useMetricUnits;
  SetUnits(this.useMetricUnits);
}

// State
class AppState {
  final int selectedTabIndex;
  final bool useMetricUnits;

  const AppState({
    this.selectedTabIndex = 0,
    this.useMetricUnits = false,
  });

  AppState copyWith({
    int? selectedTabIndex,
    bool? useMetricUnits,
  }) {
    return AppState(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      useMetricUnits: useMetricUnits ?? this.useMetricUnits,
    );
  }
}

// Bloc
class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppState()) {
    on<SetSelectedTab>((event, emit) {
      emit(state.copyWith(selectedTabIndex: event.tabIndex));
    });

    on<SetUnits>((event, emit) {
      emit(state.copyWith(useMetricUnits: event.useMetricUnits));
    });
  }
}
