import 'package:shared_preferences/shared_preferences.dart';

abstract class ISharedPreferencesRepository {
  String? get temperatureStatus;
  Future<void> setTemperatureStatus(String value);
}

class SharedPreferencesRepository extends ISharedPreferencesRepository {
  SharedPreferencesRepository(this._pref);

  final SharedPreferences _pref;

  final String kTemperature = 'temperature';

  @override
  Future<void> setTemperatureStatus(String value) async {
    await _pref.setString(kTemperature, value);
  }

  @override
  String? get temperatureStatus => _pref.getString(kTemperature);
}
