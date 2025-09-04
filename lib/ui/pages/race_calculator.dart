import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emily_marathon_split_calculator/bloc/bloc.dart';
import 'package:emily_marathon_split_calculator/ui/widgets/settings_card.dart';
import 'package:emily_marathon_split_calculator/ui/widgets/consistent_inputs.dart';
import 'package:emily_marathon_split_calculator/ui/theme/theme.dart';

class RaceCalculatorPage extends StatelessWidget {
  const RaceCalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RaceSettingsBloc, RaceSettingsState>(
      builder: (context, settings) {
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
                            borderRadius: BorderRadius.circular(
                                appTheme(context).borderRadius),
                          ),
                          child: Icon(
                            Icons.timer_rounded,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Split Calculator",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                              ),
                              Text(
                                "Calculate your race splits and pacing strategy",
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

              // Units toggle - inline with header
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: appTheme(context).cardPadding,
                    vertical: appTheme(context).cardSpacing),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius:
                      BorderRadius.circular(appTheme(context).borderRadius),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.straighten_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Units",
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            settings.useMetricUnits ? 'km' : 'mi',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Switch(
                            value: settings.useMetricUnits,
                            onChanged: (value) {
                              context
                                  .read<RaceSettingsBloc>()
                                  .add(ToggleUnits());
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: appTheme(context).cardSpacing),

              // Settings card
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                firstChild: SettingsCard(settings: settings),
                secondChild: GestureDetector(
                  onTap: () {
                    context
                        .read<RaceSettingsBloc>()
                        .add(ToggleSettingsVisibility());
                  },
                  child: Card(
                    elevation: 4,
                    shadowColor: Theme.of(context)
                        .colorScheme
                        .shadow
                        .withValues(alpha: 0.1),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.settings_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Adjust Settings",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                crossFadeState: settings.settingsVisible
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
              ),
              SizedBox(height: appTheme(context).cardSpacing),

              // Calculate button - prominent below settings
              Center(
                child: StandardButton(
                  text: 'Calculate Splits',
                  icon: Icons.calculate_rounded,
                  onPressed: () {
                    context
                        .read<RaceSettingsBloc>()
                        .add(CalculateSplitsEvent());
                  },
                ),
              ),
              SizedBox(height: appTheme(context).cardSpacing),

              // Split times list
              if (settings.splitTimes.isNotEmpty) ...[
                Card(
                  elevation: 4,
                  shadowColor: Theme.of(context)
                      .colorScheme
                      .shadow
                      .withValues(alpha: 0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.list_alt_rounded,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Split Times",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: appTheme(context).cardSpacing),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: settings.splitTimes.length,
                          itemBuilder: (context, index) {
                            final mileData = settings.splitTimes[index];
                            return Container(
                              padding:
                                  EdgeInsets.all(appTheme(context).cardPadding),
                              decoration: BoxDecoration(
                                color: mileData['isBold']
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : Theme.of(context)
                                        .colorScheme
                                        .surfaceContainer,
                                borderRadius: BorderRadius.circular(
                                    appTheme(context).borderRadius),
                                border: mileData['isBold']
                                    ? Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withValues(alpha: 0.3),
                                        width: 1,
                                      )
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: mileData['isBold']
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .surfaceContainerHigh,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      mileData['isBold']
                                          ? Icons.flag_rounded
                                          : Icons.directions_run_rounded,
                                      color: mileData['isBold']
                                          ? Theme.of(context)
                                              .colorScheme
                                              .onPrimary
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                      size: 16,
                                    ),
                                  ),
                                  SizedBox(
                                      width: appTheme(context).cardSpacing),
                                  Expanded(
                                    child: Text(
                                      mileData['text'],
                                      style: TextStyle(
                                        fontWeight: mileData['isBold']
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        fontSize: mileData['isBold'] ? 16 : 15,
                                        color: mileData['isBold']
                                            ? Theme.of(context)
                                                .colorScheme
                                                .onPrimaryContainer
                                            : Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => SizedBox(
                              height: appTheme(context).listItemSpacing),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                // Empty state
                Card(
                  elevation: 4,
                  shadowColor: Theme.of(context)
                      .colorScheme
                      .shadow
                      .withValues(alpha: 0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.all(appTheme(context).cardPadding),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.timer_outlined,
                            size: 48,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: appTheme(context).cardSpacing),
                        Text(
                          "No splits calculated yet",
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                        SizedBox(height: appTheme(context).listItemSpacing),
                        Text(
                          "Configure your race settings above to calculate your splits",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant
                                        .withValues(alpha: 0.8),
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
