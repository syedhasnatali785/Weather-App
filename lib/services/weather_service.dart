import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherService {


  Future<Map<String, dynamic>> getWeatherloc(String city) async {
    final response = await http.get(
      Uri.https('https://geocoding-api.open-meteo.com', '/v1/search', {
        'name': city,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'] == null) {
        throw Exception("No results");
      }
      return data['results'][0];
    } else {
      throw Exception('API error');
    }
  }

  Future<Map<String, dynamic>> getWeatherCord(double lat,double lng) async {
    final response = await http.get(
      Uri.https('api.open-meteo.com', '/v1/forecast', {
        'latitude': lat.toString(),
        'longitude': lng.toString(),
        'current_weather': 'true',
      }),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error');
    }
  }
}
