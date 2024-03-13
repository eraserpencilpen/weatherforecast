// import 'package:flutter/material.dart';
// import 'home.dart';
import 'package:http/http.dart' as http;
import 'const.dart';
import 'dart:io';
import 'dart:convert';

void main() async {
  final response = await http.get(Uri.parse(
      "https://api.open-meteo.com/v1/forecast?latitude=16.819216322979972&longitude=96.15838214867654&hourly=temperature_2m,relative_humidity_2m,precipitation_probability,weather_code"));
  Map<dynamic, dynamic> weatherData = jsonDecode(response.body);
  print(weatherData["hourly"]["temperature_2m"][19]);
}

