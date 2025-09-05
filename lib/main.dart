import 'package:emily_marathon_split_calculator/ui/theme/theme.dart';
import 'package:emily_marathon_split_calculator/utils/theme_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emily_marathon_split_calculator/bloc/blocs.dart';
import 'package:emily_marathon_split_calculator/ui/pages/main_page.dart';

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

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => RaceSettingsBloc()),
        BlocProvider(create: (_) => AppBloc()),
        BlocProvider(create: (_) => PredictionBloc()),
      ],
      child: MaterialApp(
        title: "Emily's Race Split Estimator",
        theme: brightness == Brightness.light ? theme.light() : theme.dark(),
        home: const MainPage(),
      ),
    );
  }
}
