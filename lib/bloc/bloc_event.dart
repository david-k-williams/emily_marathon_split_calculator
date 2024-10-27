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
