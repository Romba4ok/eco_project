import 'dart:convert';

import 'package:http/http.dart' as http;

void main() {
  final request = Requestcheck();
  request.exp();
}

class Requestcheck {
  final String API = "0f21dc0b-4bc6-46e2-85e0-57fbac370543";
  // final String State = "Almaty Qalasy";
  final String State = "Almaty Oblysy";
  final String Country = "Kazakhstan";
  // final String City = "Kaskelen";
  final String City = "Almaty";

  Future<void> fetchCountries() async {
    var url = Uri.parse('http://api.airvisual.com/v2/countries?key=$API');
    var request = http.MultipartRequest('GET', url);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print('Ошибка: ${response.reasonPhrase}');
    }
  }

  Future<void> country() async {
    var request = http.MultipartRequest('GET', Uri.parse('http://api.airvisual.com/v2/states?country=$Country&key=$API'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
    print(response.reasonPhrase);
    }
  }

  Future<void> state() async {
    var request = http.MultipartRequest('GET', Uri.parse('http://api.airvisual.com/v2/cities?state=$State&country=$Country&key=$API'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else
    print(response.reasonPhrase);
  }
  final String lan = "43.257259";
  final String lon = "76.93214";

  Future<void> cordinates() async {
    var request = http.Request('GET', Uri.parse('http://api.airvisual.com/v2/nearest_city?lat=$lan&lon=$lon&key=$API'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
    print(response.reasonPhrase);
    }
  }

  Future<void> city() async {
    var request = http.Request('GET', Uri.parse('http://api.airvisual.com/v2/nearest_city?lat=$lan&lon=$lon&key=$API'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      // Чтение тела ответа
      var responseBody = await response.stream.bytesToString();

      // Парсинг JSON
      var jsonData = json.decode(responseBody);

      // Доступ к данным
      var city = jsonData['data']['city'];
      var state = jsonData['data']['state'];
      var pollutionLevel = jsonData['data']['current']['pollution']['aqius'];
      var temperature = jsonData['data']['current']['weather']['tp'];

      print('Город: $city');
      print('Штат: $state');
      print('Уровень загрязнения (AQI): $pollutionLevel');
      print('Температура: $temperature°C');
    }
    else {
    print(response.reasonPhrase);
    }
  }
  Future<void> exp() async {
    // var request = http.MultipartRequest('GET', Uri.parse('http://api.airvisual.com/v2/states?country=$Country&key=$API'));
    // var request = http.MultipartRequest('GET', Uri.parse('http://api.airvisual.com/v2/cities?state=$State&country=$Country&key=$API'));
    // var request = http.Request('GET', Uri.parse('http://api.airvisual.com/v2/city?city=$City&state=$State&country=$Country&key=$API'));
    var request = http.Request('GET', Uri.parse('http://api.airvisual.com/v2/nearest_city?lat=$lan&lon=$lon&key=$API'));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      var responseBody = await response.stream.bytesToString();
      //
      // // Парсинг JSON
      var jsonData = json.decode(responseBody);
      //
      // // Доступ к данным
      // var city = jsonData['data']['city'];
      // var state = jsonData['data']['state'];
      var pollutionLevel = jsonData['data']['history'];
      // var temperature = jsonData['data']['current']['weather']['tp'];
      // print('Город: $city');
      // print('Штат: $state');
      print('Уровень загрязнения (AQI): $pollutionLevel');
      // print('Температура: $temperature°C');
    }
    else {
      print(response.reasonPhrase);
    }
  }
}