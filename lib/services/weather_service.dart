import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_model.dart';

class WeatherService {
  String baseUrl = 'http://api.weatherapi.com/v1';
  String appKey = 'bebed321581a4ef59fd170300230203';

  Future<int> getCityId({required String cityName}) async {
    Uri url = Uri.parse('$baseUrl/search.json?key=$appKey&q=$cityName&days=7');
    http.Response response = await http.get(url);
    print(response.body);
    List<dynamic> data = jsonDecode(response.body);

    int cityId = data[0]['woeid'];

    return cityId;
  }

  Future<WeatherModel?> getWeather({required String cityName}) async {
    WeatherModel? weatherData;
    try {
      int id = await getCityId(cityName: cityName);

      Uri url = Uri.parse('$baseUrl/api/location/$id/');
      http.Response response = await http.get(url);

      Map<String, dynamic> jsonData = jsonDecode(response.body);

      Map<String, dynamic> data = jsonData['consolidated_weather'][0];

      weatherData = WeatherModel.fromJson(data);
    } catch (e) {
      print(e);
    }

    return weatherData;
  }
}
