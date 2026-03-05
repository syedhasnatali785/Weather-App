import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

late Future<Map<String, dynamic>> weatherFuture;
Future<Map<String, dynamic>> getWeatherApi() async {
  final response = await http.get(
    Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&hourly=temperature_2m&current_weather=true',
    ),
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Error');
  }
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    weatherFuture = getWeatherApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: weatherFuture,
        builder: (context, AsyncSnapshot snapshot) {
          final weatherData = snapshot.data;
          return Column(
            children: [
              Text(weatherData['current_weather']),
              Text("Lahore"),
              Text("Lahore"),
              Row(
                children: [
                  TextField(),
                  ElevatedButton(onPressed: () {}, child: Text("Search")),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
