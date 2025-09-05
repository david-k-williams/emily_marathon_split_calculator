import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emily_marathon_split_calculator/bloc/blocs.dart';
import 'package:emily_marathon_split_calculator/ui/widgets/race_map.dart';
import 'package:emily_marathon_split_calculator/ui/widgets/consistent_inputs.dart';
import 'package:emily_marathon_split_calculator/ui/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class RaceSpecificPage extends StatefulWidget {
  const RaceSpecificPage({super.key});

  @override
  State<RaceSpecificPage> createState() => _RaceSpecificPageState();
}

class _RaceSpecificPageState extends State<RaceSpecificPage> {
  @override
  void initState() {
    super.initState();
    // Load available races when the page initializes
    context.read<RaceSpecificBloc>().add(LoadAvailableRaces());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RaceSpecificBloc, RaceSpecificState>(
      listener: (context, state) {
        if (state is RaceSpecificError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(appTheme(context).cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(appTheme(context).sectionSpacing),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1),
                      Theme.of(context)
                          .colorScheme
                          .secondary
                          .withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.route_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Race-Specific Calculator",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  letterSpacing: -0.5,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Calculate splits for specific race routes with elevation data",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Race Selection
              Card(
                child: Padding(
                  padding: EdgeInsets.all(appTheme(context).cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const InputLabel(
                        text: "Select Race Route",
                        required: true,
                      ),
                      const SizedBox(height: 8),
                      if (state is RaceSpecificLoaded &&
                          state.availableRaces.isNotEmpty)
                        StandardDropdown<Map<String, String>>(
                          items: state.availableRaces
                              .map((race) =>
                                  DropdownMenuItem<Map<String, String>>(
                                    value: race,
                                    child: Text(race['displayName']!),
                                  ))
                              .toList(),
                          value: state.selectedRaceFileName != null
                              ? state.availableRaces.firstWhere(
                                  (race) =>
                                      race['fileName'] ==
                                      state.selectedRaceFileName,
                                  orElse: () => state.availableRaces.first,
                                )
                              : state.availableRaces.first,
                          onChanged: (value) {
                            if (value != null) {
                              context
                                  .read<RaceSpecificBloc>()
                                  .add(SelectRace(value['fileName']!));
                            }
                          },
                        )
                      else if (state is RaceSpecificLoading)
                        const Center(child: CircularProgressIndicator())
                      else
                        Text(
                          'No race routes available',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                    ],
                  ),
                ),
              ),

              // Route Information
              if (state is RaceSpecificLoaded && state.selectedRoute != null)
                _buildRouteInfo(context, state),

              // Pace and Start Time Inputs
              if (state is RaceSpecificLoaded && state.selectedRoute != null)
                _buildPaceAndStartTimeInputs(context, state),

              // Map and Elevation
              if (state is RaceSpecificLoaded && state.selectedRoute != null)
                _buildMapAndElevation(context, state),

              // Calculate Button
              if (state is RaceSpecificLoaded &&
                  state.selectedRoute != null &&
                  state.paceMinutes + state.paceSeconds > 0)
                _buildCalculateButton(context, state),

              // Results
              if (state is RaceSpecificLoaded && state.calculatedSplits != null)
                _buildResults(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRouteInfo(BuildContext context, RaceSpecificLoaded state) {
    final route = state.selectedRoute!;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(appTheme(context).cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Route Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    context,
                    'Distance',
                    '${(route.totalDistance / 1000).toStringAsFixed(1)} km',
                    Icons.straighten_rounded,
                  ),
                ),
                if (route.elevationGain != null)
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      'Elevation Gain',
                      '${route.elevationGain!.toStringAsFixed(0)} m',
                      Icons.terrain_rounded,
                    ),
                  ),
              ],
            ),
            if (route.minElevation != null && route.maxElevation != null)
              const SizedBox(height: 8),
            if (route.minElevation != null && route.maxElevation != null)
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      'Min Elevation',
                      '${route.minElevation!.toStringAsFixed(0)} m',
                      Icons.keyboard_arrow_down_rounded,
                    ),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      'Max Elevation',
                      '${route.maxElevation!.toStringAsFixed(0)} m',
                      Icons.keyboard_arrow_up_rounded,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
      BuildContext context, String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  Widget _buildPaceAndStartTimeInputs(
      BuildContext context, RaceSpecificLoaded state) {
    return Column(
      children: [
        // Pace Per Mile Input
        Card(
          child: Padding(
            padding: EdgeInsets.all(appTheme(context).cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pace Per Mile',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 12),
                InteractiveTimeInput(
                  initialTime: Duration(
                    minutes: state.paceMinutes,
                    seconds: state.paceSeconds,
                  ),
                  onTimeChanged: (duration) {
                    context.read<RaceSpecificBloc>().add(SetPacePerMile(
                          minutes: duration.inMinutes,
                          seconds: duration.inSeconds % 60,
                        ));
                  },
                  showHours: false,
                  showSeconds: true,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Start Time Picker
        Card(
          child: Padding(
            padding: EdgeInsets.all(appTheme(context).cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Start Time',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () => _selectStartTime(context, state),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withValues(alpha: 0.3),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatStartTime(
                              state.startHours, state.startMinutes),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Icon(
                          Icons.access_time,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Elevation Adjustment Toggle
        Card(
          child: Padding(
            padding: EdgeInsets.all(appTheme(context).cardPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account for Elevation',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      'Adjust pace based on elevation changes',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
                Switch(
                  value: state.useElevationAdjustment,
                  onChanged: (value) {
                    context
                        .read<RaceSpecificBloc>()
                        .add(ToggleElevationAdjustment());
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapAndElevation(BuildContext context, RaceSpecificLoaded state) {
    final route = state.selectedRoute!;
    final mileMarkers = route.getMileMarkers();

    return Column(
      children: [
        // Map
        Card(
          child: Padding(
            padding: EdgeInsets.all(appTheme(context).cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Route Map',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        context
                            .read<RaceSpecificBloc>()
                            .add(ToggleElevationDisplay());
                      },
                      icon: Icon(
                        state.showElevation
                            ? Icons.terrain_rounded
                            : Icons.terrain_outlined,
                        size: 16,
                      ),
                      label: Text(state.showElevation
                          ? 'Hide Elevation'
                          : 'Show Elevation'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                RaceMap(
                  route: route,
                  mileMarkers: mileMarkers,
                  showElevation: state.showElevation,
                  onMarkerTap: (point) {
                    // Handle marker tap if needed
                  },
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Elevation Profile
        if (state.showElevation && route.minElevation != null)
          Card(
            child: Padding(
              padding: EdgeInsets.all(appTheme(context).cardPadding),
              child: ElevationProfile(
                route: route,
                mileMarkers: mileMarkers,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCalculateButton(BuildContext context, RaceSpecificLoaded state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: StandardButton(
          onPressed: () {
            context.read<RaceSpecificBloc>().add(CalculateRaceSplits());
          },
          text: 'Calculate Race Splits',
        ),
      ),
    );
  }

  Widget _buildResults(BuildContext context, RaceSpecificLoaded state) {
    final splits = state.calculatedSplits!;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(appTheme(context).cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Race Splits',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: splits.length,
              separatorBuilder: (context, index) => SizedBox(
                height: appTheme(context).listItemSpacing,
              ),
              itemBuilder: (context, index) {
                final split = splits[index];
                final isBold = index == 0 || index == splits.length - 1;
                return Container(
                  padding: EdgeInsets.all(appTheme(context).cardPadding),
                  decoration: BoxDecoration(
                    color: isBold
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius:
                        BorderRadius.circular(appTheme(context).borderRadius),
                    border: isBold
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
                          color: isBold
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          isBold
                              ? Icons.flag_rounded
                              : Icons.directions_run_rounded,
                          color: isBold
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                      ),
                      SizedBox(width: appTheme(context).cardSpacing),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              split.markerName,
                              style: TextStyle(
                                fontWeight:
                                    isBold ? FontWeight.w700 : FontWeight.w500,
                                fontSize: isBold ? 16 : 15,
                                color: isBold
                                    ? Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              split.distanceDisplay,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                            if (split.elevation != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                '${split.elevation!.toStringAsFixed(0)}m elevation',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            split.formattedTime,
                            style: TextStyle(
                              fontWeight:
                                  isBold ? FontWeight.w700 : FontWeight.w600,
                              fontSize: isBold ? 16 : 15,
                              color: isBold
                                  ? Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Arrive: ${split.formattedArrivalTime}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () =>
                            _openInMaps(split.latitude, split.longitude),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.map_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatStartTime(int hours, int minutes) {
    final period = hours >= 12 ? 'PM' : 'AM';
    final displayHours = hours == 0 ? 12 : (hours > 12 ? hours - 12 : hours);
    return '${displayHours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} $period';
  }

  Future<void> _selectStartTime(
      BuildContext context, RaceSpecificLoaded state) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: state.startHours, minute: state.startMinutes),
    );
    if (picked != null && context.mounted) {
      context.read<RaceSpecificBloc>().add(SetRaceStartTime(
            hours: picked.hour,
            minutes: picked.minute,
          ));
    }
  }

  Future<void> _openInMaps(double latitude, double longitude) async {
    final url = 'https://www.google.com/maps?q=$latitude,$longitude';
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Fallback to Apple Maps on iOS or show error
      final appleMapsUrl = 'https://maps.apple.com/?q=$latitude,$longitude';
      final appleUri = Uri.parse(appleMapsUrl);
      if (await canLaunchUrl(appleUri)) {
        await launchUrl(appleUri, mode: LaunchMode.externalApplication);
      }
    }
  }
}
