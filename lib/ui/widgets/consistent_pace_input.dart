import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emily_marathon_split_calculator/bloc/bloc.dart';
import 'package:emily_marathon_split_calculator/ui/widgets/consistent_inputs.dart';
import 'package:emily_marathon_split_calculator/ui/theme/theme.dart';

class ConsistentPaceInput extends StatelessWidget {
  final int paceMinutes;
  final int paceSeconds;
  final bool useMetricUnits;
  final String label;
  final bool showLabel;

  const ConsistentPaceInput({
    super.key,
    required this.paceMinutes,
    required this.paceSeconds,
    required this.useMetricUnits,
    this.label = "Pace",
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[
          InputLabel(
            text: "$label (per ${useMetricUnits ? 'km' : 'mi'})",
            required: true,
          ),
          const InputSpacing(),
        ],
        Container(
          padding: EdgeInsets.all(appTheme(context).cardPadding),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(appTheme(context).borderRadius),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _PaceField(
                  label: 'Minutes',
                  value: paceMinutes,
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
                  value: paceSeconds,
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
