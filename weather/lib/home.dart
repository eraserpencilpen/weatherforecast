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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation().then((value) {
      if (value.runtimeType == Position) {
        getTime(value);

        setState(() {
          getWeatherData(value).then((data) {
            setState(() {
              weatherData = data;
            });
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
          Center(
              child: Container(
                  child: Text(
            "Yangon",
          ))),
          Center(
            child: Container(
                child: Text(
                    weatherData["hourly"]["temperature_2m"][15].toString())),
          ),
        ],
      );
    } else {
      return Center(child: const CircularProgressIndicator());
    }
  }
}

void getTime(currentLocation) async {
  double latitude = currentLocation.latitude;
  double longitude = currentLocation.longitude;
  var a = latitude.toString();
  var b = longitude.toString();
  print(latitude);
  print(longitude);
  final response = await http.get(Uri.parse(
      "https://timeapi.io/api/Time/current/coordinate?latitude=" +
          a +
          "&longitude=" +
          b));
  print(response.body);
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
      "https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&hourly=temperature_2m,relative_humidity_2m,precipitation_probability,weather_code"));

  return jsonDecode(response.body);
}
