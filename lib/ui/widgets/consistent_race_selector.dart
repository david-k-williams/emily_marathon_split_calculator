import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emily_marathon_split_calculator/bloc/bloc.dart';
import 'package:emily_marathon_split_calculator/bloc/prediction_bloc.dart';
import 'package:emily_marathon_split_calculator/services/race_service.dart';
import 'package:emily_marathon_split_calculator/services/prediction_service.dart';
import 'package:emily_marathon_split_calculator/models/race.dart';
import 'package:emily_marathon_split_calculator/ui/widgets/consistent_inputs.dart';

enum RaceSelectorType {
  splitCalculator,
  paceCalculator,
  predictionCalculator,
}

class ConsistentRaceSelector extends StatelessWidget {
  final String? selectedRace;
  final String label;
  final bool showLabel;
  final RaceSelectorType type;

  const ConsistentRaceSelector({
    super.key,
    this.selectedRace,
    this.label = "Race Distance",
    this.showLabel = true,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[
          InputLabel(text: label, required: true),
          const InputSpacing(),
        ],
        _buildSelector(context),
      ],
    );
  }

  Widget _buildSelector(BuildContext context) {
    switch (type) {
      case RaceSelectorType.splitCalculator:
        return _buildSplitCalculatorSelector(context);
      case RaceSelectorType.paceCalculator:
        return _buildPaceCalculatorSelector(context);
      case RaceSelectorType.predictionCalculator:
        return _buildPredictionCalculatorSelector(context);
    }
  }

  Widget _buildSplitCalculatorSelector(BuildContext context) {
    return FutureBuilder<List<Race>>(
      future: RaceService.getRaces(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState(context);
        }

        if (snapshot.hasError) {
          return _buildErrorState(context, snapshot.error.toString());
        }

        final races = snapshot.data ?? [];
        return StandardDropdown<String>(
          value: selectedRace,
          hintText: 'Select a race distance',
          items: races.map((Race race) {
            return DropdownMenuItem<String>(
              value: race.name,
              child: Text(race.name),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              context.read<RaceSettingsBloc>().add(SetRaceDistance(newValue));
            }
          },
        );
      },
    );
  }

  Widget _buildPaceCalculatorSelector(BuildContext context) {
    return FutureBuilder<List<Race>>(
      future: RaceService.getRaces(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState(context);
        }

        if (snapshot.hasError) {
          return _buildErrorState(context, snapshot.error.toString());
        }

        final races = snapshot.data ?? [];
        return StandardDropdown<String>(
          value: selectedRace,
          hintText: 'Select a race distance',
          items: races.map((Race race) {
            return DropdownMenuItem<String>(
              value: race.name,
              child: Text(race.name),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              // Find the race and get its distance
              final race = races.firstWhere((r) => r.name == newValue);
              final distance =
                  race.getDistance(true); // Use metric units for now
              context
                  .read<RaceSettingsBloc>()
                  .add(SetCalculatorDistance(distance));
            }
          },
        );
      },
    );
  }

  Widget _buildPredictionCalculatorSelector(BuildContext context) {
    final availableDistances = PredictionService.getAvailableDistances();
    return StandardDropdown<String>(
      value: selectedRace,
      hintText: 'Select a race distance',
      items: availableDistances.map((String distance) {
        return DropdownMenuItem<String>(
          value: distance,
          child: Text(distance),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          context.read<PredictionBloc>().add(SetInputDistance(newValue));
        }
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
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

  Widget _buildErrorState(BuildContext context, String error) {
    return Container(
      height: 56,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Error loading races: $error',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onErrorContainer,
        ),
      ),
    );
  }
}
