import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class CacheClearScreen {
  // Очистка кэша изображений
  void clearImageCache() {
    imageCache.clear();
    imageCache.clearLiveImages();
    print("🧹 Кэш изображений очищен!");
  }

  // Очистка кэша файлов (CachedNetworkImage)
  void clearFileCache() async {
    await DefaultCacheManager().emptyCache();
    print("🗑 Кэш файлов очищен!");
  }

  // Очистка SharedPreferences (настроек)
  void clearSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print("🗑 SharedPreferences очищены!");
  }

  // Очистка временных файлов
  void clearTempFiles() async {
    try {
      final tempDir = await getTemporaryDirectory();
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
        print("🗑 Временные файлы удалены!");
      }
    } catch (e) {
      print("❌ Ошибка очистки кэша: $e");
    }
  }

  // Очистка всего кэша
  void clearAllCache() {
    clearImageCache();
    clearFileCache();
    clearSharedPrefs();
    clearTempFiles();
    print("🚀 Весь кэш очищен!");
  }
}
