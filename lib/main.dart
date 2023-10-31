import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_app/providers/repositories/shared_preferences_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'modules/app_setting/bloc/app_setting_bloc.dart';
import 'modules/weather/views/home/home_page.dart';
import 'simple_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  Bloc.observer = const SimpleBlocObserver();
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ISharedPreferencesRepository>(
          create: (context) => SharedPreferencesRepository(prefs),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppSettingBloc>(
            create: (BuildContext context) =>
                AppSettingBloc(context.read<ISharedPreferencesRepository>())
                  ..add(AppSettingLoaded()),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
// final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
