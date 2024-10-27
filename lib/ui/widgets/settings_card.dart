import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emily_marathon_split_calculator/bloc/bloc.dart';
import 'package:emily_marathon_split_calculator/bloc/bloc_state.dart';
import 'package:emily_marathon_split_calculator/bloc/bloc_event.dart';

class SettingsCard extends StatelessWidget {
  final RaceSettingsState settings;

  SettingsCard({required this.settings});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Race Type",
                style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: settings.raceDistance,
              items: context
                  .read<RaceSettingsBloc>()
                  .raceDistances
                  .keys
                  .map((String distance) {
                return DropdownMenuItem<String>(
                  value: distance,
                  child: Text(distance),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  context
                      .read<RaceSettingsBloc>()
                      .add(SetRaceDistance(newValue));
                }
              },
            ),
            const SizedBox(height: 16),
            const Text(
              "Pace",
              style: TextStyle(fontWeight: FontWeight.bold),
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
            Center(
              child: OutlinedButton(
                onPressed: () {
                  context.read<RaceSettingsBloc>().add(CalculateSplitsEvent());
                },
                child: const Text('Calculate'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
