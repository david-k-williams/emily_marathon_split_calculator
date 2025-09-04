import 'package:flutter/material.dart';
import 'package:emily_marathon_split_calculator/services/race_service.dart';
import 'package:emily_marathon_split_calculator/models/race.dart';
import 'package:emily_marathon_split_calculator/ui/theme/theme.dart';
import 'package:emily_marathon_split_calculator/ui/widgets/consistent_inputs.dart';

class PaceCalculatorPage extends StatefulWidget {
  const PaceCalculatorPage({super.key});

  @override
  State<PaceCalculatorPage> createState() => _PaceCalculatorPageState();
}

class _PaceCalculatorPageState extends State<PaceCalculatorPage> {
  String? selectedRace;
  int hours = 0;
  int minutes = 0;
  bool useMetricUnits = true;
  double? calculatedPaceMinutes;
  double? calculatedPaceSeconds;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header with gradient
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(appTheme(context).sectionSpacing),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.secondaryContainer,
                ],
              ),
              borderRadius:
                  BorderRadius.circular(appTheme(context).largeBorderRadius),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calculate_rounded,
                      size: 32,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(width: appTheme(context).cardSpacing),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pace Calculator',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                          ),
                          Text(
                            'Calculate your pace from time and distance',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer
                                      .withValues(alpha: 0.8),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: appTheme(context).sectionSpacing),

          // Units Toggle
          UnitsToggle(
            useMetricUnits: useMetricUnits,
            onChanged: (value) {
              setState(() {
                useMetricUnits = value;
                _calculatePace();
              });
            },
          ),
          SizedBox(height: appTheme(context).sectionSpacing),

          // Input Card
          Card(
            child: Padding(
              padding: EdgeInsets.all(appTheme(context).cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Calculate Pace',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: appTheme(context).cardSpacing),
                  Text(
                    "Enter your time and distance to calculate pace per ${useMetricUnits ? 'km' : 'mi'}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: appTheme(context).cardSpacing),

                  // Distance Selector
                  _buildDistanceSelector(),
                  SizedBox(height: appTheme(context).cardSpacing),

                  // Time Input
                  InteractiveTimeInput(
                    initialTime: Duration(hours: hours, minutes: minutes),
                    onTimeChanged: (time) {
                      setState(() {
                        hours = time.inHours;
                        minutes = time.inMinutes % 60;
                        _calculatePace();
                      });
                    },
                    label: "Time",
                    showSeconds: false,
                  ),
                  SizedBox(height: appTheme(context).cardSpacing),

                  // Calculate Button
                  StandardButton(
                    text: 'Calculate Pace',
                    icon: Icons.calculate_rounded,
                    onPressed:
                        selectedRace != null && (hours > 0 || minutes > 0)
                            ? _calculatePace
                            : null,
                  ),

                  // Info message if no distance selected
                  if (selectedRace == null) ...[
                    SizedBox(height: appTheme(context).cardSpacing),
                    Container(
                      padding: EdgeInsets.all(appTheme(context).cardPadding),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(
                            appTheme(context).borderRadius),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          SizedBox(width: appTheme(context).cardSpacing / 2),
                          Expanded(
                            child: Text(
                              'Please select a race distance to calculate pace',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Results
          if (calculatedPaceMinutes != null &&
              calculatedPaceSeconds != null) ...[
            SizedBox(height: appTheme(context).sectionSpacing),
            Card(
              child: Padding(
                padding: EdgeInsets.all(appTheme(context).cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.speed_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        SizedBox(width: appTheme(context).cardSpacing / 2),
                        Text(
                          'Calculated Pace',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                    SizedBox(height: appTheme(context).cardSpacing),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(appTheme(context).cardPadding),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).colorScheme.primaryContainer,
                            Theme.of(context).colorScheme.secondaryContainer,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(
                            appTheme(context).borderRadius),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${calculatedPaceMinutes!.toInt()}:${calculatedPaceSeconds!.toInt().toString().padLeft(2, '0')}',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                          ),
                          Text(
                            'per ${useMetricUnits ? 'km' : 'mi'}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer
                                      .withValues(alpha: 0.8),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDistanceSelector() {
    return FutureBuilder<List<Race>>(
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputLabel(
                text: "Distance (${useMetricUnits ? 'km' : 'mi'})",
                required: true),
            const InputSpacing(),
            StandardDropdown<String>(
              value: selectedRace,
              hintText: 'Select a race distance',
              items: races.map((Race race) {
                return DropdownMenuItem<String>(
                  value: race.name,
                  child: Text(
                      '${race.name} (${race.getDistance(useMetricUnits).toStringAsFixed(1)} ${race.getDistanceLabel(useMetricUnits)})'),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedRace = newValue;
                  _calculatePace();
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _calculatePace() {
    if (selectedRace == null || (hours == 0 && minutes == 0)) {
      setState(() {
        calculatedPaceMinutes = null;
        calculatedPaceSeconds = null;
      });
      return;
    }

    // Get the race distance
    RaceService.getRaces().then((races) {
      final race = races.firstWhere((r) => r.name == selectedRace);
      final distance = race.getDistance(useMetricUnits);
      final totalMinutes = hours * 60 + minutes;

      if (totalMinutes > 0 && distance > 0) {
        final pacePerUnit = totalMinutes / distance;
        final paceMinutes = pacePerUnit.floor();
        final paceSeconds = ((pacePerUnit - paceMinutes) * 60).round();

        setState(() {
          calculatedPaceMinutes = paceMinutes.toDouble();
          calculatedPaceSeconds = paceSeconds.toDouble();
        });
      }
    });
  }
}
