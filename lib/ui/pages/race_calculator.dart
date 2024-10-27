import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emily_marathon_split_calculator/bloc/bloc.dart';
import 'package:emily_marathon_split_calculator/bloc/bloc_state.dart';
import 'package:emily_marathon_split_calculator/bloc/bloc_event.dart';
import 'package:emily_marathon_split_calculator/ui/widgets/settings_card.dart';

class RaceCalculatorPage extends StatelessWidget {
  const RaceCalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("emily's race split estimator"),
        elevation: 5.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<RaceSettingsBloc, RaceSettingsState>(
          builder: (context, settings) {
            return Column(
              children: [
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  firstChild: SettingsCard(settings: settings),
                  secondChild: GestureDetector(
                    onTap: () {
                      context
                          .read<RaceSettingsBloc>()
                          .add(ToggleSettingsVisibility());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_drop_down),
                          Text("Adjust Settings"),
                        ],
                      ),
                    ),
                  ),
                  crossFadeState: settings.settingsVisible
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: settings.splitTimes.length,
                    itemBuilder: (context, index) {
                      final mileData = settings.splitTimes[index];
                      return ListTile(
                        leading:
                            mileData['isBold'] ? const Icon(Icons.flag) : null,
                        title: Text(
                          mileData['text'],
                          style: TextStyle(
                            fontWeight: mileData['isBold']
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
