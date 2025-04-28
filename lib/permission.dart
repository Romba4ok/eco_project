import 'package:permission_handler/permission_handler.dart';

class AppPermission {
  /// Проверка и запрос разрешения на геолокацию
  static Future<bool> checkAndRequestLocationPermission() async {
    final status = await Permission.location.status;

    if (status.isGranted) return true;

    if (status.isDenied || status.isRestricted) {
      final result = await Permission.location.request();
      if (result.isGranted) return true;
      if (result.isPermanentlyDenied) openAppSettings();
      return false;
    }

    if (status.isPermanentlyDenied) openAppSettings();
    return false;
  }

  /// Проверка и запрос разрешения на камеру
  static Future<bool> checkAndRequestCameraPermission() async {
    final status = await Permission.camera.status;

    if (status.isGranted) return true;

    if (status.isDenied || status.isRestricted) {
      final result = await Permission.camera.request();
      if (result.isGranted) return true;
      if (result.isPermanentlyDenied) openAppSettings();
      return false;
    }

    if (status.isPermanentlyDenied) openAppSettings();
    return false;
  }
}
