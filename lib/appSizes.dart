import 'package:flutter/material.dart';

class AppSizes {
  // Размеры экрана
  static late double width;
  static late double height;

  // Шрифты
  static late double textSizeSmall;
  static late double textSizeMedium;
  static late double textSizeLarge;

  // Отступы
  static late double paddingSmall;
  static late double paddingMedium;
  static late double paddingLarge;

  /// Инициализация размеров
  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;

    // Адаптивные шрифты
    textSizeSmall = width * 0.04;  // Маленький текст
    textSizeMedium = width * 0.05; // Средний текст
    textSizeLarge = width * 0.06;  // Большой текст

    // Адаптивные отступы
    paddingSmall = width * 0.02;  // Маленький отступ
    paddingMedium = width * 0.04; // Средний отступ
    paddingLarge = width * 0.06;  // Большой отступ
  }
}