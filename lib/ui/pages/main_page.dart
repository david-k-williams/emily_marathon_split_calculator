import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emily_marathon_split_calculator/bloc/blocs.dart';
import 'package:emily_marathon_split_calculator/ui/pages/race_calculator.dart';
import 'package:emily_marathon_split_calculator/ui/pages/pace_calculator_page.dart';
import 'package:emily_marathon_split_calculator/ui/pages/prediction_page.dart';
import 'package:emily_marathon_split_calculator/ui/pages/race_specific_page.dart';
import 'package:emily_marathon_split_calculator/utils/export_utils.dart';
import 'package:emily_marathon_split_calculator/ui/theme/theme.dart';
import 'package:emily_marathon_split_calculator/ui/widgets/persistent_footer.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppBloc()),
        BlocProvider(create: (context) => RaceSettingsBloc()),
        BlocProvider(create: (context) => PredictionBloc()),
        BlocProvider(create: (context) => PaceCalculatorBloc()),
        BlocProvider(create: (context) => RaceSpecificBloc()),
      ],
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, appState) {
          return BlocBuilder<RaceSettingsBloc, RaceSettingsState>(
            builder: (context, raceState) {
              return Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.surface,
                        Theme.of(context).colorScheme.surfaceContainerLow,
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      // Custom AppBar with gradient
                      Container(
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
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .colorScheme
                                  .shadow
                                  .withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: SafeArea(
                          child: Padding(
                            padding: EdgeInsets.all(
                                appTheme(context).sectionSpacing),
                            child: Column(
                              children: [
                                // App title with export button
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Emily's Race Calculator",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w800,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              letterSpacing: -0.5,
                                            ),
                                      ),
                                    ),
                                    if (raceState.splitTimes.isNotEmpty &&
                                        appState.selectedTabIndex == 0)
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: IconButton(
                                          onPressed: () async {
                                            await ExportUtils.exportSplits(
                                                raceState);
                                          },
                                          icon: Icon(
                                            Icons.share_rounded,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimaryContainer,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: appTheme(context).cardSpacing),

                                // Responsive Tab Selector
                                _buildResponsiveTabSelector(context, appState),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // TabBarView with enhanced styling
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .colorScheme
                                    .shadow
                                    .withValues(alpha: 0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: PageView(
                              controller: _pageController,
                              onPageChanged: (index) {
                                // Only update state, don't trigger animations
                                if (context
                                        .read<AppBloc>()
                                        .state
                                        .selectedTabIndex !=
                                    index) {
                                  context
                                      .read<AppBloc>()
                                      .add(SetSelectedTab(index));
                                }
                              },
                              children: const [
                                RaceCalculatorPage(),
                                PaceCalculatorPage(),
                                PredictionPage(),
                                RaceSpecificPage(),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Persistent Footer
                      const PersistentFooter(),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildResponsiveTabSelector(BuildContext context, AppState appState) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        if (isMobile) {
          // Mobile: Stack tabs vertically with icons only
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildTabButton(
                      context,
                      appState,
                      0,
                      Icons.timer_rounded,
                      'Splits',
                      isMobile: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTabButton(
                      context,
                      appState,
                      1,
                      Icons.speed_rounded,
                      'Pace',
                      isMobile: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTabButton(
                      context,
                      appState,
                      2,
                      Icons.trending_up_rounded,
                      'Predict (Beta)',
                      isMobile: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildTabButton(
                      context,
                      appState,
                      3,
                      Icons.route_rounded,
                      'Race Route (Beta)',
                      isMobile: true,
                    ),
                  ),
                  const Expanded(
                      child: SizedBox()), // Empty space for alignment
                  const Expanded(child: SizedBox()),
                ],
              ),
            ],
          );
        } else {
          // Desktop: Horizontal tabs with full labels
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildTabButton(
                    context,
                    appState,
                    0,
                    Icons.timer_rounded,
                    'Split Calculator',
                    isMobile: false,
                  ),
                ),
                Expanded(
                  child: _buildTabButton(
                    context,
                    appState,
                    1,
                    Icons.speed_rounded,
                    'Pace Calculator',
                    isMobile: false,
                  ),
                ),
                Expanded(
                  child: _buildTabButton(
                    context,
                    appState,
                    2,
                    Icons.trending_up_rounded,
                    'Predict (Beta)',
                    isMobile: false,
                  ),
                ),
                Expanded(
                  child: _buildTabButton(
                    context,
                    appState,
                    3,
                    Icons.route_rounded,
                    'Race Route (Beta)',
                    isMobile: false,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildTabButton(BuildContext context, AppState appState, int index,
      IconData icon, String label,
      {required bool isMobile}) {
    final isSelected = appState.selectedTabIndex == index;

    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? 8 : 12,
          horizontal: isMobile ? 8 : 16,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: isMobile ? 16 : 18,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            if (!isMobile) ...[
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ] else ...[
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
