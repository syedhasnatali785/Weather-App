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
  late Future<Map<String, dynamic>> weatherFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    weatherFuture = WeatherService().getWeather();
  }

  TextEditingController cityController = TextEditingController();
  Map<String, dynamic>? weatherData;
  String cityname = '';
  bool loading = false;
  Future<void> searchWeather() async {
    final city = cityController.text.trim();
    if (city.isEmpty) {
      return;
    }
    setState(() {
      loading = true;
    });
    try {
      final service = WeatherService();
      final location = await WeatherService().getWeatherloc(city);
      final lat = location['latitude'];
      final lng = location['longitude'];
      final weather = await service.getWeatherCord(lat, lng);
      setState(() {
        weatherData = weather;
        cityname = location['name'];
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() {
      loading = false;
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
          if (loading) CircularProgressIndicator(),
          if (weatherData != null)
            Column(
              children: [
                Text(cityname),
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
