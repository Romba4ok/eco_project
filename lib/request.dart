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
  static List<IconData> iconList = [];
  static List<int> temperatures = [];
  static List<int> humidities = [];
  static List<String> icons = [];
  static final SupabaseClient _supabase = Supabase.instance.client;
  static List<List<int>> dayTemperatures = [];
  static List<List<int>> nightTemperatures = [];
  static List<List<String>> dayIcons = [];
  static List<List<String>> nightIcons = [];
  static List<List<int>> himiditeesDays = [];
  static List<Map<String, dynamic>> forecastWeather = [];
  static int sunrise = 0; // Время рассвета (в секундах UNIX)
  static int sunset = 0;
  static DateTime? sunriseTime;
  static DateTime? sunsetTime;
  static List<double> windSpeedList = [];
  static List<(IconData icon, String text, Color color)> recommendations = [];

  static Future<void> init() async {
    loading = false;
    await getLocation();
    await fetchAirQuality();
    await fetchWeatherForecast();
    await updateGeoUser();
    await fetchFiveDayForecast();
    getRecommendation();
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
      print("iqair");
      print(jsonData);
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
      print("weather");
      print(data);
      forecast = data['list'];

      // Получение информации о городе
      String cityName = data['city']['name'];
      String country = data['city']['country'];
      int timeZoneOffset = data['city']['timezone']; // Смещение в секундах

      // Время рассвета и заката в UTC
      int sunriseUTC = data['city']['sunrise'];
      int sunsetUTC = data['city']['sunset'];

      // Конвертируем в локальное время
      sunriseTime =
          DateTime.fromMillisecondsSinceEpoch(sunriseUTC * 1000, isUtc: true)
              .toLocal();
      sunsetTime =
          DateTime.fromMillisecondsSinceEpoch(sunsetUTC * 1000, isUtc: true)
              .toLocal();

      // Форматируем время
      String formattedSunrise = DateFormat('HH:mm').format(sunriseTime!);
      String formattedSunset = DateFormat('HH:mm').format(sunsetTime!);

      // Вывод в консоль
      print("📍 Город: $cityName, Страна: $country");
      print("🌅 Рассвет (локальное время): $formattedSunrise");
      print("🌇 Закат (локальное время): $formattedSunset");

      // Границы дня
      sunrise = sunriseTime!.hour;
      sunset = sunsetTime!.hour;
      for (var forecastItem in forecast) {
        double windSpeed = forecastItem['wind']['speed']; // Скорость ветра
        windSpeedList
            .add(windSpeed); // Добавляем строку с информацией о скорости ветра
      }

      print("Wind Speed List:");
      for (var windSpeed in windSpeedList) {
        print(windSpeed); // Выводим все элементы списка
      }

      // Очистка списков перед записью новых данных
      temperatures.clear();
      icons.clear();
      humidities.clear();

      // Обрабатываем погоду
      for (var item in forecast) {
        int temp = (item['main']['temp'] as num).round();
        int humidity = (item['main']['humidity'] as num).round();
        String iconCode = item['weather'][0]['icon'];

        temperatures.add(temp);
        icons.add(iconCode);
        humidities.add(humidity);
      }

      print("🌡️ Температуры на 5 дней: $temperatures");

      // Группировка прогноза по дням
      Map<String, List<String>> dailyWeather = {};
      for (var item in forecast) {
        String date = item['dt_txt'].split(' ')[0];
        String iconCode = item['weather'][0]['icon'];

        if (!dailyWeather.containsKey(date)) {
          dailyWeather[date] = [];
        }
        dailyWeather[date]!.add(iconCode);
      }

      // Очистка списков перед записью новых данных
      iconList.clear();
      dayTemperatures.clear();
      nightTemperatures.clear();
      dayIcons.clear();
      nightIcons.clear();

      // Выбираем главную иконку дня
      dailyWeather.forEach((date, icons) {
        String mostFrequentIcon = getMostFrequentWeather(icons);
        iconList.add(getWeatherIcon(mostFrequentIcon));
      });

      print(iconList);

      // Обработка данных для дневных и ночных температур
      String? currentDate;
      for (int i = 0; i < forecast.length; i++) {
        String dateTime = forecast[i]['dt_txt'];
        String date = dateTime.split(" ")[0];

        // Локальное время
        DateTime localTime = DateTime.fromMillisecondsSinceEpoch(
            (forecast[i]['dt'] + timeZoneOffset) * 1000);
        int localHour = localTime.hour;
        print(sunrise);
        print(sunset);

        // Определяем день или ночь
        bool isDay = localHour > sunrise + 5 && localHour < sunset + 5;

        if (currentDate == null || currentDate != date) {
          // Добавляем новый день в списки
          dayTemperatures.add([]);
          nightTemperatures.add([]);
          dayIcons.add([]);
          nightIcons.add([]);
          currentDate = date;
        }

        if (isDay) {
          dayTemperatures.last.add(temperatures[i]);
          dayIcons.last.add(icons[i]);
        } else {
          nightTemperatures.last.add(temperatures[i]);
          nightIcons.last.add(icons[i]);
        }
      }

      // Вывод в консоль
      print("🌞 Дневные температуры: $dayTemperatures");
      print("🌙 Ночные температуры: $nightTemperatures");
      print("🌞 Дневные иконки: $dayIcons");
      print("🌙 Ночные иконки: $nightIcons");

      // Обработка влажности по дням
      himiditeesDays.clear();
      currentDate = null;
      List<int> dailyHumidity = [];

      for (var item in forecast) {
        String date = item['dt_txt'].split(' ')[0];
        int humidityValue = (item['main']['humidity'] as num).round();

        if (currentDate == null || currentDate != date) {
          if (dailyHumidity.isNotEmpty) {
            himiditeesDays.add(List.from(dailyHumidity));
            dailyHumidity.clear();
          }
          currentDate = date;
        }

        dailyHumidity.add(humidityValue);
      }

      if (dailyHumidity.isNotEmpty) {
        himiditeesDays.add(List.from(dailyHumidity));
      }

      print("💧 Влажность по дням: $himiditeesDays");
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
    final String url =
        "http://api.airvisual.com/v2/nearest_city?lat=$latitude&lon=$longitude&key=$apiKey";

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      int aqi = jsonData['data']['current']['pollution']['aqius'].toInt();

      String levelText;
      Color levelColor;

      if (aqi >= 0 && aqi <= 50) {
        levelText = "Отлично";
        levelColor = Color(0xFF00FF00);
      } else if (aqi > 50 && aqi <= 100) {
        levelText = "Хорошо";
        levelColor = Color(0xFFFFFF00);
      } else if (aqi > 100 && aqi <= 150) {
        levelText = "Средне";
        levelColor = Color(0xFFFFA500);
      } else if (aqi > 150 && aqi <= 200) {
        levelText = "Вредно";
        levelColor = Color(0xFFFF0000);
      } else if (aqi > 200 && aqi <= 300) {
        levelText = "Угрожающе";
        levelColor = Color(0xFF800080);
      } else {
        levelText = "Опасно";
        levelColor = Color(0xFF4B0082);
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

  static Future<void> fetchFiveDayForecast() async {
    List<int> maxDayTemperatures = [];
    List<int> minNightTemperatures = [];
    List<String> mostCommonDayIcons = [];
    List<String> mostCommonNightIcons = [];
    List<int> averageHumidityPerDay = [];
    List<String> daysOfWeek = [];

    forecastWeather.clear();

    for (int i = 0; i < dayTemperatures.length && i < 5; i++) {
      if (dayTemperatures[i].isNotEmpty) {
        maxDayTemperatures
            .add(dayTemperatures[i].reduce((a, b) => a > b ? a : b));
      } else {
        maxDayTemperatures.add(0);
      }

      if (nightTemperatures[i].isNotEmpty) {
        minNightTemperatures
            .add(nightTemperatures[i].reduce((a, b) => a < b ? a : b));
      } else {
        minNightTemperatures.add(0);
      }

      if (dayIcons[i].isNotEmpty) {
        mostCommonDayIcons.add(getMostFrequentWeathers(dayIcons[i]));
      } else {
        mostCommonDayIcons.add("unknown");
      }

      if (nightIcons[i].isNotEmpty) {
        mostCommonNightIcons.add(getMostFrequentWeathers(nightIcons[i]));
      } else {
        mostCommonNightIcons.add("unknown");
      }
    }

    averageHumidityPerDay.clear();
    for (int i = 0; i < himiditeesDays.length && i < 5; i++) {
      if (himiditeesDays[i].isNotEmpty) {
        int sumHumidity = himiditeesDays[i].reduce((a, b) => a + b);
        int avgHumidity = (sumHumidity / himiditeesDays[i].length).round();
        averageHumidityPerDay.add(avgHumidity);
      } else {
        averageHumidityPerDay.add(0);
      }
    }

    for (int i = 0; i < 5; i++) {
      DateTime day = DateTime.now().add(Duration(days: i));
      String dayName = DateFormat('EEEE', 'ru_RU').format(day);
      daysOfWeek.add(dayName);
    }

    for (int i = 0; i < 5; i++) {
      forecastWeather.add({
        "dayOfWeek": daysOfWeek[i],
        "avgHumidity": averageHumidityPerDay[i],
        "dayIcon": mostCommonDayIcons[i],
        "nightIcon": mostCommonNightIcons[i],
        "maxTemp": maxDayTemperatures[i],
        "minTemp": minNightTemperatures[i],
      });
    }

    print("🌦️ Прогноз на 5 дней: $forecastWeather");
  }

// Функция для нахождения самой частой иконки
  static String getMostFrequentWeathers(List<String> icons) {
    Map<String, int> frequency = {};
    for (var icon in icons) {
      frequency[icon] = (frequency[icon] ?? 0) + 1;
    }
    return frequency.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  static String getWeekday(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      List<String> weekdays = [
        "Воскресенье",
        "Понедельник",
        "Вторник",
        "Среда",
        "Четверг",
        "Пятница",
        "Суббота"
      ];
      return weekdays[parsedDate.weekday % 7];
    } catch (e) {
      print("⚠️ Ошибка определения дня недели: $e");
      return "Неизвестно";
    }
  }

  static getRecommendation() {
    if (pollutionLevel >= 0 && pollutionLevel <= 50) {
      recommendations = [
        (Icons.sports, 'Наслаждайтесь активным отдыхом на улице', Color(0xFF00FF00)),
        (Icons.window, 'Откройте окна,чтобы впустить  в помещение\nчистый и  воздух', Color(0xFF00FF00)),
      ];
    } else if (pollutionLevel > 50 && pollutionLevel <= 100) {
      recommendations = [
        (Icons.sports, 'Людям, имеющим повышенную чувствительность,\nследует сократить занятия спортом на открытом\nвоздухе', Color(0xFFFFFF00)),
        (Icons.window, 'Закройте окна,чтобы избежать грязного\nнаружного воздуха', Color(0xFFFFFF00)),
        (Icons.air, 'Людям с повышенной чувствительностью следует\nиспользовать очиститель воздуха', Color(0xFFFFFF00)),
        (Icons.masks, 'Чувствительные группы должны носить маску на\nоткрытом воздухе', Color(0xFFFFFF00)),
      ];
    } else if (pollutionLevel > 100 && pollutionLevel <= 150) {
      recommendations = [
        (Icons.sports, 'Уменьшите физические нагрузки на свежем\nвоздухе', Color(0xFFFFA500)),
        (Icons.window, 'Закройте окна,чтобы избежать грязного\nнаружного воздуха', Color(0xFFFFA500)),
        (Icons.air, 'Запустите очиститель воздуха ', Color(0xFFFFA500)),
        (Icons.masks, 'Чувствительные группы должны носить маску на\nоткрытом воздухе', Color(0xFFFFA500)),
      ];
    } else if (pollutionLevel > 150 && pollutionLevel <= 200) {
      recommendations = [
        (Icons.sports, 'Избегайте тренировок на свежем воздухе ', Color(0xFFFF0000)),
        (Icons.window, 'Закройте окна,чтобы избежать грязного\nнаружного воздуха', Color(0xFFFF0000)),
        (Icons.air, 'Запустите очиститель воздуха  ', Color(0xFFFF0000)),
        (Icons.masks, 'Носите маску на открытом воздухе', Color(0xFFFF0000)),
      ];
    } else if (pollutionLevel > 200 && pollutionLevel <= 300) {
      recommendations = [
        (Icons.sports, 'Избегайте тренировок на свежем воздухе ', Color(0xFF800080)),
        (Icons.window, 'Закройте окна,чтобы избежать грязного\nнаружного воздуха', Color(0xFF800080)),
        (Icons.air, 'Запустите очиститель воздуха ', Color(0xFF800080)),
        (Icons.masks, 'Носите маску на открытом воздухе', Color(0xFF800080)),
      ];
    } else {
      recommendations = [
        (Icons.sports, 'Избегайте тренировок на свежем воздухе ', Color(0xFF4B0082)),
        (Icons.window, 'Закройте окна,чтобы избежать грязного\nнаружного воздуха', Color(0xFF4B0082)),
        (Icons.air, 'Запустите очиститель воздуха', Color(0xFF4B0082)),
        (Icons.masks, 'Носите маску на открытом воздухе', Color(0xFF4B0082)),
      ];
    }
  }
}

