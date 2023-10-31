import 'package:geolocator/geolocator.dart';

import '../../../shared/utils/geolocator_wrapper.dart';

abstract class IGeolocRepository {
  Future<void> checkPermission();
  Future<Position?> getCurrentLocation();
  Future<Position?> getLastLocation();
  Stream<Position> getLocationUpdates();
}

class GeolocRepository implements IGeolocRepository {
  GeolocRepository({required this.provider});

  final GeolocatorWrapper provider;

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  @override
  Future<Position?> getCurrentLocation() async {
    try {
      await checkPermission();

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      return await GeolocatorWrapper().getCurrentPosition();
    } catch (e) {
      await GeolocatorWrapper().openAppSettings();
    }
    return null;
  }

  /// Determine the last position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  @override
  Future<Position?> getLastLocation() async {
    try {
      await checkPermission();
      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.

      // final position = await GeolocatorWrapper().getLastKnownPosition();
      // debugPrint("$position");

      return await GeolocatorWrapper().getLastKnownPosition();
    } catch (e) {
      await GeolocatorWrapper().openAppSettings();
    }
    return null;
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  @override
  Stream<Position> getLocationUpdates() async* {
    try {
      await checkPermission();
      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.

      // GeolocatorWrapper().onLocationUpdates.listen((Position position) {
      //   debugPrint("$position");
      // });

      // Return the replay stream.
      yield* GeolocatorWrapper().onLocationUpdates.asBroadcastStream();
    } catch (e) {
      await GeolocatorWrapper().openAppSettings();
    }
  }

  Future<bool> _checkLocationService() async {
    // Check if location services are enabled.
    bool serviceEnabled = await GeolocatorWrapper().isLocationServiceEnabled;
    if (!serviceEnabled) {
      return false;
    }
    return true;
  }

  @override
  Future<void> checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _checkLocationService();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      throw Exception('Location services are disabled.');
    }

    permission = await GeolocatorWrapper().checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await GeolocatorWrapper().requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }
}
