part of 'app_setting_bloc.dart';

sealed class AppSettingEvent extends Equatable {
  const AppSettingEvent();

  @override
  List<Object> get props => [];
}

class AppSettingLoaded extends AppSettingEvent {}

class AppSettingTemperatureChanged extends AppSettingEvent {
  final TemperatureStatus temperatureStatus;

  const AppSettingTemperatureChanged(this.temperatureStatus);

  @override
  List<Object> get props => [temperatureStatus];
}
