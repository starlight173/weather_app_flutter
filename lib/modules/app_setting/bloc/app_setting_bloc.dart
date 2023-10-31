import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_weather_app/modules/settings/enums/temperature_status.dart';

import '../../../providers/repositories/shared_preferences_repository.dart';

part 'app_setting_event.dart';
part 'app_setting_state.dart';

class AppSettingBloc extends Bloc<AppSettingEvent, AppSettingState> {
  AppSettingBloc(this.sharedPreferencesRepository)
      : super(const AppSettingState()) {
    on<AppSettingLoaded>(_onLoaded);
    on<AppSettingTemperatureChanged>(_onTemperatureChanged);
  }

  ISharedPreferencesRepository sharedPreferencesRepository;

  Future<void> _onLoaded(
      AppSettingLoaded event, Emitter<AppSettingState> emit) async {
    final temperatureStatus = sharedPreferencesRepository.temperatureStatus;
    if (temperatureStatus == null) {
      return;
    }
    emit(state.copyWith(
        temperatureStatus: TemperatureStatus.fromString(temperatureStatus)));
  }

  Future<void> _onTemperatureChanged(
      AppSettingTemperatureChanged event, Emitter<AppSettingState> emit) async {
    emit(state.copyWith(temperatureStatus: event.temperatureStatus));
  }
}
