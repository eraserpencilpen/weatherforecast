import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'dart:convert';

import 'package:weather/const.dart';

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
          Center(
            child: Text(
              cityName["city"].toString(),
              textScaler: TextScaler.linear(6),
            ),
          ),
          Center(
            child: Text(weatherData["hourly"]["temperature_2m"][time["hour"]]
                .toString()),
          ),
          Center(
            child: Text(
                "Feels like ${weatherData["hourly"]["apparent_temperature"][time["hour"]].toString()}"),
          ),
          Center(child: Builder(builder: (context) {
            String code =
                weatherData["hourly"]["weather_code"][time["hour"]].toString();
            double currentTime =
                time["hour"].toDouble() + time["minute"].toDouble();
            // var sunrise = weatherData["daily"]["sunrise"];
            // print(sunrise);
            // print(double.parse(time["minute"]));
            // double currentTime =
            //     double.parse(time["hour"]) * 60 + double.parse(time["minute"]);
            // var sunrise = weatherData["daily"]["sunrise"][0].substring(12, 16);
            // var sunset = weatherData["daily"]["sunrise"].substring(12, 16);
            // print(sunrise.toString());
            // print(sunset.toString());
            return Row();
            // if (){

            // }
          })),
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
  // https://timeapi.io/api/Time/current/coordinate?latitude=16.819171&longitude=96.158458
  return jsonDecode(response.body);
}

Future<dynamic> getLocation() async {
  LocationPermission permission = await Geolocator.requestPermission();
  if (permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse) {
    var position = await Geolocator.getCurrentPosition();
    return position;
  } else {
    return permission;
  }
}

Future<Map<String, dynamic>> getWeatherData(Position coordinates) async {
  String latitude = coordinates.latitude.toString();
  String longitude = coordinates.longitude.toString();
  final response = await http.get(Uri.parse(
      "https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&hourly=temperature_2m,relative_humidity_2m,precipitation_probability,weather_code,apparent_temperature&daily=sunrise,sunset"));

  // API Demo. Latitude longitude set to Bahan.
  // Time zone: GMT +6:30
  // https://api.open-meteo.com/v1/forecast?latitude=16.819171&longitude=96.158458&hourly=temperature_2m,relative_humidity_2m,precipitation_probability,weather_code,apparent_temperature&daily=sunrise,sunset

  return jsonDecode(response.body);
}

Future<Map<String, dynamic>> getCityName(Position coordinates) async {
  String latitude = coordinates.latitude.toString();
  String longitude = coordinates.longitude.toString();
  final response = await http.get(Uri.parse(
      "https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=$latitude&longitude=$longitude&localityLanguage=en"));

  return jsonDecode(response.body);
}
