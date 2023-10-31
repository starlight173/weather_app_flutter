part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class SettingsLoaded extends SettingsEvent {}

class SettingsLanguageChanged extends SettingsEvent {}

class SettingsTemperatureChanged extends SettingsEvent {
  final String temperatureStatus;

  const SettingsTemperatureChanged(this.temperatureStatus);

  @override
  List<Object> get props => [temperatureStatus];
}
