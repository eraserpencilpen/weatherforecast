// import 'package:flutter/material.dart';
// import 'home.dart';
import 'package:http/http.dart' as http;
import 'const.dart';
import 'dart:io';
import 'dart:convert';

void main() async {

  final response = await http.get(Uri.parse(
      "https://api.open-meteo.com/v1/forecast?latitude=16.819216322979972&longitude=96.15838214867654&hourly=temperature_2m,relative_humidity_2m,precipitation_probability,weather_code"));
  String path =
      r"C:\Users\User\OneDrive\Desktop\Weather Forecast\weather\assets\wc_images";
  weatherCodes.forEach((key, value) {
    value["day"]["image"] = "$path\\wc_${key}_day.png";
    value["night"]["image"] = "$path\\wc_${key}_night.png";
  });
  var myFile =
      File("file.json").writeAsString(jsonEncode(weatherCodes).toString());
}
