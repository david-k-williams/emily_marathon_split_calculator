import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:emily_marathon_split_calculator/models/race.dart';

class RaceService {
  static List<Race>? _races;

  static Future<List<Race>> getRaces() async {
    if (_races != null) {
      return _races!;
    }

    try {
      final String jsonString =
          await rootBundle.loadString('assets/races.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      _races = jsonList.map((json) => Race.fromJson(json)).toList();
      return _races!;
    } catch (e) {
      throw Exception('Failed to load race data: $e');
    }
  }

  static Future<Race?> getRaceByName(String name) async {
    final races = await getRaces();
    try {
      return races.firstWhere((race) => race.name == name);
    } catch (e) {
      return null;
    }
  }

  static Future<List<Race>> getRacesByCategory(String category) async {
    final races = await getRaces();
    return races.where((race) => race.category == category).toList();
  }

  static Future<List<String>> getRaceNames() async {
    final races = await getRaces();
    return races.map((race) => race.name).toList();
  }
}
