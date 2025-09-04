import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emily_marathon_split_calculator/bloc/bloc.dart';
import 'package:emily_marathon_split_calculator/ui/theme/theme.dart';

class StartTimePicker extends StatelessWidget {
  final TimeOfDay startTime;
  final String label;
  final bool showLabel;

  const StartTimePicker({
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
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: appTheme(context).cardSpacing / 2),
        ],
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: startTime,
              );
              if (picked != null && context.mounted) {
                context.read<RaceSettingsBloc>().add(SetStartTime(picked));
              }
            },
            icon: const Icon(Icons.access_time_rounded),
            label: Text('Start Time: ${startTime.format(context)}'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                  horizontal: appTheme(context).cardPadding,
                  vertical: appTheme(context).cardPadding),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(appTheme(context).borderRadius),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
