import 'package:flutter/material.dart';

class RaceSettingsState {
  final int paceMinutes;
  final int paceSeconds;
  final TimeOfDay startTime;
  final String raceDistance;
  final List<Map<String, dynamic>> splitTimes;
  final bool settingsVisible;
  final String? errorMessage;
  final bool useMetricUnits; // true for km, false for miles
  final int selectedTabIndex; // 0 for split calculator, 1 for pace calculator
  final int calculatorHours;
  final int calculatorMinutes;
  final int calculatorSeconds;
  final double calculatorDistance;

  RaceSettingsState({
    this.paceMinutes = 5,
    this.paceSeconds = 0,
    this.startTime = const TimeOfDay(hour: 8, minute: 0),
    this.raceDistance = 'Marathon',
    this.splitTimes = const [],
    this.settingsVisible = true,
    this.errorMessage,
    this.useMetricUnits = false,
    this.selectedTabIndex = 0,
    this.calculatorHours = 0,
    this.calculatorMinutes = 0,
    this.calculatorSeconds = 0,
    this.calculatorDistance = 1.0,
  });

  RaceSettingsState copyWith({
    int? paceMinutes,
    int? paceSeconds,
    TimeOfDay? startTime,
    String? raceDistance,
    List<Map<String, dynamic>>? splitTimes,
    bool? settingsVisible,
    String? errorMessage,
    bool? useMetricUnits,
    int? selectedTabIndex,
    int? calculatorHours,
    int? calculatorMinutes,
    int? calculatorSeconds,
    double? calculatorDistance,
  }) {
    return RaceSettingsState(
      paceMinutes: paceMinutes ?? this.paceMinutes,
      paceSeconds: paceSeconds ?? this.paceSeconds,
      startTime: startTime ?? this.startTime,
      raceDistance: raceDistance ?? this.raceDistance,
      splitTimes: splitTimes ?? this.splitTimes,
      settingsVisible: settingsVisible ?? this.settingsVisible,
      errorMessage: errorMessage ?? this.errorMessage,
      useMetricUnits: useMetricUnits ?? this.useMetricUnits,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      calculatorHours: calculatorHours ?? this.calculatorHours,
      calculatorMinutes: calculatorMinutes ?? this.calculatorMinutes,
      calculatorSeconds: calculatorSeconds ?? this.calculatorSeconds,
      calculatorDistance: calculatorDistance ?? this.calculatorDistance,
    );
  }
}
