import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather/weather.dart';

import '../../../repositories/geoloc_repository.dart';
import '../../../repositories/weather_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required this.weatherRepository,
    required this.geoRepository,
  }) : super(const HomeState()) {
    on<HomeLoaded>(_onLoaded);
    on<HomeBgToFg>(_onBgToFg);
  }

  final IWeatherRepository weatherRepository;
  final IGeolocRepository geoRepository;

  Future<void> _onLoaded(HomeLoaded event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      final w = await _fetchWeather();
      emit(state.copyWith(status: HomeStatus.success, weather: w));
    } catch (e) {
      emit(const HomeState(status: HomeStatus.error));
    }
  }

  Future<void> _onBgToFg(HomeBgToFg event, Emitter<HomeState> emit) async {
    try {
      final w = await _fetchWeather();
      emit(state.copyWith(status: HomeStatus.success, weather: w));
    } catch (e) {
      emit(const HomeState(status: HomeStatus.error));
    }
  }

  Future<Weather?> _fetchWeather() async {
    try {
      await geoRepository.checkPermission();
      final location = await geoRepository.getCurrentLocation();

      if (location == null) return null;

      return await weatherRepository.currentWeatherByPosition(
          location.latitude, location.longitude);
    } catch (e) {
      rethrow;
    }
  }
}
