import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(MaterialApp(home: AlmatyAirQualityMap()));
}

class AlmatyAirQualityMap extends StatefulWidget {
  @override
  _AlmatyAirQualityMapState createState() => _AlmatyAirQualityMapState();
}

class _AlmatyAirQualityMapState extends State<AlmatyAirQualityMap> {
  List<Map<String, dynamic>> airQualityData = [];
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    generateRandomAirQualityData();
  }

  // Генерация случайных значений AQI
  void generateRandomAirQualityData() {

    List<LatLng> locations = [
      LatLng(43.2220, 76.8512), // Центр Алматы (Площадь Республики)
      LatLng(43.2455, 76.9182), // ВДНХ Алматы
      LatLng(43.2195, 76.8936), // Район Орбита
      LatLng(43.2357, 76.9094), // Ботанический сад
      LatLng(43.2565, 76.9281), // Район Мега Алматы
      LatLng(43.2705, 76.8906), // Первомайские пруды
    ];

    List<Map<String, dynamic>> results = locations.map((loc) {
      return {
        "lat": loc.latitude,
        "lng": loc.longitude,
        "aqi": random.nextInt(201), // Генерация случайного AQI от 0 до 200
      };
    }).toList();

    setState(() {
      airQualityData = results;
    });
  }

  // Функция для определения цвета маркера по AQI
  Color getAQIColor(int aqi) {
    if (aqi <= 50) {
      return Colors.green;
    } else if (aqi <= 100) {
      return Colors.yellow;
    } else if (aqi <= 150) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Карта загрязненности воздуха - Алматы")),
      body: airQualityData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(43.238949, 76.889709),
          initialZoom: 12.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: airQualityData.map((data) {
              return Marker(
                point: LatLng(data["lat"], data["lng"]),
                width: 40,
                height: 40,
                child: Container(
                  decoration: BoxDecoration(
                    color: getAQIColor(data["aqi"]),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
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
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
