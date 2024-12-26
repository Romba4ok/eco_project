import 'package:flutter/material.dart';

class AppSizes {
  // Размеры экрана
  static late double width;
  static late double height;

  /// Инициализация размеров
  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
  }
}