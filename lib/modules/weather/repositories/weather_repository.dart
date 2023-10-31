import 'package:weather/weather.dart';

abstract class IWeatherRepository {
  Future<Weather> currentWeatherByCityName(String city);
  Future<Weather> currentWeatherByPosition(double latitude, double longitude);
}

class WeatherRepository implements IWeatherRepository {
  WeatherRepository({required this.provider});

  final WeatherFactory provider;

  @override
  Future<Weather> currentWeatherByCityName(String city) async {
    return await provider.currentWeatherByCityName(city);
  }

  @override
  Future<Weather> currentWeatherByPosition(
      double latitude, double longitude) async {
    return await provider.currentWeatherByLocation(latitude, longitude);
  }
}
