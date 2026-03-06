import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/services/weather_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  TextEditingController cityController = TextEditingController();
  Map<String, dynamic>? weatherData;
  String _cityName = '';
  bool _isLoading = false;
  Future<void> searchWeather() async {
    final city = cityController.text.trim();
    if (city.isEmpty) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final service = WeatherService();
      final location = await WeatherService().getWeatherloc(city);
      final lat = location['latitude'];
      final lng = location['longitude'];
      final weather = await service.getWeatherCord(lat, lng);
      setState(() {
        weatherData = weather;
        _cityName = location['name'];
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather App"),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          TextField(controller: cityController),
          ElevatedButton(onPressed: searchWeather, child: Text("Search")),
          if (_isLoading) CircularProgressIndicator(),
          if (weatherData != null)
            Column(
              children: [
                Text(_cityName),
                Text(
                  "Temp: ${weatherData!['current_weather']['temperature']} C",
                ),
                Text("${weatherData!['current_weather']['windspeed']} km/h"),
              ],
            ),
        ],
      ),
    );
  }
}
