import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  Map<String, dynamic> weatherData = {};
  Map<String, dynamic> time = {};
  Map<String, dynamic> cityName = {};
  bool locationPermissionGiven = false;
  int indexOptions = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getLocation().then((value) {
      if (value.runtimeType == Position) {
        setState(() {
          locationPermissionGiven = true;
        });
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
    if (weatherData.isNotEmpty && cityName.isNotEmpty && time.isNotEmpty) {
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

      List<Widget> widgetOptions = [
        WeatherWidget(weatherData: weatherData, time: time, cityName: cityName),
        MiscPage()
      ];
      bool isDay = false;
      String image = "";
      if (currentTime >= sunrise && currentTime <= sunset) {
        isDay = true;
      }
      // If 10 minutes within sunset
      if (currentTime <= sunset + 10 && currentTime >= sunset - 10) {
        image = "bg_images/sunset_cat_big.jpg";
      } else if (clearCodes.contains(int.parse(code))) {
        image = "bg_images/clear_${isDay ? "day" : "night"}_catbg.jpg";
      } else if (cloudyCodes.contains(int.parse(code))) {
        image = "bg_images/cloudy_${isDay ? "day" : "night"}_catbg.jpg";
      } else if (rainyCodes.contains(int.parse(code))) {
        image = "bg_images/rainy_${isDay ? "day" : "night"}_catbg.jpg";
      } else if (snowyCodes.contains(int.parse(code))) {
        image = "bg_images/rainy_${isDay ? "day" : "night"}_catbg.jpg";
      } else {
        image = "night_cloudy.jpg";
      }

      return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill, image: AssetImage(image))),
            child: Builder(builder: (context) {
              return widgetOptions[indexOptions];
            })),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: isDay
              ? Color.fromARGB(1, 225, 248, 255)
              : Color.fromARGB(1, 81, 72, 178),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.sunny), label: "Others")
          ],
          onTap: (int index) {
            switch (index) {
              case 0:
                setState(() {
                  indexOptions = 0;
                });
              case 1:
                setState(() {
                  indexOptions = 1;
                });
            }
          },
        ),
      );
    } else if (locationPermissionGiven) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    } else if (!locationPermissionGiven) {
      return const Center(
        child: Text("Please allow location access."),
      );
    } else {
      return const Center(
        child: Text("Oops. Something went wrong."),
      );
    }
  }
}

class WeatherWidget extends StatefulWidget {
  WeatherWidget(
      {super.key,
      required this.weatherData,
      required this.time,
      required this.cityName});

  Map<String, dynamic> weatherData;
  Map<String, dynamic> time;
  Map<String, dynamic> cityName;
  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  @override
  Widget build(BuildContext context) {
    String code = widget.weatherData["hourly"]["weather_code"]
            [widget.time["hour"]]
        .toString();
    double currentTime =
        widget.time["hour"].toDouble() * 60 + widget.time["minute"].toDouble();
    String sunrise_hour =
        widget.weatherData["daily"]["sunrise"][0].substring(11, 13);
    String sunrise_minute =
        widget.weatherData["daily"]["sunrise"][0].substring(14, 16);
    double sunrise =
        double.parse(sunrise_hour) * 60 + double.parse(sunrise_minute);
    String sunset_hour =
        widget.weatherData["daily"]["sunset"][0].substring(11, 13);
    String sunset_minute =
        widget.weatherData["daily"]["sunset"][0].substring(14, 16);
    double sunset =
        double.parse(sunset_hour) * 60 + double.parse(sunset_minute);

    return ListView(
      children: [
        Center(
          child: Text(
            widget.cityName["city"].toString(),
            textScaler: const TextScaler.linear(2),
          ),
        ),
        Center(
          child: Text(
            widget.weatherData["hourly"]["temperature_2m"][widget.time["hour"]]
                    .toString() +
                "°C",
            textScaler: const TextScaler.linear(6),
          ),
        ),
        Center(
          child: Text(
            "Feels like ${widget.weatherData["hourly"]["apparent_temperature"][widget.time["hour"]].toString() + "°C"}",
            textScaler: const TextScaler.linear(2),
          ),
        ),
        Builder(builder: (context) {
          if (currentTime <= sunset && currentTime >= sunrise) {
            return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset(weatherCodes[code]["day"]["image"]),
              Text(weatherCodes[code]["day"]["description"])
            ]);
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(weatherCodes[code]["night"]["image"]),
                Text(weatherCodes[code]["night"]["description"])
              ],
            );
          }
        }),
        SizedBox(
          height: 400,
          width: MediaQuery.of(context).size.width * 0.75,
          child: Card(
            color: Colors.transparent,
            margin: EdgeInsets.all(10),
            child: ListView.builder(
                itemCount: 10,
                shrinkWrap: true,
                itemBuilder: ((context, index) {
                  int currentHour = widget.time["hour"] + index * 2;
                  if (currentHour >= 24) {
                    currentHour = currentHour - 24;
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(currentHour.toString() + ":00"),
                      Builder(builder: (context) {
                        String dailyCode = widget.weatherData["hourly"]
                                ["weather_code"]
                                [widget.time["hour"] + index * 2]
                            .toString();
                        if (currentTime >= sunrise && currentTime <= sunset) {
                          return Image.asset(
                              weatherCodes[dailyCode]["day"]["image"]);
                        } else {
                          return Image.asset(
                              weatherCodes[dailyCode]["night"]["image"]);
                        }
                      }),
                      Text(widget.weatherData["hourly"]["temperature_2m"]
                                  [widget.time["hour"] + index * 2]
                              .toString() +
                          "°C"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "precipitation_percentage.png",
                            height: 50,
                          ),
                          Text(widget.weatherData["hourly"]
                                  ["precipitation_probability"]
                                  [widget.time["hour"] + index * 2]
                              .toString()),
                        ],
                      )
                    ],
                  );
                })),
          ),
        ),
        const Center(
          child: Text(
            "Weekly Weather Forecast",
            textScaler: TextScaler.linear(2),
          ),
        ),
        SizedBox(
          height: 400,
          child: Card(
              color: Colors.transparent,
              margin: EdgeInsets.all(10),
              child: ListView.builder(
                  itemCount: 7,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    String month = widget.weatherData["daily"]["time"][index]
                        .substring(5, 7);
                    String day = widget.weatherData["daily"]["time"][index]
                        .substring(8, 10);
                    if (day[0] == "0") {
                      day = day[1];
                    }
                    if (month[0] == "0") {
                      month = month[1];
                    }
                    month = monthsInYear[int.parse(month)] ?? month;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("$day $month"),
                        Builder(builder: (context) {
                          String dailyCode = widget.weatherData["daily"]
                                  ["weather_code"][index]
                              .toString();
                          if (currentTime >= sunrise && currentTime <= sunset) {
                            return Image.asset(
                                weatherCodes[dailyCode]["day"]["image"]);
                          } else {
                            return Image.asset(
                                weatherCodes[dailyCode]["night"]["image"]);
                          }
                        }),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                "Max: ${widget.weatherData["daily"]["temperature_2m_max"][index].toString()} °C"),
                            Text(
                                " Min: ${widget.weatherData["daily"]["temperature_2m_min"][index].toString()} °C")
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "precipitation_percentage.png",
                              height: 50,
                            ),
                            Text(widget.weatherData["daily"]
                                    ["precipitation_probability_max"][index]
                                .toString()),
                          ],
                        )
                      ],
                    );
                  })),
        )
      ],
    );
  }
}

class MiscPage extends StatelessWidget {
  const MiscPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView();
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
      "https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&hourly=temperature_2m,relative_humidity_2m,precipitation_probability,weather_code,apparent_temperature&daily=sunrise,sunset,weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max&timezone=auto"));

  // API Demo. Latitude longitude set to Bahan.
  // Time zone: GMT +6:30
  // https://api.open-meteo.com/v1/forecast?latitude=16.819171&longitude=96.158458&hourly=temperature_2m,relative_humidity_2m,precipitation_probability,weather_code,apparent_temperature&daily=sunrise,sunset,weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max&timezone=auto

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
