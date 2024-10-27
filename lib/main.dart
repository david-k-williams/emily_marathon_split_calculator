import 'package:emily_marathon_split_calculator/ui/theme/theme.dart';
import 'package:emily_marathon_split_calculator/utils/theme_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emily_marathon_split_calculator/bloc/bloc.dart';
import 'package:emily_marathon_split_calculator/ui/pages/race_calculator.dart';

void main() {
  runApp(const MarathonTimeEstimatorApp());
}

class MarathonTimeEstimatorApp extends StatelessWidget {
  const MarathonTimeEstimatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    // Retrieves the default theme for the platform
    //TextTheme textTheme = Theme.of(context).textTheme;

    // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme = createTextTheme(context, "Open Sans", "Alexandria");

    MaterialTheme theme = MaterialTheme(textTheme);

    return BlocProvider(
      create: (_) => RaceSettingsBloc(),
      child: MaterialApp(
        title: "Emily's Race Split Estimator",
        theme: brightness == Brightness.light ? theme.light() : theme.dark(),
        home: RaceCalculatorPage(),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';

// void main() {
//   runApp(MarathonTimeEstimatorApp());
// }

// // Define Events
// abstract class RaceSettingsEvent {}

// class SetPaceMinutes extends RaceSettingsEvent {
//   final int minutes;
//   SetPaceMinutes(this.minutes);
// }

// class SetPaceSeconds extends RaceSettingsEvent {
//   final int seconds;
//   SetPaceSeconds(this.seconds);
// }

// class SetStartTime extends RaceSettingsEvent {
//   final TimeOfDay time;
//   SetStartTime(this.time);
// }

// class SetRaceDistance extends RaceSettingsEvent {
//   final String distance;
//   SetRaceDistance(this.distance);
// }

// class CalculateSplits extends RaceSettingsEvent {}

// // Define State
// class RaceSettingsState {
//   final int paceMinutes;
//   final int paceSeconds;
//   final TimeOfDay startTime;
//   final String raceDistance;
//   final List<Map<String, dynamic>> splitTimes;

//   RaceSettingsState({
//     this.paceMinutes = 5,
//     this.paceSeconds = 0,
//     this.startTime = const TimeOfDay(hour: 8, minute: 0),
//     this.raceDistance = 'Marathon',
//     this.splitTimes = const [],
//   });

//   RaceSettingsState copyWith({
//     int? paceMinutes,
//     int? paceSeconds,
//     TimeOfDay? startTime,
//     String? raceDistance,
//     List<Map<String, dynamic>>? splitTimes,
//   }) {
//     return RaceSettingsState(
//       paceMinutes: paceMinutes ?? this.paceMinutes,
//       paceSeconds: paceSeconds ?? this.paceSeconds,
//       startTime: startTime ?? this.startTime,
//       raceDistance: raceDistance ?? this.raceDistance,
//       splitTimes: splitTimes ?? this.splitTimes,
//     );
//   }
// }

// // Single Bloc for Race Settings and Calculations
// class RaceSettingsBloc extends Bloc<RaceSettingsEvent, RaceSettingsState> {
//   RaceSettingsBloc() : super(RaceSettingsState()) {
//     on<SetPaceMinutes>((event, emit) {
//       emit(state.copyWith(paceMinutes: event.minutes));
//     });
//     on<SetPaceSeconds>((event, emit) {
//       emit(state.copyWith(paceSeconds: event.seconds));
//     });
//     on<SetStartTime>((event, emit) {
//       emit(state.copyWith(startTime: event.time));
//     });
//     on<SetRaceDistance>((event, emit) {
//       emit(state.copyWith(raceDistance: event.distance));
//     });
//     on<CalculateSplits>((event, emit) {
//       emit(state.copyWith(splitTimes: _calculateSplits()));
//     });
//   }

//   final Map<String, double> raceDistances = {
//     '5K': 3.1,
//     '10K': 6.2,
//     'Half Marathon': 13.1,
//     'Marathon': 26.2,
//   };

//   List<Map<String, dynamic>> _calculateSplits() {
//     final totalMiles = raceDistances[state.raceDistance] ?? 26.2;
//     final paceDuration =
//         Duration(minutes: state.paceMinutes, seconds: state.paceSeconds);
//     DateTime currentTime =
//         DateTime(2024, 1, 1, state.startTime.hour, state.startTime.minute);
//     Duration totalElapsedTime = Duration.zero;

//     List<Map<String, dynamic>> splitTimes = [];
//     final keyDistances = {
//       3: '5K',
//       6: '10K',
//       13: 'Half Marathon',
//       26: 'Marathon',
//     };

//     for (int mile = 1; mile <= totalMiles.floor(); mile++) {
//       currentTime = currentTime.add(paceDuration);
//       totalElapsedTime += paceDuration;

//       final elapsedText =
//           "${totalElapsedTime.inHours}h ${totalElapsedTime.inMinutes % 60}m";
//       final mileTimeText =
//           "Mile $mile: ${DateFormat.jm().format(currentTime)}  (Elapsed: $elapsedText)";

//       // Regular mile marker
//       splitTimes.add({
//         'text': mileTimeText,
//         'isBold': false,
//       });

//       // Insert key distance markers inline (like 5K, 10K, etc.)
//       if (keyDistances.containsKey(mile)) {
//         final keyDistance = keyDistances[mile]!;
//         final keyDistanceText =
//             "$keyDistance: ${DateFormat.jm().format(currentTime)}";
//         splitTimes.add({
//           'text': keyDistanceText,
//           'isBold': true,
//         });
//       }
//     }

//     // Handle any additional distance for partial miles, if needed
//     final partialMile = totalMiles - totalMiles.floor();
//     if (partialMile > 0) {
//       final partialTime = currentTime.add(Duration(
//           minutes: (state.paceMinutes * partialMile).toInt(),
//           seconds: (state.paceSeconds * partialMile).toInt()));
//       totalElapsedTime += Duration(
//           minutes: (state.paceMinutes * partialMile).toInt(),
//           seconds: (state.paceSeconds * partialMile).toInt());

//       splitTimes.add({
//         'text':
//             "Mile ${totalMiles.toStringAsFixed(1)}: ${DateFormat.jm().format(partialTime)}  (Elapsed: ${totalElapsedTime.inHours}h ${totalElapsedTime.inMinutes % 60}m)",
//         'isBold': false,
//       });
//     }

//     return splitTimes;
//   }
// }

// class MarathonTimeEstimatorApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => RaceSettingsBloc(),
//       child: MaterialApp(
//         title: "Emily's Race Split Estimator",
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         home: RaceCalculatorPage(),
//       ),
//     );
//   }
// }

// class RaceCalculatorPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Emily's Race Split Estimator")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: BlocBuilder<RaceSettingsBloc, RaceSettingsState>(
//           builder: (context, settings) {
//             return Column(
//               children: [
//                 Card(
//                   elevation: 2,
//                   margin: EdgeInsets.all(8),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("Race Type",
//                             style: TextStyle(fontWeight: FontWeight.bold)),
//                         DropdownButton<String>(
//                           value: settings.raceDistance,
//                           items: context
//                               .read<RaceSettingsBloc>()
//                               .raceDistances
//                               .keys
//                               .map((String distance) {
//                             return DropdownMenuItem<String>(
//                               value: distance,
//                               child: Text(distance),
//                             );
//                           }).toList(),
//                           onChanged: (String? newValue) {
//                             if (newValue != null) {
//                               context
//                                   .read<RaceSettingsBloc>()
//                                   .add(SetRaceDistance(newValue));
//                             }
//                           },
//                         ),
//                         SizedBox(height: 16),
//                         Text("Pace",
//                             style: TextStyle(fontWeight: FontWeight.bold)),
//                         Row(
//                           children: [
//                             DropdownButton<int>(
//                               value: settings.paceMinutes,
//                               items: [
//                                 for (int i = 5; i <= 20; i++)
//                                   DropdownMenuItem(
//                                       value: i, child: Text('$i min'))
//                               ],
//                               onChanged: (int? newValue) {
//                                 if (newValue != null) {
//                                   context
//                                       .read<RaceSettingsBloc>()
//                                       .add(SetPaceMinutes(newValue));
//                                 }
//                               },
//                             ),
//                             Text(" : "),
//                             DropdownButton<int>(
//                               value: settings.paceSeconds,
//                               items: [
//                                 for (int i = 0; i < 60; i += 5)
//                                   DropdownMenuItem(
//                                       value: i, child: Text('$i sec'))
//                               ],
//                               onChanged: (int? newValue) {
//                                 if (newValue != null) {
//                                   context
//                                       .read<RaceSettingsBloc>()
//                                       .add(SetPaceSeconds(newValue));
//                                 }
//                               },
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 16),
//                         Text("Start Time",
//                             style: TextStyle(fontWeight: FontWeight.bold)),
//                         ElevatedButton(
//                           onPressed: () async {
//                             final picked = await showTimePicker(
//                               context: context,
//                               initialTime: settings.startTime,
//                             );
//                             if (picked != null) {
//                               context
//                                   .read<RaceSettingsBloc>()
//                                   .add(SetStartTime(picked));
//                             }
//                           },
//                           child: Text(
//                             'Start Time: ${settings.startTime.format(context)}',
//                           ),
//                         ),
//                         SizedBox(height: 16),
//                         Center(
//                           child: ElevatedButton(
//                             onPressed: () {
//                               context
//                                   .read<RaceSettingsBloc>()
//                                   .add(CalculateSplits());
//                             },
//                             child: Text('Calculate'),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Expanded(
//                   child: ListView.separated(
//                     itemCount: settings.splitTimes.length,
//                     itemBuilder: (context, index) {
//                       final mileData = settings.splitTimes[index];
//                       return ListTile(
//                         title: Text(
//                           mileData['text'],
//                           style: TextStyle(
//                             fontWeight: mileData['isBold']
//                                 ? FontWeight.bold
//                                 : FontWeight.normal,
//                           ),
//                         ),
//                       );
//                     },
//                     separatorBuilder: (context, index) => Divider(),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
