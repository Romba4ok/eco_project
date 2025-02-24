import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static double? latitude;
  static double? longitude;

  /// Проверка разрешений и получение местоположения
  static Future<void> init(BuildContext context) async {
    // Проверяем разрешение
    PermissionStatus status = await Permission.locationWhenInUse.status;

    if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
      PermissionStatus result = await Permission.locationWhenInUse.request();
      if (!result.isGranted) {
        debugPrint("⚠️ Доступ к геолокации запрещён пользователем");
        return;
      }
    }

    // Проверяем, включена ли геолокация
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
      debugPrint("⚠️ Геолокация выключена на устройстве");
      return;
    }

    // Получаем текущие координаты (с меньшей точностью)
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation, // Оптимально для мобильных устройств
    );

    latitude = position.latitude;
    longitude = position.longitude;

    debugPrint("📍 Координаты: $latitude, $longitude");
  }

  static bool isInitialized() {
    return latitude != null && longitude != null;
  }
}
