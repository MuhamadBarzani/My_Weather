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
  final String apikey = "768c1f4d474d3dc010d3d5a0849e8bc5";
  Future<Map<String, dynamic>> getWeatherData() async {
    try {
      const String cityName = "Erbil";
      final weatherJson = await http.get(Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$apikey"));
      final weatherData = jsonDecode(weatherJson.body);
      if (weatherJson.statusCode != 200) {
        throw weatherData['status code error'];
      }
      return weatherData;
    } catch (e) {
      print(e.toString());
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
                setState(() {});
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder(
        future: getWeatherData(),
        builder: (context, snapshot) {
          bool connection = true;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            connection = false;
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
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
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
                                Text(
                                  "$currentTemp°",
                                  style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 12),
                                Icon(
                                  currentSky == "Clouds" || currentSky == "Rain"
                                      ? Icons.cloud
                                      : Icons.sunny,
                                  size: 66,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  currentSky,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Hourly Forecast",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 125,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 6,
                      itemBuilder: (context, i) {
                        final time =
                            DateTime.parse(data['list'][i + 1]['dt_txt']);
                        return HourlyCard(
                            time: DateFormat.j().format(time),
                            icon: data["list"][i + 1]["weather"][0]["main"] ==
                                        "Clouds" ||
                                    data["list"][i + 1]["weather"][0]["main"] ==
                                        "Rain"
                                ? Icons.cloud
                                : Icons.sunny,
                            temp:
                                "${(data["list"][i + 1]["main"]["temp"] - 273.15).toString().substring(0, 2)}°");
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Additional Information",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AddInfoCard(
                        icon: Icons.water_drop,
                        label: "humidity",
                        value: currentHumidity,
                      ),
                      AddInfoCard(
                        icon: Icons.air,
                        label: "Wind Speed",
                        value: windSpeed,
                      ),
                      AddInfoCard(
                        icon: Icons.beach_access,
                        label: "Pressure",
                        value: currentPressure,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  if (!connection) const Text("No Connection")
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
