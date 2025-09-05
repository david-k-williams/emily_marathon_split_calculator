import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emily_marathon_split_calculator/bloc/blocs.dart';
import 'package:emily_marathon_split_calculator/services/race_service.dart';
import 'package:emily_marathon_split_calculator/models/race.dart';
import 'package:emily_marathon_split_calculator/ui/widgets/consistent_inputs.dart';
import 'package:emily_marathon_split_calculator/ui/theme/theme.dart';

class SettingsCard extends StatelessWidget {
  final RaceSettingsState settings;

  const SettingsCard({required this.settings, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 200,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Race Distance Selector
              _buildRaceSelector(context, settings),
              const SizedBox(height: 16),

              // Pace Input
              _buildPaceInput(context, settings),
              const SizedBox(height: 16),

              // Start Time Picker
              _buildStartTimePicker(context, settings),
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
                            color:
                                Theme.of(context).colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRaceSelector(BuildContext context, RaceSettingsState settings) {
    return FutureBuilder<List<Race>>(
      future: RaceService.getRaces(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 56,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Container(
            height: 56,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Error loading races: ${snapshot.error}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          );
        }

        final races = snapshot.data ?? [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InputLabel(text: "Race Type", required: true),
            const InputSpacing(),
            StandardDropdown<String>(
              value: settings.raceDistance,
              hintText: 'Select a race distance',
              items: races.map((Race race) {
                return DropdownMenuItem<String>(
                  value: race.name,
                  child: Text(race.name),
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
          ],
        );
      },
    );
  }

  Widget _buildPaceInput(BuildContext context, RaceSettingsState settings) {
    return SizedBox(
      width: double.infinity,
      child: InteractiveTimeInput(
        initialTime: Duration(
          hours: 0,
          minutes: settings.paceMinutes,
          seconds: settings.paceSeconds,
        ),
        onTimeChanged: (time) {
          context
              .read<RaceSettingsBloc>()
              .add(SetPaceMinutes(time.inMinutes % 60));
          context
              .read<RaceSettingsBloc>()
              .add(SetPaceSeconds(time.inSeconds % 60));
        },
        label: "Pace (per ${settings.useMetricUnits ? 'km' : 'mi'})",
        showSeconds: true,
        showHours: false,
      ),
    );
  }

  Widget _buildStartTimePicker(
      BuildContext context, RaceSettingsState settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const InputLabel(text: "Start Time"),
        const InputSpacing(),
        GestureDetector(
          onTap: () => _selectTime(context),
          child: Container(
            padding: EdgeInsets.all(appTheme(context).cardPadding),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius:
                  BorderRadius.circular(appTheme(context).borderRadius),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    settings.startTime.format(context),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: settings.startTime,
    );
    if (picked != null && context.mounted) {
      context.read<RaceSettingsBloc>().add(SetStartTime(picked));
    }
  }
}
