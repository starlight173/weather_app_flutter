enum TemperatureStatus {
  celcius,
  fahrenheit;

  String get name {
    switch (this) {
      case TemperatureStatus.celcius:
        return 'Celcius';
      case TemperatureStatus.fahrenheit:
        return 'Fahrenheit';
      default:
        throw ArgumentError('Invalid enum: $this');
    }
  }

  static TemperatureStatus fromString(String nameString) {
    switch (nameString) {
      case 'Celcius':
        return TemperatureStatus.celcius;
      case 'Fahrenheit':
        return TemperatureStatus.fahrenheit;
      default:
        throw ArgumentError('Invalid enum string: $nameString');
    }
  }
}