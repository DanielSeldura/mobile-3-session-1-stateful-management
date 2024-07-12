import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class LocationController {
  // // Static getter to access the instance through GetIt
  // static LocationController get instance =>
  //     GetIt.instance<LocationController>();
  //
  // static LocationController get I => GetIt.instance<LocationController>();
  //
  // static void initialize() {
  //   GetIt.instance.registerSingleton<LocationController>(LocationController());
  // }

  ValueNotifier<Position> currentPosition =
      ValueNotifier(Position.fromMap({"latitude": 0.0, "longitude": 0.0}));

  Future<bool> initializePermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      return true;
    } catch (e, st) {
      print([e, st]);
      return false;
    }
  }

  StreamSubscription<Position>? locationStream;

  Future<Position> getMyCurrentLocationAndListen() async {
    locationStream ??= Geolocator.getPositionStream().listen((pos) {
      print("LocationUpdate = [${pos.latitude}/${pos.latitude}] ");
      currentPosition.value = pos;
    });
    return Geolocator.getCurrentPosition();
  }

  dispose() {
    locationStream?.cancel();
  }
}
