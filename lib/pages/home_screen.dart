import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:myweather/pages/mywidgets/addinfocard.dart';
import 'package:myweather/pages/mywidgets/hourlycards.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String apiKey = "768c1f4d474d3dc010d3d5a0849e8bc5";
  late Future<Map<String, dynamic>> weatherData;

  @override
  void initState() {
    super.initState();
    weatherData = getWeatherData();
  }

  Future<Map<String, dynamic>> getWeatherData() async {
    const String cityName = "Erbil";
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$apiKey"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Weather Erbil",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weatherData = getWeatherData(); // Refresh data on button press
              });
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: weatherData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final data = snapshot.data!;
          final currentWeatherData = data["list"][0];
          final currentTemp =
              (currentWeatherData["main"]["temp"] - 273.15).truncate();
          final currentSky = currentWeatherData["weather"][0]["main"];
          final currentHumidity =
              currentWeatherData["main"]["humidity"].toString();
          final windSpeed = currentWeatherData["wind"]["speed"].toString();
          final currentPressure =
              currentWeatherData["main"]["pressure"].toString();

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildCurrentWeatherCard(currentTemp, currentSky),
                  const SizedBox(height: 16),
                  const Text("Hourly Forecast",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  buildHourlyForecast(data),
                  const SizedBox(height: 16),
                  const Text("Additional Information",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  buildAdditionalInfo(
                      currentHumidity, windSpeed, currentPressure),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildCurrentWeatherCard(int currentTemp, String currentSky) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        shadowColor: Colors.black,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text("$currentTemp°",
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Icon(
                    currentSky == "Clouds" || currentSky == "Rain"
                        ? Icons.cloud
                        : Icons.sunny,
                    size: 66,
                  ),
                  const SizedBox(height: 12),
                  Text(currentSky, style: const TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHourlyForecast(Map<String, dynamic> data) {
    return SizedBox(
      height: 125,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (context, i) {
          final time = DateTime.parse(data['list'][i + 1]['dt_txt']);
          return HourlyCard(
            time: DateFormat.j().format(time),
            icon: data["list"][i + 1]["weather"][0]["main"] == "Clouds" ||
                    data["list"][i + 1]["weather"][0]["main"] == "Rain"
                ? Icons.cloud
                : Icons.sunny,
            temp:
                "${(data["list"][i + 1]["main"]["temp"] - 273.15).toStringAsFixed(0)}°",
          );
        },
      ),
    );
  }

  Widget buildAdditionalInfo(
      String currentHumidity, String windSpeed, String currentPressure) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        AddInfoCard(
            icon: Icons.water_drop, label: "Humidity", value: currentHumidity),
        AddInfoCard(icon: Icons.air, label: "Wind Speed", value: windSpeed),
        AddInfoCard(
            icon: Icons.beach_access,
            label: "Pressure",
            value: currentPressure),
      ],
    );
  }
}
