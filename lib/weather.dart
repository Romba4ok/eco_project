import 'dart:math';

import 'package:Eco/appSizes.dart';
import 'package:Eco/info.dart';
import 'package:Eco/map.dart';
import 'package:Eco/permission.dart';
import 'package:Eco/request.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:intl/intl.dart';

class WeatherPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final Random random = Random();
  List<Map<String, dynamic>> airQualityData = [];

  // Генерация случайных значений AQI
  void generateRandomAirQualityData() {
    List<LatLng> locations = [
      LatLng(43.2220, 76.8512), // Центр Алматы
      LatLng(43.2455, 76.9182), // ВДНХ
      LatLng(43.2195, 76.8936), // Орбита
      LatLng(43.2357, 76.9094), // Ботанический сад
      LatLng(43.2565, 76.9281), // Мега Алматы
      LatLng(43.2705, 76.8906), // Первомайские пруды
    ];

    List<Map<String, dynamic>> results = locations.map((loc) {
      return {
        "lat": loc.latitude,
        "lng": loc.longitude,
        "aqi": random.nextInt(201), // AQI от 0 до 200
      };
    }).toList();

    setState(() {
      airQualityData = results;
    });
  }

  // Цвет маркера в зависимости от AQI
  Color getAQIColor(int aqi) {
    if (aqi <= 50) return Colors.green;
    if (aqi <= 100) return Colors.yellow;
    if (aqi <= 150) return Colors.orange;
    return Colors.red;
  }

  ScrollController _scrollController =
      ScrollController(); // Контроллер для синхронизации
  String? state;
  String? time;
  String? ecoText;
  int? pollutionLevel;
  int? maxDayTemp;
  int? minNightTemp;
  bool loading = false;
  List<String> weekdaysRu = ["пн", "вт", "ср", "чт", "пт", "сб", "вс"];
  List<String> days = [];

  void dataRequest() {
    pollutionLevel = RequestCheck.pollutionLevel;
    ecoText = RequestCheck.pollutionLevelText;
    time = RequestCheck.time;
    state = RequestCheck.state;
    maxDayTemp = RequestCheck.forecastWeather.first["maxTemp"] ?? 0;
    minNightTemp = RequestCheck.forecastWeather.first["minTemp"] ?? 0;
  }

  Future<void> handlePermissionCheck() async {
    await AppPermission.checkAndRequestLocationPermission();
    await RequestCheck.init();
    if (mounted) {
      setState(() {
        dataRequest();
      });
    }
  }

  List filteredForecast = [];

  @override
  void initState() {
    super.initState();
    getUpcomingDays();
    loading = RequestCheck.loading;
    generateRandomAirQualityData();
    if (!loading) {
      handlePermissionCheck();
    } else {
      setState(() {
        dataRequest();
      });
    }

    DateTime now = DateTime.now();
    DateTime next24h = now.add(Duration(hours: 24));

    filteredForecast = RequestCheck.forecast.where((entry) {
      try {
        DateTime entryTime = DateTime.parse(entry['dt_txt'] ?? '');
        return entryTime.isAfter(now) && entryTime.isBefore(next24h);
      } catch (e) {
        return false;
      }
    }).toList();
    print(filteredForecast.length);
  }

  void getUpcomingDays() {
    DateTime today = DateTime.now();
    days = [weekdaysRu[today.weekday - 1]];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.width * 0.05),
              child: Column(
                children: [
                  SizedBox(height: AppSizes.height * 0.11),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: AppSizes.width * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BoxedIcon(
                            RequestCheck.getWeatherIcon(RequestCheck.icons[0]),
                            color: Colors.white,
                            size: AppSizes.width * 0.25),
                        Row(
                          children: [
                            Text("${RequestCheck.temperatures[0]}°",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: AppSizes.width * 0.18)),
                            SizedBox(width: AppSizes.width * 0.01),
                            Column(
                              children: [
                                Text(
                                    "${maxDayTemp ?? '-'}° / ${minNightTemp ?? '-'}°",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: AppSizes.width * 0.05)),
                                Text(
                                    "${days.isNotEmpty ? days[0] : '-'}, ${RequestCheck.time ?? '-'}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: AppSizes.width * 0.05)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSizes.height * 0.02),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black, // Цвет тени
                          blurRadius: 5, // Размытие тени
                          spreadRadius: 2, // Распределение тени
                          offset: Offset(0, 3), // Смещение тени вниз
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSizes.height * 0.02),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: AppSizes.width * 0.03),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.speed,
                                size: AppSizes.width * 0.08,
                                color: Colors.white),
                            SizedBox(width: AppSizes.height * 0.01),
                            Text("AQI",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: AppSizes.width * 0.05)),
                          ],
                        ),
                        Text(
                            "${ecoText ?? 'Неизвестно'} (${pollutionLevel ?? '-'})",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: AppSizes.width * 0.045)),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSizes.height * 0.02),
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: AppSizes.height * 0.03,
                        horizontal: AppSizes.width * 0.02),
                    decoration: BoxDecoration(
                      color: Color(0xFF1D1D1D),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      child: Column(
                        children: [
                          // Влажность воздуха
                          SizedBox(
                            width:
                                filteredForecast.length * AppSizes.width * 0.13,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: filteredForecast.map((data) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: AppSizes.height * 0.01),
                                  child: Row(
                                    children: [
                                      Icon(Icons.water_drop,
                                          size: AppSizes.width * 0.03,
                                          color: Color(0xFF414141)),
                                      Text(
                                        "${data['main']['humidity']}%",
                                        style: TextStyle(
                                          color: Color(0xFF9C9C9C),
                                          fontSize: AppSizes.width * 0.035,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(height: AppSizes.height * 0.01),

                          // График температуры
                          SizedBox(
                            height: AppSizes.height * 0.07,
                            width:
                                filteredForecast.length * AppSizes.width * 0.12,
                            child: LineChart(
                              LineChartData(
                                minY: filteredForecast
                                        .map(
                                            (e) => e['main']['temp'].toDouble())
                                        .reduce((a, b) => a < b ? a : b) -
                                    2,
                                maxY: filteredForecast
                                        .map(
                                            (e) => e['main']['temp'].toDouble())
                                        .reduce((a, b) => a > b ? a : b) +
                                    2,
                                gridData: FlGridData(show: false),
                                titlesData: FlTitlesData(show: false),
                                borderData: FlBorderData(show: false),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: filteredForecast
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      int index = entry.key;
                                      var data = entry.value;
                                      return FlSpot(index.toDouble(),
                                          data['main']['temp'].toDouble());
                                    }).toList(),
                                    isCurved: true,
                                    color: Colors.white,
                                    barWidth: 2,
                                    isStrokeCapRound: true,
                                    belowBarData: BarAreaData(show: false),
                                    dotData: FlDotData(show: true),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: AppSizes.height * 0.02),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: filteredForecast.map((data) {
                                String formattedTime = "--:--";
                                try {
                                  formattedTime = DateFormat.Hm().format(
                                      DateTime.parse(data['dt_txt'] ??
                                          '2000-01-01T00:00:00'));
                                } catch (_) {}

                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: AppSizes.height * 0.01),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("${data['main']['temp'].round()}°",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: AppSizes.width * 0.05)),
                                      SizedBox(height: AppSizes.height * 0.01),
                                      BoxedIcon(
                                          RequestCheck.getWeatherIcon(
                                              data['weather'][0]['icon']),
                                          size: AppSizes.width * 0.06,
                                          color: Colors.white),
                                      SizedBox(height: AppSizes.height * 0.01),
                                      Text(formattedTime,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: AppSizes.width * 0.04)),
                                      SizedBox(height: AppSizes.height * 0.01),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: AppSizes.height * 0.02),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF1E1E1E),
                      borderRadius:
                          BorderRadius.circular(AppSizes.width * 0.02),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // Выровнять всё влево
                      children: RequestCheck.forecastWeather.map((day) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: AppSizes.height * 0.01,
                              horizontal: AppSizes.width * 0.01),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // Выровнять элементы по центру
                            mainAxisAlignment: MainAxisAlignment.start,
                            // Выровнять всё влево
                            children: [
                              // ✅ День недели (фиксированная ширина)
                              SizedBox(
                                width: AppSizes.width * 0.19,
                                // Чтобы все дни недели были одинаковой ширины
                                child: Text(
                                  day["dayOfWeek"] ?? "—",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: AppSizes.width * 0.04,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),

                              SizedBox(width: AppSizes.width * 0.03), // Отступ

                              // ✅ Влажность (фиксированная ширина)
                              SizedBox(
                                width: AppSizes.width * 0.11,
                                child: Row(
                                  children: [
                                    Icon(Icons.water_drop,
                                        color: Colors.grey,
                                        size: AppSizes.width * 0.04),
                                    SizedBox(width: 4),
                                    Text(
                                      "${day["avgHumidity"] ?? 0}%",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(width: AppSizes.width * 0.03), // Отступ

                              // ✅ Иконка дневной погоды
                              SizedBox(
                                width: AppSizes.width * 0.11,
                                child: BoxedIcon(
                                  RequestCheck.getWeatherIcon(
                                      day["dayIcon"] ?? ""),
                                  color: Colors.white,
                                ),
                              ),

                              SizedBox(width: AppSizes.width * 0.03), // Отступ

                              // ✅ Иконка ночной погоды
                              SizedBox(
                                width: AppSizes.width * 0.11,
                                child: BoxedIcon(
                                  RequestCheck.getWeatherIcon(
                                      day["nightIcon"] ?? ""),
                                  color: Colors.white,
                                ),
                              ),

                              SizedBox(width: AppSizes.width * 0.03), // Отступ
                              Expanded(
                                child: Text(
                                  "${day["maxTemp"] ?? "—"}° / ${day["minTemp"] ?? "—"}°",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: AppSizes.width * 0.04),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: AppSizes.height * 0.02),
                  // Замените текущий блок на этот

                  SizedBox(height: AppSizes.height * 0.02),
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: AppSizes.height * 0.03,
                        horizontal: AppSizes.width * 0.01),
                    decoration: BoxDecoration(
                      color: Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Восход",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: AppSizes.width * 0.05),
                            ),
                            Text(
                              "${RequestCheck.sunriseTime?.hour ?? 0}:"
                              "${RequestCheck.sunriseTime?.minute ?? 0}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: AppSizes.width * 0.05,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: AppSizes.height * 0.02),
                            Image.asset(
                              'assets/images/sunrise.png',
                              // Путь к вашему изображению
                              width: AppSizes.width * 0.3,
                              height: AppSizes.height * 0.07,
                              fit: BoxFit
                                  .cover, // Как изображение должно вписываться
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Закат",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: AppSizes.width * 0.05),
                            ),
                            Text(
                              "${RequestCheck.sunsetTime?.hour ?? 0}:"
                              "${RequestCheck.sunsetTime?.minute ?? 0}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: AppSizes.width * 0.05,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: AppSizes.height * 0.02),
                            Image.asset(
                              'assets/images/sunset.png',
                              // Путь к вашему изображению
                              width: AppSizes.width * 0.3,
                              height: AppSizes.height * 0.07,
                              fit: BoxFit
                                  .cover, // Как изображение должно вписываться
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSizes.height * 0.02),
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: AppSizes.height * 0.03,
                        horizontal: AppSizes.width * 0.04),
                    decoration: BoxDecoration(
                      color: Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "AQI Карта",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: AppSizes.width * 0.055,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: AppSizes.height * 0.01),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AlmatyAirQualityMap()),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              height: AppSizes.height * 0.2, // Маленькая карта
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white, width: 2)),
                              child: FlutterMap(
                                options: MapOptions(
                                  initialCenter: LatLng(43.238949, 76.889709),
                                  initialZoom: 10.5,
                                  onTap: (_, __) {
                                    // 👉 Добавляем обработчик клика прямо на карте
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AlmatyAirQualityMap()),
                                    );
                                  },
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    subdomains: ['a', 'b', 'c'],
                                  ),
                                  MarkerLayer(
                                    markers: airQualityData.map((data) {
                                      return Marker(
                                        point: LatLng(data["lat"], data["lng"]),
                                        width: 25,
                                        height: 25,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: getAQIColor(data["aqi"]),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 2,
                                                spreadRadius: 1,
                                              ),
                                            ],
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "${data["aqi"]}",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSizes.height * 0.03),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Padding(
                padding: EdgeInsets.only(
                  top: AppSizes.height * 0.01,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on,
                        size: AppSizes.width * 0.05, color: Colors.white),
                    Text(
                      state ?? "Неизвестно",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: AppSizes.width * 0.05),
                    ),
                    SizedBox(
                      width: AppSizes.width * 0.05,
                    ),
                  ],
                ),
              ),
              centerTitle: true,
              leading: Padding(
                padding: EdgeInsets.only(
                  top: AppSizes.height * 0.01,
                  left: AppSizes.width * 0.03,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: AppSizes.width * 0.08,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
