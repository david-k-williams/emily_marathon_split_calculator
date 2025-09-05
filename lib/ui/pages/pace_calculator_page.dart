import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emily_marathon_split_calculator/bloc/blocs.dart';
import 'package:emily_marathon_split_calculator/ui/theme/theme.dart';
import 'package:emily_marathon_split_calculator/ui/widgets/consistent_inputs.dart';

class PaceCalculatorPage extends StatelessWidget {
  const PaceCalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaceCalculatorBloc(),
      child: const _PaceCalculatorView(),
    );
  }
}

class _PaceCalculatorView extends StatelessWidget {
  const _PaceCalculatorView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaceCalculatorBloc, PaceCalculatorState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(appTheme(context).cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  borderRadius: BorderRadius.circular(
                      appTheme(context).largeBorderRadius),
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
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.speed_rounded,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pace Calculator",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Calculate your pace per ${state.useMetricUnits ? 'km' : 'mi'}",
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
                useMetricUnits: state.useMetricUnits,
                onChanged: (value) {
                  context
                      .read<PaceCalculatorBloc>()
                      .add(SetPaceCalculatorUnits(value));
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
                        "Enter your time and distance to calculate pace per ${state.useMetricUnits ? 'km' : 'mi'}",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                      SizedBox(height: appTheme(context).cardSpacing),

                      // Distance Selector
                      StandardDropdown<String>(
                        labelText: "Distance",
                        value: state.selectedDistance > 0
                            ? _getRaceName(
                                state.selectedDistance, state.useMetricUnits)
                            : null,
                        items: _getRaceOptions(state.useMetricUnits)
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            final distance = _getDistanceFromName(
                                value, state.useMetricUnits);
                            context
                                .read<PaceCalculatorBloc>()
                                .add(SetPaceCalculatorDistance(distance));
                          }
                        },
                      ),
                      SizedBox(height: appTheme(context).cardSpacing),

                      // Time Input
                      InteractiveTimeInput(
                        initialTime: Duration(
                            hours: state.hours, minutes: state.minutes),
                        onTimeChanged: (time) {
                          context
                              .read<PaceCalculatorBloc>()
                              .add(SetPaceCalculatorHours(time.inHours));
                          context.read<PaceCalculatorBloc>().add(
                              SetPaceCalculatorMinutes(time.inMinutes % 60));
                        },
                        label: "Time",
                        showSeconds: false,
                      ),
                      SizedBox(height: appTheme(context).cardSpacing),

                      // Calculate Button
                      StandardButton(
                        text: 'Calculate Pace',
                        icon: Icons.calculate_rounded,
                        onPressed: () {
                          context
                              .read<PaceCalculatorBloc>()
                              .add(CalculatePaceCalculator());
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: appTheme(context).sectionSpacing),

              // Results Card
              if (state.calculatedPace != null) ...[
                Card(
                  elevation: 4,
                  shadowColor: Theme.of(context)
                      .colorScheme
                      .shadow
                      .withValues(alpha: 0.1),
                  child: Padding(
                    padding: EdgeInsets.all(appTheme(context).cardPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.timer_rounded,
                              color: Theme.of(context).colorScheme.primary,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Calculated Pace',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: appTheme(context).cardSpacing),
                        Container(
                          width: double.infinity,
                          padding:
                              EdgeInsets.all(appTheme(context).cardPadding),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(
                                appTheme(context).borderRadius),
                          ),
                          child: Column(
                            children: [
                              Text(
                                _formatPace(state.calculatedPace!),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'per ${state.useMetricUnits ? 'km' : 'mi'}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
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

              // Error Message
              if (state.errorMessage != null) ...[
                SizedBox(height: appTheme(context).cardSpacing),
                Container(
                  padding: EdgeInsets.all(appTheme(context).cardPadding),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius:
                        BorderRadius.circular(appTheme(context).borderRadius),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          state.errorMessage!,
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  String _getRaceName(double distance, bool useMetricUnits) {
    // This is a simplified mapping - in a real app you'd want to load from the service
    if (useMetricUnits) {
      if (distance == 1.0) return '1 Mile';
      if (distance == 5.0) return '5K';
      if (distance == 10.0) return '10K';
      if (distance == 21.097) return 'Half Marathon';
      if (distance == 42.195) return 'Marathon';
      if (distance == 50.0) return '50K';
    } else {
      if (distance == 1.0) return '1 Mile';
      if (distance == 3.1) return '5K';
      if (distance == 6.2) return '10K';
      if (distance == 13.1) return 'Half Marathon';
      if (distance == 26.2) return 'Marathon';
      if (distance == 31.1) return '50K';
    }
    return 'Custom';
  }

  double _getDistanceFromName(String name, bool useMetricUnits) {
    // This is a simplified mapping - in a real app you'd want to load from the service
    switch (name) {
      case '1 Mile':
        return 1.0;
      case '5K':
        return useMetricUnits ? 5.0 : 3.1;
      case '10K':
        return useMetricUnits ? 10.0 : 6.2;
      case 'Half Marathon':
        return useMetricUnits ? 21.097 : 13.1;
      case 'Marathon':
        return useMetricUnits ? 42.195 : 26.2;
      case '50K':
        return useMetricUnits ? 50.0 : 31.1;
      default:
        return 0.0;
    }
  }

  List<String> _getRaceOptions(bool useMetricUnits) {
    return [
      '1 Mile',
      '5K',
      '10K',
      'Half Marathon',
      'Marathon',
      '50K',
    ];
  }

  String _formatPace(Duration pace) {
    final minutes = pace.inMinutes;
    final seconds = pace.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
