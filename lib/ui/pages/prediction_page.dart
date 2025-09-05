import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emily_marathon_split_calculator/bloc/blocs.dart';
import 'package:emily_marathon_split_calculator/services/prediction_service.dart';
import 'package:emily_marathon_split_calculator/ui/theme/theme.dart';
import 'package:emily_marathon_split_calculator/ui/widgets/consistent_inputs.dart';

class PredictionPage extends StatefulWidget {
  const PredictionPage({super.key});

  @override
  State<PredictionPage> createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  @override
  void initState() {
    super.initState();
    // Calculate initial predictions
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PredictionBloc>().add(CalculatePredictions());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PredictionBloc, PredictionState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
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
                        Icon(
                          Icons.trending_up_rounded,
                          size: 32,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        SizedBox(width: appTheme(context).cardSpacing),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Race Predictions',
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
                                'Predict your times across all distances',
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

              // Input Section
              Card(
                child: Padding(
                  padding: EdgeInsets.all(appTheme(context).cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Input Race Time',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      SizedBox(height: appTheme(context).cardSpacing),

                      // Distance Selector
                      _buildDistanceSelector(context, state),
                      SizedBox(height: appTheme(context).cardSpacing),

                      // Time Input
                      InteractiveTimeInput(
                        initialTime: state.inputTime,
                        onTimeChanged: (time) {
                          context
                              .read<PredictionBloc>()
                              .add(SetInputTime(time));
                        },
                        label: "Time",
                        showSeconds: false,
                      ),
                      SizedBox(height: appTheme(context).cardSpacing),

                      // Formula Selector
                      _buildFormulaSelector(context, state),
                      SizedBox(height: appTheme(context).cardSpacing),

                      // Formula Explanation
                      _buildFormulaExplanation(context, state),
                      SizedBox(height: appTheme(context).cardSpacing),

                      // Calculate Button
                      StandardButton(
                        text: 'Calculate Predictions',
                        icon: Icons.calculate_rounded,
                        onPressed: () {
                          context
                              .read<PredictionBloc>()
                              .add(CalculatePredictions());
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: appTheme(context).sectionSpacing),

              // Results Section
              if (state.predictions.isNotEmpty) ...[
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(appTheme(context).cardPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.analytics_rounded,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            SizedBox(width: appTheme(context).cardSpacing / 2),
                            Text(
                              'Predicted Times',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: appTheme(context).cardSpacing),

                        // Predictions List
                        ...state.predictions.entries.map((entry) {
                          final distance = entry.key;
                          final result = entry.value;
                          final isInput = distance == state.inputDistance;

                          return Container(
                            margin: EdgeInsets.only(
                                bottom: appTheme(context).listItemSpacing),
                            padding: EdgeInsets.all(
                                appTheme(context).listItemPadding),
                            decoration: BoxDecoration(
                              color: isInput
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : Theme.of(context)
                                      .colorScheme
                                      .surfaceContainer,
                              borderRadius: BorderRadius.circular(
                                  appTheme(context).borderRadius),
                              border: isInput
                                  ? Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withValues(alpha: 0.3),
                                    )
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        distance,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: isInput
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryContainer
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .onSurface,
                                            ),
                                      ),
                                      if (isInput)
                                        Text(
                                          'Input time',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer
                                                    .withValues(alpha: 0.7),
                                              ),
                                        ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      PredictionService.formatTime(
                                          result.predictedTime),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: isInput
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                          ),
                                    ),
                                    if (!isInput) ...[
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            _getConfidenceIcon(
                                                result.confidence),
                                            size: 12,
                                            color: _getConfidenceColor(
                                                context, result.confidence),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            _getConfidenceText(
                                                result.confidence),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: _getConfidenceColor(
                                                      context,
                                                      result.confidence),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
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
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                      SizedBox(width: appTheme(context).cardSpacing / 2),
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

  String _getFormulaDisplayName(PredictionFormula formula) {
    switch (formula) {
      case PredictionFormula.riegel:
        return 'Riegel Formula';
      case PredictionFormula.cameron:
        return 'Cameron Formula';
      case PredictionFormula.daniels:
        return 'Daniels Formula';
      case PredictionFormula.hanson:
        return 'Hanson Formula';
    }
  }

  IconData _getConfidenceIcon(double confidence) {
    if (confidence >= 0.8) return Icons.check_circle;
    if (confidence >= 0.6) return Icons.warning;
    return Icons.info;
  }

  Color _getConfidenceColor(BuildContext context, double confidence) {
    if (confidence >= 0.8) return Colors.green;
    if (confidence >= 0.6) return Colors.orange;
    return Colors.blue;
  }

  String _getConfidenceText(double confidence) {
    if (confidence >= 0.8) return 'High confidence';
    if (confidence >= 0.6) return 'Medium confidence';
    return 'Low confidence';
  }

  Widget _buildDistanceSelector(BuildContext context, PredictionState state) {
    final availableDistances = PredictionService.getAvailableDistances();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const InputLabel(text: "Distance", required: true),
        const InputSpacing(),
        StandardDropdown<String>(
          value: state.inputDistance,
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
        ),
      ],
    );
  }

  Widget _buildFormulaSelector(BuildContext context, PredictionState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const InputLabel(text: "Prediction Formula", required: true),
        const InputSpacing(),
        StandardDropdown<PredictionFormula>(
          value: state.selectedFormula,
          hintText: 'Select a prediction formula',
          items: PredictionFormula.values
              .map((formula) => DropdownMenuItem(
                    value: formula,
                    child: Text(_getFormulaDisplayName(formula)),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              context.read<PredictionBloc>().add(SetPredictionFormula(value));
            }
          },
        ),
      ],
    );
  }

  Widget _buildFormulaExplanation(BuildContext context, PredictionState state) {
    return Container(
      padding: EdgeInsets.all(appTheme(context).cardPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(appTheme(context).borderRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(width: appTheme(context).cardSpacing / 2),
              Text(
                'Formula Explanation',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
          SizedBox(height: appTheme(context).cardSpacing / 2),
          Text(
            _getFormulaDescription(state.selectedFormula),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  String _getFormulaDescription(PredictionFormula formula) {
    switch (formula) {
      case PredictionFormula.riegel:
        return 'Riegel Formula: T2 = T1 × (D2/D1)^1.06\nMost popular and widely used. Good for distances 5K-50K. Based on the power law relationship between distance and time.';
      case PredictionFormula.cameron:
        return 'Cameron Formula: T2 = T1 × (D2/D1)^1.07\nMore conservative than Riegel. Better for longer distances and provides slightly slower predictions.';
      case PredictionFormula.daniels:
        return 'Daniels Formula: T2 = T1 × (D2/D1)^1.06 × (1 + 0.08 × (D2-D1)/D1)\nDeveloped by Jack Daniels. Includes a correction factor for distance differences. More accurate for larger distance jumps.';
      case PredictionFormula.hanson:
        return 'Hanson Formula: T2 = T1 × (D2/D1)^1.05\nMost conservative formula. Provides the slowest predictions, good for beginners or when you want to be conservative with your goals.';
    }
  }
}
