import 'package:dashboard/model/API_KEYS.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Weather {
  String value;
  String description;
  String place;
  double temperature;
  int responseCode;
  double wind;

  Future fetchFiveDayForecast(cityName) async {
    value = cityName;
    final String url =
        "http://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$WEATHER_MAP_KEY&units=metric";
    var response = await http.get(url);

    responseCode = response.statusCode;
    if (responseCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      description = jsonResponse['list'][0]['weather'][0]['description'];
      place = jsonResponse['city']['name'];
      temperature = jsonResponse['list'][0]['main']['temp'];
      wind = jsonResponse['list'][0]['wind']['speed'];
      print(
          'The sky in five days will be is: $description. and name is: $place ant temp = $temperature, this forecast will be for $wind m/s');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future fetchWeather(cityName) async {
    value = cityName;
    final String url =
        "http://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$WEATHER_MAP_KEY&units=metric";
    var response = await http.get(url);

    responseCode = response.statusCode;
    if (responseCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      description = jsonResponse['weather'][0]['description'];
      place = jsonResponse['name'];
      temperature = jsonResponse['main']['temp'];

      print(
          'The sky is: $description. and name is: $place ant temp = $temperature');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Map<String, dynamic> getWeather() {
    return {
      'type': 'weather',
      'value': value,
      'responseCode': responseCode,
      'description': description,
      'place': place,
      'temperature': temperature
    };
  }

  Map<String, dynamic> getFiveDayForecast() {
    return {
      'type': 'weather5days',
      'value': value,
      'responseCode': responseCode,
      'description': description,
      'place': place,
      'temperature': temperature,
      'wind': wind
    };
  }
}
