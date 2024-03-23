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
        getTimeZone(value).then((timezone) {
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
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (weatherData.isNotEmpty && time.isNotEmpty && cityName.isNotEmpty) {
      String code =
          weatherData["hourly"]["weather_code"][time["hour"]].toString();
      double currentTime =
          time["hour"].toDouble() * 60 + time["minute"].toDouble();
      String sunrise_hour =
          weatherData["daily"]["sunrise"][0].substring(11, 13);
      String sunrise_minute =
          weatherData["daily"]["sunrise"][0].substring(14, 16);
      double sunrise =
          double.parse(sunrise_hour) * 60 + double.parse(sunrise_minute);
      String sunset_hour = weatherData["daily"]["sunset"][0].substring(11, 13);
      String sunset_minute =
          weatherData["daily"]["sunset"][0].substring(14, 16);
      double sunset =
          double.parse(sunset_hour) * 60 + double.parse(sunset_minute);
      return ListView(
        children: [
          Center(
            child: Text(
              cityName["city"].toString(),
              textScaler: const TextScaler.linear(2),
            ),
          ),
          Center(
            child: Text(
              weatherData["hourly"]["temperature_2m"][time["hour"]].toString(),
              textScaler: const TextScaler.linear(6),
            ),
          ),
          Center(
            child: Text(
              "Feels like ${weatherData["hourly"]["apparent_temperature"][time["hour"]].toString()}",
              textScaler: const TextScaler.linear(2),
            ),
          ),
          Builder(builder: (context) {
            if (currentTime <= sunset && currentTime >= sunrise) {
              return Center(
                child: Row(children: [
                  Image.asset(weatherCodes[code]["day"]["image"]),
                  Text(weatherCodes[code]["day"]["description"])
                ]),
              );
            } else {
              return Center(
                child: Row(
                  children: [
                    Image.asset(weatherCodes[code]["night"]["image"]),
                    Text(weatherCodes[code]["night"]["description"])
                  ],
                ),
              );
            }
            // if (){

            // }
          }),
          SizedBox(
            height: 500,
            width: MediaQuery.of(context).size.width * 0.75,
            child: Card(
              child: ListView.builder(
                  itemCount: 10,
                  shrinkWrap: true,
                  itemBuilder: ((context, index) {
                    return Row(
                      children: [
                        Text((time["hour"] + index * 2).toString() + ":00"),
                        Builder(builder: (context) {
                          if (currentTime <= sunset && currentTime >= sunrise) {
                            return Center(
                              child: Row(children: [
                                Image.asset(weatherCodes[code]["day"]["image"]),
                              ]),
                            );
                          } else {
                            return Center(
                              child: Row(
                                children: [
                                  Image.asset(
                                      weatherCodes[code]["night"]["image"]),
                                ],
                              ),
                            );
                          }
                        }),
                        Text(weatherData["hourly"]["temperature_2m"]
                                    [time["hour"]]
                                .toString() +
                            "°C"),
                        Text(weatherData["hourly"]["precipitation_probability"]
                                    [time["hour"]]
                                .toString() +
                            "%")
                      ],
                    );
                  })),
            ),
          ),
          Card(
              child: ListView.builder(
                  itemCount: 7,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        Text("${index.toString()}"),
                        Builder(builder: (context) {
                          String dailyCode = weatherData["daily"]
                                  ["weather_code"][index]
                              .toString();
                          print(dailyCode);
                          if (currentTime >= sunrise && currentTime <= sunset) {
                            return Image.asset(
                                weatherCodes[dailyCode]["day"]["image"]);
                          } else {
                            return Image.asset(
                                weatherCodes[dailyCode]["night"]["image"]);
                          }
                        }),
                        Text(
                            "${weatherData["daily"]["temperature_2m_max"][index].toString()}-${weatherData["daily"]["temperature_2m_min"][index].toString()}"),
                      ],
                    );
                  }))
        ],
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}

Future<Map<String, dynamic>> getTimeZone(Position coordinates) async {
  // API Key: YXHW1WF6J7IZ
  // http://api.timezonedb.com/v2.1/get-time-zone?key=YOUR_API_KEY&format=json&by=position&lat=40.689247&lng=-74.044502
  String latitude = coordinates.latitude.toString();
  String longitude = coordinates.longitude.toString();
  final response = await http.get(Uri.parse(
      "http://api.timezonedb.com/v2.1/get-time-zone?key=YXHW1WF6J7IZ&format=json&by=position&lat=$latitude&lng=$longitude"));
  return jsonDecode(response.body);
}

Future<Map<String, dynamic>> getTime(currentLocation) async {
  double latitude = currentLocation.latitude;
  double longitude = currentLocation.longitude;
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
      "https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&hourly=temperature_2m,relative_humidity_2m,precipitation_probability,weather_code,apparent_temperature&daily=sunrise,sunset,weather_code,temperature_2m_max,temperature_2m_min&timezone=auto"));

  // API Demo. Latitude longitude set to Bahan.
  // Time zone: GMT +6:30
  // https://api.open-meteo.com/v1/forecast?latitude=16.819171&longitude=96.158458&hourly=temperature_2m,relative_humidity_2m,precipitation_probability,weather_code,apparent_temperature&daily=sunrise,sunset,weather_code,temperature_2m_max,temperature_2m_min&timezone=auto

  return jsonDecode(response.body);
}

Future<Map<String, dynamic>> getCityName(Position coordinates) async {
  String latitude = coordinates.latitude.toString();
  String longitude = coordinates.longitude.toString();
  final response = await http.get(Uri.parse(
      "https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=$latitude&longitude=$longitude&localityLanguage=en"));

  return jsonDecode(response.body);
  /*{
  "latitude": 16.85365077959264,
  "lookupSource": "coordinates",
  "longitude": 96.16809910455662,
  "localityLanguageRequested": "en",
  "continent": "Asia",
  "continentCode": "AS",
  "countryName": "Myanmar",
  "countryCode": "MM",
  "principalSubdivision": "Yangon Region",
  "principalSubdivisionCode": "MM-06",
  "city": "Yangon",
  "locality": "South Okkalapa",
  "postcode": "",
  "plusCode": "7M8RV539+F6"
  }*/
}
