import 'package:flutter/material.dart';

class RaceSettingsState {
  final int paceMinutes;
  final int paceSeconds;
  final TimeOfDay startTime;
  final String raceDistance;
  final List<Map<String, dynamic>> splitTimes;
  final bool settingsVisible;

  RaceSettingsState({
    this.paceMinutes = 5,
    this.paceSeconds = 0,
    this.startTime = const TimeOfDay(hour: 8, minute: 0),
    this.raceDistance = 'Marathon',
    this.splitTimes = const [],
    this.settingsVisible = true,
  });

  RaceSettingsState copyWith({
    int? paceMinutes,
    int? paceSeconds,
    TimeOfDay? startTime,
    String? raceDistance,
    List<Map<String, dynamic>>? splitTimes,
    bool? settingsVisible,
  }) {
    return RaceSettingsState(
      paceMinutes: paceMinutes ?? this.paceMinutes,
      paceSeconds: paceSeconds ?? this.paceSeconds,
      startTime: startTime ?? this.startTime,
      raceDistance: raceDistance ?? this.raceDistance,
      splitTimes: splitTimes ?? this.splitTimes,
      settingsVisible: settingsVisible ?? this.settingsVisible,
    );
  }
}
