part of 'settings_bloc.dart';

final class SettingsState extends Equatable {
  const SettingsState({
    this.temperatureStatus = TemperatureStatus.celcius,
  });

  final TemperatureStatus temperatureStatus;

  SettingsState copyWith({
    TemperatureStatus? temperatureStatus,
  }) {
    return SettingsState(
      temperatureStatus: temperatureStatus ?? this.temperatureStatus,
    );
  }

  @override
  String toString() {
    return '''SettingsState { temperatureStatus: $temperatureStatus}''';
  }

  @override
  List<Object> get props => [temperatureStatus];
}
