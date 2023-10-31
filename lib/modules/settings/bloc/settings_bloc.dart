import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../providers/repositories/shared_preferences_repository.dart';
import '../enums/temperature_status.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(
    this.sharedPreferencesRepository,
  ) : super(const SettingsState()) {
    on<SettingsLoaded>(_onLoaded);
    on<SettingsLanguageChanged>(_onLanguageChanged);
    on<SettingsTemperatureChanged>(_onTemperatureChanged);
  }

  ISharedPreferencesRepository sharedPreferencesRepository;

  Future<void> _onLoaded(
      SettingsLoaded event, Emitter<SettingsState> emit) async {
    final temperatureStatus = sharedPreferencesRepository.temperatureStatus;
    if (temperatureStatus == null) {
      return;
    }
    emit(state.copyWith(
        temperatureStatus: TemperatureStatus.fromString(temperatureStatus)));
  }

  Future<void> _onLanguageChanged(
      SettingsLanguageChanged event, Emitter<SettingsState> emit) async {}

  Future<void> _onTemperatureChanged(
      SettingsTemperatureChanged event, Emitter<SettingsState> emit) async {
    final status = TemperatureStatus.fromString(event.temperatureStatus);
    await sharedPreferencesRepository.setTemperatureStatus(status.name);
    emit(state.copyWith(temperatureStatus: status));
  }
}
