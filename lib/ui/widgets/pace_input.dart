import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emily_marathon_split_calculator/bloc/bloc.dart';
import 'package:emily_marathon_split_calculator/ui/theme/theme.dart';

class PaceInput extends StatelessWidget {
  final int paceMinutes;
  final int paceSeconds;
  final bool useMetricUnits;
  final String label;
  final bool showLabel;

  const PaceInput({
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
          Text(
            "$label (per ${useMetricUnits ? 'km' : 'mi'})",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: appTheme(context).cardSpacing / 2),
        ],
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<int>(
                initialValue: paceMinutes,
                decoration: InputDecoration(
                  labelText: 'Minutes',
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(appTheme(context).borderRadius),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(appTheme(context).borderRadius),
                    borderSide: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(appTheme(context).borderRadius),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: appTheme(context).cardPadding,
                      vertical: appTheme(context).cardPadding),
                ),
                items: [
                  for (int i = 3; i <= 20; i++)
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
            ),
            SizedBox(width: appTheme(context).cardSpacing),
            const Text(
              ":",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: appTheme(context).cardSpacing),
            Expanded(
              child: DropdownButtonFormField<int>(
                initialValue: paceSeconds,
                decoration: InputDecoration(
                  labelText: 'Seconds',
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(appTheme(context).borderRadius),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(appTheme(context).borderRadius),
                    borderSide: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(appTheme(context).borderRadius),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: appTheme(context).cardPadding,
                      vertical: appTheme(context).cardPadding),
                ),
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
            ),
          ],
        ),
      ],
    );
  }
}
