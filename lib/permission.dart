import 'package:permission_handler/permission_handler.dart';

class AppPermission {
  static Future<bool> checkAndRequestLocationPermission() async {
    PermissionStatus status = await Permission.location.status;

    if (status.isGranted) {
      return false;
    } else if (status.isDenied || status.isRestricted) {
      // Запрос разрешения
      final result = await Permission.location.request();
      if (result.isGranted) {
        return false;
      } else if (result.isPermanentlyDenied) {
        openAppSettings(); // Открыть настройки приложения
        return false;
      } else {
        return false;
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings(); // Открыть настройки приложения
      return false;
    }
    return false;
  }
}