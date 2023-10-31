part of 'app_setting_bloc.dart';

final class AppSettingState extends Equatable {
  const AppSettingState({
    this.temperatureStatus = TemperatureStatus.celcius,
  });

  final TemperatureStatus temperatureStatus;

  AppSettingState copyWith({
    TemperatureStatus? temperatureStatus,
  }) {
    return AppSettingState(
      temperatureStatus: temperatureStatus ?? this.temperatureStatus,
    );
  }

  @override
  String toString() {
    return '''AppSettingState { temperatureStatus: $temperatureStatus}''';
  }

  @override
  List<Object> get props => [temperatureStatus];
}
