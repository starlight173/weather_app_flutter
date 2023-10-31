import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_app/modules/app_setting/bloc/app_setting_bloc.dart';
import 'package:flutter_weather_app/modules/settings/enums/temperature_status.dart';
import 'package:flutter_weather_app/modules/weather/repositories/geoloc_repository.dart';
import 'package:flutter_weather_app/modules/weather/views/home/bloc/home_bloc.dart';
import 'package:flutter_weather_app/modules/weather/views/home/weather_item_view.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

import '../../../../config/api_constant.dart';
import '../../../../shared/utils/geolocator_wrapper.dart';
import '../../../../shared/utils/navigation.dart';
import '../../../settings/views/settings_page.dart';
import '../../repositories/weather_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(
        weatherRepository: WeatherRepository(
            provider: WeatherFactory(APIConstant.API_KEY,
                language: Language.ENGLISH)),
        geoRepository: GeolocRepository(
          provider: GeolocatorWrapper(),
        ),
      )..add(const HomeLoaded()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('HomeView - Received lifecycle change to $state');
    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint("app in resumed");
        context.read<HomeBloc>().add(const HomeBgToFg());
        break;
      case AppLifecycleState.inactive:
        debugPrint("app in inactive");
        break;
      case AppLifecycleState.paused:
        debugPrint("app in paused");
        break;
      case AppLifecycleState.detached:
        debugPrint("app in detached");
        break;
      case AppLifecycleState.hidden:
        debugPrint("app in hidden");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
        actions: [
          IconButton(
            splashRadius: 0.0001,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 22, maxWidth: 22),
            onPressed: () => toSettingsScreen(context),
            icon: const Icon(
              Icons.settings_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 1.2 * kToolbarHeight, 40, 20),
        child: Stack(
          children: [
            Align(
              alignment: const AlignmentDirectional(3, -0.3),
              child: Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                  color: Colors.deepPurple,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(-3, -0.3),
              child: Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                  color: Colors.deepPurple,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(0, -1.2),
              child: Container(
                width: 600,
                height: 300,
                decoration: const BoxDecoration(
                  color: Colors.deepOrange,
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
            ),
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state.status == HomeStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state.status == HomeStatus.error) {
                  return const Center(
                    child: Text(
                      'Oop! Something went wrong!',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '📍 ${state.weather?.areaName}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      'Good morning',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Center(
                      child: _getWeatherIcon(
                          state.weather?.weatherConditionCode ?? 0),
                    ),
                    Center(
                      child: Text(
                        //'21°C',
                        context
                                    .watch<AppSettingBloc>()
                                    .state
                                    .temperatureStatus ==
                                TemperatureStatus.celcius
                            ? '${state.weather?.temperature?.celsius?.round()}°C'
                            : '${state.weather?.temperature?.fahrenheit?.round()}°F',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        state.weather?.weatherMain ?? '----',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        DateFormat('MMMM d, h:mm:a').format(DateTime.now()),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        WeatherItemView(
                          imagePath: "assets/images/11.png",
                          title: 'Sunrise',
                          description: state.weather?.sunrise == null
                              ? '--'
                              : DateFormat.Hm().format(state.weather!.sunrise!),
                        ),
                        WeatherItemView(
                          imagePath: "assets/images/12.png",
                          title: 'Sunset',
                          description: state.weather?.sunset == null
                              ? '--'
                              : DateFormat.Hm().format(state.weather!.sunset!),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Divider(color: Colors.grey),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        WeatherItemView(
                          imagePath: "assets/images/14.png",
                          title: 'Temp Min',
                          description: context
                                      .watch<AppSettingBloc>()
                                      .state
                                      .temperatureStatus ==
                                  TemperatureStatus.celcius
                              ? '${state.weather?.tempMin?.celsius?.round()}°C'
                              : '${state.weather?.tempMin?.fahrenheit?.round()}°F',
                        ),
                        WeatherItemView(
                          imagePath: "assets/images/13.png",
                          title: 'Temp Max',
                          description: context
                                      .watch<AppSettingBloc>()
                                      .state
                                      .temperatureStatus ==
                                  TemperatureStatus.celcius
                              ? '${state.weather?.tempMax?.celsius?.round()}°C'
                              : '${state.weather?.tempMax?.fahrenheit?.round()}°F',
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _getWeatherIcon(int code) {
    switch (code) {
      case >= 200 && < 300:
        return Image.asset('assets/images/1.png');
      case >= 300 && < 400:
        return Image.asset('assets/images/2.png');
      case >= 500 && < 600:
        return Image.asset('assets/images/3.png');
      case >= 600 && < 700:
        return Image.asset('assets/images/4.png');
      case >= 700 && < 800:
        return Image.asset('assets/images/5.png');
      case == 800:
        return Image.asset('assets/images/6.png');
      case > 800 && <= 804:
        return Image.asset('assets/images/8.png');
      default:
        return Image.asset('assets/images/7.png');
    }
  }

  void toSettingsScreen(BuildContext context) {
    Navigation.navigateTo(
      context: context,
      screen: const SettingPage(),
      style: NavigationRouteStyle.material,
    );
  }
}
