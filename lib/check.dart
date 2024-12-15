// main_screen.dart
import 'package:ecoalmaty/permission.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  // Создание экземпляра класса AppPermission
  final AppPermission appPermission = AppPermission();

  // Метод для вызова функции из AppPermission
  Future<void> handlePermissionCheck() async {
    String result = await appPermission.checkAndRequestLocationPermission();
    print(result); // Выводим результат в консоль
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Проверка разрешений'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            handlePermissionCheck(); // Вызов метода при нажатии кнопки
          },
          child: Text('Проверить доступ к геолокации'),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainScreen(),
  ));
}
