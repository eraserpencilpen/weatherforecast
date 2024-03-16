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
  Map<String, dynamic> weatherData = {};
  Map<String, dynamic> time = {};
  Map<String, dynamic> cityName = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation().then((value) {
      if (value.runtimeType == Position) {
        print(value.toString());

        getTime(value);
        setState(() {
          weatherData = getWeatherData(value);
          time = getTime(value);
          cityName = getCityName(value);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Text(
              "Yangon",
              textScaler: TextScaler.linear(6),
            ),
          ),
          // Center(child: ,)
        ],
      ),
    );
  }
}

getTime(currentLocation) async {
  String latitude = currentLocation.latitude.toString();
  String longitude = currentLocation.longitude.toString();
  print(latitude);
  print(longitude);
  final response = await http.get(Uri.parse(
      "https://timeapi.io/api/Time/current/coordinate?latitude=$latitude&longitude=$longitude"));
  print(response.body);
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

getWeatherData(Position coordinates) async {
  String latitude = coordinates.latitude.toString();
  String longitude = coordinates.longitude.toString();
  final response = await http.get(Uri.parse(
      "https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&hourly=temperature_2m,relative_humidity_2m,precipitation_probability,weather_code"));

  return jsonDecode(response.body);
}

getCityName(Position coordinates) async {
  String latitude = coordinates.latitude.toString();
  String longitude = coordinates.longitude.toString();
  final response = await http.get(Uri.parse(
      "https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=$latitude&longitude=$longitude&localityLanguage=en"));

  return jsonDecode(response.body);
}
