import 'dart:math';

import 'package:Eco/appSizes.dart';
import 'package:Eco/info.dart';
import 'package:Eco/map.dart';
import 'package:Eco/permission.dart';
import 'package:Eco/request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:weather_icons/weather_icons.dart';

class RecomendationsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RecomendationsPageState();
}

class _RecomendationsPageState extends State<RecomendationsPage> {
  String? state;
  bool loading = false;
  int? pollutionLevel;
  int? temperature;
  double? windSpeed;
  Color? pollutionLevelColor;
  bool isLoading = true;
  String? pollutionLevelText;
  List<(IconData icon, String text, Color color)> recommendations = [];
  final Random random = Random();
  List<Map<String, dynamic>> airQualityData = [];

  void dataRequest() {
    state = RequestCheck.state;
    pollutionLevel = RequestCheck.pollutionLevel;
    temperature = DateTime.now().hour >= 6 && DateTime.now().hour < 18
        ? RequestCheck.forecastWeather[0]["maxTemp"]
        : RequestCheck.forecastWeather[0]["minTemp"];
    pollutionLevelColor = RequestCheck.pollutionLevelColor;
    windSpeed = RequestCheck.windSpeedList[0];
    pollutionLevelText = RequestCheck.pollutionLevelText;
    recommendations = RequestCheck.recommendations;
    isLoading = false;
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

  @override
  void initState() {
    super.initState();
    loading = RequestCheck.loading;
    generateRandomAirQualityData();
    if (!loading) {
      handlePermissionCheck();
    } else {
      setState(() {
        dataRequest();
      });
    }
  }

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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Container(
          width: AppSizes.width,
          height: AppSizes.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/app/loadPage.png'),
              // Путь к изображению
              fit: BoxFit.cover, // Растянуть изображение на весь контейнер
            ),
          ),
          child: Center(
            child: Container(
              width: AppSizes.width * 0.4,
              height: AppSizes.height * 0.35,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/app/loadLogo.png'),
                  // Путь к изображению
                  fit: BoxFit.cover, // Растянуть изображение на весь контейнер
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.width * 0.05),
              child: Column(
                children: [
                  SizedBox(height: AppSizes.height * 0.1),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF1D1D1D),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: AppSizes.height * 0.03),
                        Stack(
                          children: [
                            Container(
                              height: AppSizes.height * 0.25,
                              // Убедитесь, что высота точно ограничена
                              child: SfRadialGauge(
                                axes: <RadialAxis>[
                                  RadialAxis(
                                    minimum: 0,
                                    maximum: 300,
                                    startAngle: 160,
                                    endAngle: 20,
                                    showLabels: false,
                                    showTicks: false,
                                    axisLineStyle: AxisLineStyle(
                                      thickness: 24,
                                      cornerStyle: CornerStyle.bothCurve,
                                      color: Colors.white,
                                    ),
                                    pointers: <GaugePointer>[
                                      RangePointer(
                                        value: (pollutionLevel ?? 1).toDouble(),
                                        width: 24,
                                        cornerStyle: CornerStyle.bothCurve,
                                        color: pollutionLevelColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: AppSizes.height * 0.06,
                              left: 0,
                              right: 0,
                              child: Column(
                                children: [
                                  Text(
                                    '$pollutionLevel',
                                    style: TextStyle(
                                      fontSize: AppSizes.width * 0.13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'AQI',
                                    style: TextStyle(
                                      fontSize: AppSizes.width * 0.06,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: AppSizes.height * 0.18,
                              left: 0,
                              right: 0,
                              child: Column(
                                children: [
                                  Text(
                                    '$pollutionLevelText',
                                    style: TextStyle(
                                      fontSize: AppSizes.width * 0.05,
                                      color: pollutionLevelColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: AppSizes.height * 0.22,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.water_drop,
                                    size: AppSizes.width * 0.05,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    '${RequestCheck.forecast[0]['pop'] * 100}%',
                                    style: TextStyle(
                                      fontSize: AppSizes.width * 0.05,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: AppSizes.width * 0.03,
                                  ),
                                  BoxedIcon(
                                    RequestCheck.getWeatherIcon(
                                        RequestCheck.icons[0]),
                                    color: Colors.white,
                                    size: AppSizes.width * 0.05,
                                  ),
                                  Text(
                                    "${RequestCheck.temperatures[0]}°",
                                    style: TextStyle(
                                      fontSize: AppSizes.width * 0.05,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: AppSizes.width * 0.03,
                                  ),
                                  Icon(
                                    WeatherIcons.sandstorm,
                                    size: AppSizes.width * 0.05,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: AppSizes.width * 0.02,
                                  ),
                                  Text(
                                    '$windSpeedм/с',
                                    style: TextStyle(
                                      fontSize: AppSizes.width * 0.05,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: AppSizes.height * 0.02,
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF1D1D1D),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "ПОЛЕЗНЫЙ СОВЕТ",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: AppSizes.width * 0.04),
                        ),
                        Divider(
                          color: Color(0xFF222222),
                        ),
                        SizedBox(
                          height: AppSizes.height * 0.3,
                          child: IgnorePointer(
                            child: ListView.builder(
                            itemCount: recommendations.length,
                            itemBuilder: (context, index) {
                              final (icon, text, color) = recommendations[
                                  index]; // Деструктуризация кортежа
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(icon,
                                          color: color,
                                          size: AppSizes.width * 0.1),
                                      SizedBox(
                                        width: AppSizes.width * 0.03,
                                      ),
                                      Text(
                                        text,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: AppSizes.width * 0.035),
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: AppSizes.height * 0.01,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),),
                        SizedBox(
                          height: AppSizes.height * 0.1,
                        ),
                        Text(
                          "КАРТА",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: AppSizes.width * 0.04),
                        ),
                        Divider(
                          color: Color(0xFF222222),
                        ),
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
                        SizedBox(
                          height: AppSizes.height * 0.03,
                        ),
                      ],
                    ),
                  ),
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
                    Route route =
                        MaterialPageRoute(builder: (context) => PageInfo());
                    Navigator.pushReplacement(context, route);
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
