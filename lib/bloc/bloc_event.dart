import 'package:flutter/material.dart';

abstract class RaceSettingsEvent {}

class SetPaceMinutes extends RaceSettingsEvent {
  final int minutes;
  SetPaceMinutes(this.minutes);
}

class SetPaceSeconds extends RaceSettingsEvent {
  final int seconds;
  SetPaceSeconds(this.seconds);
}

class SetStartTime extends RaceSettingsEvent {
  final TimeOfDay time;
  SetStartTime(this.time);
}

class SetRaceDistance extends RaceSettingsEvent {
  final String distance;
  SetRaceDistance(this.distance);
}

class CalculateSplitsEvent extends RaceSettingsEvent {}

class ToggleSettingsVisibility extends RaceSettingsEvent {}

class ToggleUnits extends RaceSettingsEvent {}

class SetSelectedTab extends RaceSettingsEvent {
  final int tabIndex;
  SetSelectedTab(this.tabIndex);
}

class SetCalculatorHours extends RaceSettingsEvent {
  final int hours;
  SetCalculatorHours(this.hours);
}

class SetCalculatorMinutes extends RaceSettingsEvent {
  final int minutes;
  SetCalculatorMinutes(this.minutes);
}

class SetCalculatorSeconds extends RaceSettingsEvent {
  final int seconds;
  SetCalculatorSeconds(this.seconds);
}

class SetCalculatorDistance extends RaceSettingsEvent {
  final double distance;
  SetCalculatorDistance(this.distance);
}

class CalculatePace extends RaceSettingsEvent {}

class ExportSplits extends RaceSettingsEvent {}
