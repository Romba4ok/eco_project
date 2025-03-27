import 'package:Eco/appSizes.dart';
import 'package:Eco/info.dart';
import 'package:Eco/permission.dart';
import 'package:Eco/request.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:intl/intl.dart';

class WeatherPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
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
    maxDayTemp = RequestCheck.getMaxDayTemperature();
    minNightTemp = RequestCheck.getMinNightTemperature();
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
  }

  void getUpcomingDays() {
    DateTime today = DateTime.now();
    days = [weekdaysRu[today.weekday - 1]];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.width * 0.05),
          child: Column(
            children: [
              SizedBox(height: AppSizes.height * 0.07),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: Colors.white, size: AppSizes.width * 0.08),
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => PageInfo()));
                    },
                  ),
                  Expanded(
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
                ],
              ),
              SizedBox(height: AppSizes.height * 0.02),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: AppSizes.width * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(RequestCheck.iconList[0],
                        color: Colors.white, size: AppSizes.width * 0.25),
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
                            size: AppSizes.width * 0.08, color: Colors.white),
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
                        width: filteredForecast.length * AppSizes.width * 0.13,
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
                        width: filteredForecast.length * AppSizes.width * 0.12,
                        child: LineChart(
                          LineChartData(
                            minY: filteredForecast
                                    .map((e) => e['main']['temp'].toDouble())
                                    .reduce((a, b) => a < b ? a : b) -
                                2,
                            maxY: filteredForecast
                                    .map((e) => e['main']['temp'].toDouble())
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
                                  DateTime.parse(
                                      data['dt_txt'] ?? '2000-01-01T00:00:00'));
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
          RequestCheck.forecastWeather.isEmpty
              ? Center(
            child: Text("Нет данных", style: TextStyle(color: Colors.white)),
          )
              : Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: RequestCheck.forecastWeather.take(5).map((day) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // День недели
                      Text(
                        day["dayOfWeek"] ?? "—",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),

                      // Влажность
                      Row(
                        children: [
                          Icon(Icons.water_drop, color: Colors.grey, size: 16),
                          SizedBox(width: 4),
                          Text("${day["avgHumidity"] ?? 0}%",
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),

                      // Иконка дневной погоды
                      BoxedIcon(
                        RequestCheck.getWeatherIcon(day["dayIcon"] ?? ""),
                        color: Colors.yellow,
                      ),

                      // Иконка ночной погоды
                      BoxedIcon(
                        RequestCheck.getWeatherIcon(day["nightIcon"] ?? ""),
                        color: Colors.blue,
                      ),

                      // Температура
                      Text(
                        "${day["maxTemp"] ?? "—"}° / ${day["minTemp"] ?? "—"}°",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
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
    );
  }
}
