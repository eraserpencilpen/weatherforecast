import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WeatherWidget(),
    );
  }
}

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  Map<String, dynamic> weatherData = {};
  Map<String, dynamic> time = {};
  Map<String, dynamic> cityName = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation().then((value) {
      if (value.runtimeType == Position) {
        getWeatherData(value).then((data) {
          setState(() {
            weatherData = data;
          });
        });
        getTime(value).then((data) {
          setState(() {
            time = data;
          });
        });
        getCityName(value).then((data) {
          setState(() {
            cityName = data;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (weatherData.isNotEmpty) {
      return Column(
        children: [
          const Center(
            child: Text(
              "Yangon",
              textScaler: TextScaler.linear(6),
            ),
          ),
          Center(
            child: Text(weatherData["hourly"]["temperature_2m"][time["hour"]]
                .toString()),
          ),
          Center(
            child: Text(
                "Feels like ${weatherData["hourly"]["temperature_2m"][time["hour"]].toString()}"),
          ),
          Center(
            child: Row(
              children: [
                Builder(builder: (context) {
                  // To-do night and day image change
                  return Image.asset(
                      weatherData["hourly"]["weather_code"][time["hour"]]);
                }),
                Text()
              ],
            ),
          ),
          Container(
            child: Column(
              children: [],
            ),
          )
        ],
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}

Future<Map<String, dynamic>> getTime(currentLocation) async {
  double latitude = currentLocation.latitude;
  double longitude = currentLocation.longitude;
  var a = latitude.toString();
  var b = longitude.toString();
  final response = await http.get(Uri.parse(
      "https://timeapi.io/api/Time/current/coordinate?latitude=$latitude&longitude=$longitude"));
  return jsonDecode(response.body);
}

Future<dynamic> getLocation() async {
  LocationPermission permission = await Geolocator.requestPermission();
  if (permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse) {
    print("We got Access!");
    var position = await Geolocator.getCurrentPosition();
    return position;
  } else {
    print("Request Access");
    return permission;
  }
}

Future<Map<String, dynamic>> getWeatherData(Position coordinates) async {
  String latitude = coordinates.latitude.toString();
  String longitude = coordinates.longitude.toString();
  final response = await http.get(Uri.parse(
      "https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&hourly=temperature_2m,relative_humidity_2m,precipitation_probability,weather_code,apparent_temperature&daily=sunrise,sunset"));

  return jsonDecode(response.body);
}

Future<Map<String, dynamic>> getCityName(Position coordinates) async {
  String latitude = coordinates.latitude.toString();
  String longitude = coordinates.longitude.toString();
  final response = await http.get(Uri.parse(
      "https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=$latitude&longitude=$longitude&localityLanguage=en"));

  return jsonDecode(response.body);
}
