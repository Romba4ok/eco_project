import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
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
  static Icon? icon;
  static String iconRequest = "01d";
  final String API = "0f21dc0b-4bc6-46e2-85e0-57fbac370543";

  // Статический метод для инициализации и получения данных
  static Future<void> init() async {
    // Получаем текущие координаты
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    latitude = position.latitude;
    longitude = position.longitude;

    var request = http.Request('GET', Uri.parse('http://api.airvisual.com/v2/nearest_city?lat=$latitude&lon=$longitude&key=0f21dc0b-4bc6-46e2-85e0-57fbac370543'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();

      // Парсинг JSON
      var jsonData = json.decode(responseBody);

      // Получение данных из ответа
      city = jsonData['data']['city'];
      state = jsonData['data']['state'];
      pollutionLevel = jsonData['data']['current']['pollution']['aqius'].toInt();
      temperature = jsonData['data']['current']['weather']['tp'].toString();
      humidity = jsonData['data']['current']['weather']['hu'].toString();
      iconRequest = jsonData['data']['current']['weather']['ic'].toString();
      time = jsonData['data']['current']['weather']['ts'].toString();
      if (pollutionLevel >= 0 && pollutionLevel <= 50) {
        pollutionLevelText = "Отлично";
        pollutionLevelColor = Color(0xFF00FF00);
      }
      if (pollutionLevel > 50 && pollutionLevel <= 100) {
        pollutionLevelText = "Хорошо";
        pollutionLevelColor = Color(0xFFFFFF00);
      }
      if (pollutionLevel > 100 && pollutionLevel <= 150) {
        pollutionLevelText = "Средне";
        pollutionLevelColor = Color(0xFFFFA500);
      }
      if (pollutionLevel > 150 && pollutionLevel <= 200) {
        pollutionLevelText = "Вредно";
        pollutionLevelColor = Color(0xFFFF0000);
      }
      if (pollutionLevel > 201 && pollutionLevel <= 300) {
        pollutionLevelText = "Угрожающе";
        pollutionLevelColor = Color(0xFF800080);
      }
      if (pollutionLevel > 300) {
        pollutionLevelText = "Опасно";
        pollutionLevelColor = Color(0xFF4B0082);
      }
      if (iconRequest == "01d") {
        icon = Icon(WeatherIcons.day_sunny);
      }
      else if (iconRequest == "01n") {
        icon = Icon(WeatherIcons.night_clear);
      }
      else if (iconRequest == "02d") {
        icon = Icon(WeatherIcons.day_cloudy);
      }
      else if (iconRequest == "02d") {
        icon = Icon(WeatherIcons.night_cloudy);
      }
      else if (iconRequest == "03d" || iconRequest == "03n") {
        icon = Icon(WeatherIcons.cloud);
      }
      else if (iconRequest == "04d" || iconRequest == "04n") {
        icon = Icon(WeatherIcons.cloudy);
      }
      else if (iconRequest == "09d" || iconRequest == "09n") {
        icon = Icon(WeatherIcons.rain_wind);
      }
      else if (iconRequest == "10d") {
        icon = Icon(WeatherIcons.day_rain);
      }
      else if (iconRequest == "10d") {
        icon = Icon(WeatherIcons.night_rain);
      }
      else if (iconRequest == "11d" || iconRequest == "11n") {
        icon = Icon(WeatherIcons.storm_showers);
      }
      else if (iconRequest == "13d" || iconRequest == "13n") {
        icon = Icon(WeatherIcons.snow);
      }
      else if (iconRequest == "50d" || iconRequest == "50n") {
        icon = Icon(WeatherIcons.windy);
      }
      loading = true;
      // Печать данных в консоль
      print('City: $city');
      print('State: $state');
      print('Pollution Level: $pollutionLevel');
      print('Temperature: $temperature');
      print(iconRequest);
    } else {
      print('Error: ${response.reasonPhrase}');
    }
  }
}

