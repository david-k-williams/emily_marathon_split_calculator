import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emily_marathon_split_calculator/bloc/bloc.dart';
import 'package:emily_marathon_split_calculator/services/race_service.dart';
import 'package:emily_marathon_split_calculator/models/race.dart';

class SettingsCard extends StatelessWidget {
  final RaceSettingsState settings;

  const SettingsCard({required this.settings, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Race Type",
                style: TextStyle(fontWeight: FontWeight.bold)),
            FutureBuilder<List<Race>>(
              future: RaceService.getRaces(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                final races = snapshot.data ?? [];
                return DropdownButton<String>(
                  value: settings.raceDistance,
                  items: races
                      .map((Race race) => DropdownMenuItem<String>(
                            value: race.name,
                            child: Text(race.name),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      context
                          .read<RaceSettingsBloc>()
                          .add(SetRaceDistance(newValue));
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              "Pace (per ${settings.useMetricUnits ? 'km' : 'mi'})",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                DropdownButton<int>(
                  value: settings.paceMinutes,
                  items: [
                    for (int i = 5; i <= 20; i++)
                      DropdownMenuItem(value: i, child: Text('$i min'))
                  ],
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      context
                          .read<RaceSettingsBloc>()
                          .add(SetPaceMinutes(newValue));
                    }
                  },
                ),
                const Text(" : "),
                DropdownButton<int>(
                  value: settings.paceSeconds,
                  items: [
                    for (int i = 0; i < 60; i += 5)
                      DropdownMenuItem(value: i, child: Text('$i sec'))
                  ],
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      context
                          .read<RaceSettingsBloc>()
                          .add(SetPaceSeconds(newValue));
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text("Start Time",
                style: TextStyle(fontWeight: FontWeight.bold)),
            ElevatedButton(
              onPressed: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: settings.startTime,
                );
                if (picked != null) {
                  context.read<RaceSettingsBloc>().add(SetStartTime(picked));
                }
              },
              child: Text('Start Time: ${settings.startTime.format(context)}'),
            ),
            const SizedBox(height: 16),
            if (settings.errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        settings.errorMessage!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<RaceSettingsBloc>().add(CalculateSplitsEvent());
                },
                child: const Text('Calculate Splits'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
