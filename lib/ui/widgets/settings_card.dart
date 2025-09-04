import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emily_marathon_split_calculator/bloc/bloc.dart';
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
                          color: Theme.of(context).colorScheme.onErrorContainer,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputLabel(
          text: "Pace (per ${settings.useMetricUnits ? 'km' : 'mi'})",
          required: true,
        ),
        const InputSpacing(),
        Container(
          padding: EdgeInsets.all(appTheme(context).cardPadding),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(appTheme(context).borderRadius),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _PaceField(
                  label: 'Minutes',
                  value: settings.paceMinutes,
                  min: 3,
                  max: 20,
                  onChanged: (value) {
                    context.read<RaceSettingsBloc>().add(SetPaceMinutes(value));
                  },
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                ':',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _PaceField(
                  label: 'Seconds',
                  value: settings.paceSeconds,
                  min: 0,
                  max: 59,
                  step: 5,
                  onChanged: (value) {
                    context.read<RaceSettingsBloc>().add(SetPaceSeconds(value));
                  },
                ),
              ),
            ],
          ),
        ),
      ],
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

class _PaceField extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final int step;
  final ValueChanged<int> onChanged;

  const _PaceField({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    this.step = 1,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: value > min ? () => onChanged(value - step) : null,
              icon: const Icon(Icons.remove),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.surface,
                foregroundColor: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 60,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value.toString().padLeft(2, '0'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: value < max ? () => onChanged(value + step) : null,
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.surface,
                foregroundColor: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
