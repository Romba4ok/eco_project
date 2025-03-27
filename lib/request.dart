import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:intl/intl.dart';


class RequestCheck {
  static bool loading = false;
  static double? latitude;
  static double? longitude;
  static String? city;
  static String? state;
  static int pollutionLevel = 0;
  static Color? pollutionLevelColor;
  static String? pollutionLevelText;
  static String? temperature;
  static String? humidity;
  static String? time;
  static String iconRequest = "01d";
  static final String apiKey = "0f21dc0b-4bc6-46e2-85e0-57fbac370543";
  static final String apiKeyWeather = "21ac8e81ee16d60dacb39e207c9de134";
  static List<dynamic> forecast = [];
  static List<dynamic> forecastWeather = [];
  static List<IconData> iconList = [];
  static List<int> temperatures = [];
  static final SupabaseClient _supabase = Supabase.instance.client;

  static Future<void> init() async {
    loading = false;
    await getLocation();
    await fetchAirQuality();
    await fetchWeatherForecast();
    await updateGeoUser();
    await fetchFiveDayForecast();
    loading =
        true; // Теперь loading устанавливается в true только после полной загрузки данных
  }

  static Future<void> updateGeoUser() async {
    User? user = _supabase.auth.currentUser;
    if (user != null) {
      await _supabase.from('users').update({'state': state}).eq('id', user.id);
      await _supabase.from('users').update({'city': city}).eq('id', user.id);

    }
  }

  static Future<void> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    latitude = position.latitude;
    longitude = position.longitude;
  }

  static Future<void> fetchAirQuality() async {
    final String url =
        "http://api.airvisual.com/v2/nearest_city?lat=$latitude&lon=$longitude&key=$apiKey";

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      city = jsonData['data']['city'];
      state = jsonData['data']['state'];
      pollutionLevel =
          jsonData['data']['current']['pollution']['aqius'].toInt();
      temperature = jsonData['data']['current']['weather']['tp'].toString();
      humidity = jsonData['data']['current']['weather']['hu'].toString();
      iconRequest = jsonData['data']['current']['weather']['ic'].toString();
      print(jsonData);

      DateTime now = DateTime.now();
      time =
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

      determinePollutionLevel();
    } else {
      print("Ошибка: ${response.reasonPhrase}");
    }
  }

  static void determinePollutionLevel() {
    if (pollutionLevel >= 0 && pollutionLevel <= 50) {
      pollutionLevelText = "Отлично";
      pollutionLevelColor = Color(0xFF00FF00);
    } else if (pollutionLevel > 50 && pollutionLevel <= 100) {
      pollutionLevelText = "Хорошо";
      pollutionLevelColor = Color(0xFFFFFF00);
    } else if (pollutionLevel > 100 && pollutionLevel <= 150) {
      pollutionLevelText = "Средне";
      pollutionLevelColor = Color(0xFFFFA500);
    } else if (pollutionLevel > 150 && pollutionLevel <= 200) {
      pollutionLevelText = "Вредно";
      pollutionLevelColor = Color(0xFFFF0000);
    } else if (pollutionLevel > 201 && pollutionLevel <= 300) {
      pollutionLevelText = "Угрожающе";
      pollutionLevelColor = Color(0xFF800080);
    } else {
      pollutionLevelText = "Опасно";
      pollutionLevelColor = Color(0xFF4B0082);
    }
  }

  static IconData getWeatherIcon(String iconCode) {
    Map<String, IconData> iconMap = {
      "01d": WeatherIcons.day_sunny,
      "01n": WeatherIcons.night_clear,
      "02d": WeatherIcons.day_cloudy,
      "02n": WeatherIcons.night_cloudy,
      "03d": WeatherIcons.cloud,
      "03n": WeatherIcons.cloud,
      "04d": WeatherIcons.cloudy,
      "04n": WeatherIcons.cloudy,
      "09d": WeatherIcons.rain_wind,
      "09n": WeatherIcons.rain_wind,
      "10d": WeatherIcons.day_rain,
      "10n": WeatherIcons.night_rain,
      "11d": WeatherIcons.storm_showers,
      "11n": WeatherIcons.storm_showers,
      "13d": WeatherIcons.snow,
      "13n": WeatherIcons.snow,
      "50d": WeatherIcons.windy,
      "50n": WeatherIcons.windy,
    };

    return iconMap[iconCode] ?? WeatherIcons.na;
  }

  static Future<void> fetchWeatherForecast() async {
    final String url =
        "https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$apiKeyWeather&units=metric";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      forecast = data['list'];
      print(forecast);

      String cityName = data['city']['name'];
      String country = data['city']['country'];
      print("📍 Город: $cityName, Страна: $country");

      temperatures = forecast.map<int>((item) {
        return (item['main']['temp'] as num).round();
      }).toList();

      print("🌡️ Температуры на 5 дней: $temperatures");

      // Группируем прогноз по дням
      Map<String, List<String>> dailyWeather = {};

      for (var item in forecast) {
        String date = item['dt_txt'].split(' ')[0]; // Получаем дату YYYY-MM-DD
        String iconCode = item['weather'][0]['icon']; // Код иконки

        if (!dailyWeather.containsKey(date)) {
          dailyWeather[date] = [];
        }
        dailyWeather[date]!.add(iconCode);
      }

      // Очищаем иконки перед заполнением
      iconList.clear();

      // Определяем главную иконку для каждого дня
      dailyWeather.forEach((date, icons) {
        String mostFrequentIcon =
            getMostFrequentWeather(icons); // Находим самую частую иконку дня
        iconList.add(getWeatherIcon(mostFrequentIcon));
      });

      print(iconList);
    } else {
      throw Exception("Ошибка загрузки данных");
    }
  }

  static String getMostFrequentWeather(List<String> weatherList) {
    Map<String, int> weatherCount = {};
    for (var weather in weatherList) {
      weatherCount[weather] = (weatherCount[weather] ?? 0) + 1;
    }
    return weatherCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  Future<Map<String, dynamic>> getAQI(double latitude, double longitude) async {
    final String url = "http://api.airvisual.com/v2/nearest_city?lat=$latitude&lon=$longitude&key=$apiKey";

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      int aqi = jsonData['data']['current']['pollution']['aqius'].toInt();

      String levelText;
      Color levelColor;

      if (aqi >= 0 && aqi <= 50) {
        levelText = "Отлично";
        levelColor = Colors.green;
      } else if (aqi > 50 && aqi <= 100) {
        levelText = "Хорошо";
        levelColor = Colors.yellow;
      } else if (aqi > 100 && aqi <= 150) {
        levelText = "Средне";
        levelColor = Colors.orange;
      } else if (aqi > 150 && aqi <= 200) {
        levelText = "Вредно";
        levelColor = Colors.red;
      } else if (aqi > 200 && aqi <= 300) {
        levelText = "Угрожающе";
        levelColor = Colors.purple;
      } else {
        levelText = "Опасно";
        levelColor = Colors.indigo;
      }

      return {
        "aqi": aqi,
        "color": levelColor,
        "text": levelText,
      };
    } else {
      throw Exception("Ошибка: ${response.reasonPhrase}");
    }
  }

  static int getMaxDayTemperature() {
    try {
      List<double> dayTemps = forecast
          .where((item) {
        String hour = item['dt_txt']?.split(' ')?.elementAt(1)?.split(':')?.first ?? '12';
        int hourInt = int.tryParse(hour) ?? 12;
        return hourInt >= 6 && hourInt < 18;
      })
          .map<double>((item) => (item['main']['temp'] as num?)?.toDouble() ?? 0.0)
          .toList();

      if (dayTemps.isEmpty) return 0;
      return dayTemps.reduce((a, b) => a > b ? a : b).round();
    } catch (e) {
      print('Ошибка в getMaxDayTemperature: $e');
      return 0;
    }
  }

  static int getMinNightTemperature() {
    try {
      List<double> nightTemps = forecast
          .where((item) {
        String hour = item['dt_txt']?.split(' ')?.elementAt(1)?.split(':')?.first ?? '0';
        int hourInt = int.tryParse(hour) ?? 0;
        return hourInt >= 18 || hourInt < 6;
      })
          .map<double>((item) => (item['main']['temp'] as num?)?.toDouble() ?? 0.0)
          .toList();

      if (nightTemps.isEmpty) return 0;
      return nightTemps.reduce((a, b) => a < b ? a : b).round();
    } catch (e) {
      print('Ошибка в getMinNightTemperature: $e');
      return 0;
    }
  }

  static Future<void> fetchFiveDayForecast() async {
    final String url =
        "https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$apiKeyWeather&units=metric";

    try {
      print("🌍 Запрос прогноза погоды: $url");
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        print("❌ Ошибка ${response.statusCode}: ${response.body}");
        return;
      }

      final data = jsonDecode(response.body);
      if (data["list"] == null || data["list"].isEmpty) {
        print("⚠️ Нет данных прогноза");
        return;
      }

      // Словарь для хранения данных по дням
      Map<String, Map<String, dynamic>> dailyData = {};

      for (var entry in data["list"]) {
        try {
          String date = entry["dt_txt"]?.split(" ")?.first ?? "";
          if (date.isEmpty) continue;

          String time = entry["dt_txt"]?.split(" ")?.elementAt(1) ?? "";
          int hour = int.tryParse(time.split(":").first) ?? 0;
          bool isDaytime = hour >= 6 && hour < 18;

          double temp = (entry["main"]["temp"] as num?)?.toDouble() ?? 0.0;
          int humidity = entry["main"]["humidity"] as int? ?? 0;
          String icon = entry["weather"][0]["icon"]?.toString() ?? "01d";

          // Инициализация дня если его еще нет
          if (!dailyData.containsKey(date)) {
            dailyData[date] = {
              "dayOfWeek": getWeekday(date),
              "tempValues": [],
              "humidityValues": [],
              "dayIcons": [],
              "nightIcons": [],
            };
          }

          // Добавляем данные
          dailyData[date]!["tempValues"].add(temp);
          dailyData[date]!["humidityValues"].add(humidity);

          if (isDaytime) {
            dailyData[date]!["dayIcons"].add(icon);
          } else {
            dailyData[date]!["nightIcons"].add(icon);
          }
        } catch (e) {
          print("⚠️ Ошибка обработки записи прогноза: $e");
        }
      }

      // Обработка собранных данных
      List<Map<String, dynamic>> processedForecast = [];

      dailyData.forEach((date, data) {
        List<double> temps = List<double>.from(data["tempValues"]);
        List<int> humidities = List<int>.from(data["humidityValues"]);
        List<String> dayIcons = List<String>.from(data["dayIcons"]);
        List<String> nightIcons = List<String>.from(data["nightIcons"]);

        processedForecast.add({
          "date": date,
          "dayOfWeek": data["dayOfWeek"],
          "maxTemp": temps.reduce((a, b) => a > b ? a : b).round(),
          "minTemp": temps.reduce((a, b) => a < b ? a : b).round(),
          "avgHumidity": (humidities.reduce((a, b) => a + b) / humidities.length).round(),
          "dayIcon": _getMostFrequentIcon(dayIcons),
          "nightIcon": _getMostFrequentIcon(nightIcons),
        });
      });

      // Сортируем по дате и берем первые 5 дней
      processedForecast.sort((a, b) => a["date"].compareTo(b["date"]));
      RequestCheck.forecastWeather = processedForecast.take(5).toList();

      // Логирование результатов
      print("✅ Прогноз успешно загружен");
      RequestCheck.forecastWeather.forEach((day) {
        print(
            "${day["dayOfWeek"]}: "
                "Макс ${day["maxTemp"]}°C, "
                "Мин ${day["minTemp"]}°C, "
                "Влажность ${day["avgHumidity"]}%, "
                "День: ${day["dayIcon"]}, "
                "Ночь: ${day["nightIcon"]}"
        );
      });

    } catch (e) {
      print("❌ Критическая ошибка в fetchFiveDayForecast: $e");
    }
  }

// Вспомогательные методы
  static String _getMostFrequentIcon(List<String> icons) {
    if (icons.isEmpty) return "01d";
    var counts = <String, int>{};
    for (var icon in icons) {
      counts[icon] = (counts[icon] ?? 0) + 1;
    }
    return counts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  static String getWeekday(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      List<String> weekdays = [
        "Воскресенье", "Понедельник", "Вторник", "Среда",
        "Четверг", "Пятница", "Суббота"
      ];
      return weekdays[parsedDate.weekday % 7];
    } catch (e) {
      print("⚠️ Ошибка определения дня недели: $e");
      return "Неизвестно";
    }
  }

  /// Преобразует динамическое значение в double, предотвращая ошибки типа
  static double _parseToDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    } else {
      return 0.0; // Значение по умолчанию
    }
  }

}
