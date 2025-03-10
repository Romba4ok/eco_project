import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:weather_icons/weather_icons.dart';

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
  static final SupabaseClient _supabase = Supabase.instance.client;

  static Future<void> init() async {
    loading = false;
    await getLocation();
    await fetchAirQuality();
    await fetchWeatherForecast();
    await updateGeoUser();
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
}
