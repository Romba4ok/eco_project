import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  // Статические переменные для хранения координат
  static double? latitude;
  static double? longitude;

  /// Инициализация координат
  static Future<void> init(BuildContext context) async {
    // Проверяем разрешения
    PermissionStatus status = await Permission.location.status;

    if (status.isDenied || status.isRestricted) {
      // Запрашиваем разрешение
      final result = await Permission.location.request();
      if (!result.isGranted) {
        // Если разрешение не предоставлено, можно обработать это как нужно
        return;
      }
    }

    // Получаем текущие координаты
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Сохраняем координаты в статические переменные
    latitude = position.latitude;  // Широта
    longitude = position.longitude; // Долгота
  }

  // Проверка, инициализированы ли координаты
  static bool isInitialized() {
    return latitude != null && longitude != null;
  }
}