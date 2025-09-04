import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emily_marathon_split_calculator/bloc/bloc.dart';
import 'package:emily_marathon_split_calculator/ui/widgets/consistent_inputs.dart';
import 'package:emily_marathon_split_calculator/ui/theme/theme.dart';

class ConsistentStartTimePicker extends StatelessWidget {
  final TimeOfDay startTime;
  final String label;
  final bool showLabel;

  const ConsistentStartTimePicker({
    super.key,
    required this.startTime,
    this.label = "Start Time",
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[
          InputLabel(text: label),
          const InputSpacing(),
        ],
        GestureDetector(
          onTap: () => _selectTime(context),
          child: Container(
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
                Icon(
                  Icons.access_time_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    startTime.format(context),
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
      initialTime: startTime,
    );
    if (picked != null && context.mounted) {
      context.read<RaceSettingsBloc>().add(SetStartTime(picked));
    }
  }
}
