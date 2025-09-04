import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emily_marathon_split_calculator/bloc/bloc.dart';
import 'package:emily_marathon_split_calculator/services/race_service.dart';
import 'package:emily_marathon_split_calculator/models/race.dart';
import 'package:emily_marathon_split_calculator/ui/theme/theme.dart';

class RaceDistanceSelector extends StatelessWidget {
  final String? selectedRace;
  final String label;
  final bool showLabel;

  const RaceDistanceSelector({
    super.key,
    this.selectedRace,
    this.label = "Race Distance",
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
        FutureBuilder<List<Race>>(
          future: RaceService.getRaces(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: 56,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius:
                      BorderRadius.circular(appTheme(context).borderRadius),
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
                  borderRadius:
                      BorderRadius.circular(appTheme(context).borderRadius),
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
            return DropdownButtonFormField<String>(
              initialValue: selectedRace,
              decoration: InputDecoration(
                hintText: 'Select a race distance',
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
            );
          },
        ),
      ],
    );
  }
}
