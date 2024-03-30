import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'dart:convert';

import 'package:weather/const.dart';
import 'package:google_fonts/google_fonts.dart';

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: HomePage(),
//         theme: _buildTheme(Brightness));
//   }

//   ThemeData _buildTheme(brightness) {
//     var baseTheme = ThemeData(brightness: Brightness.dark);

//     return baseTheme.copyWith(
//       textTheme: GoogleFonts.dosisTextTheme(baseTheme.textTheme),
//     );
//   }
// }

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
  var themeVar = Brightness.dark;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getLocation().then((value) {
      if (value.runtimeType != LocationPermission) {
        setState(() {
          locationPermissionGiven = true;
        });
        getWeatherData(value).then((data) {
          setState(() {
            weatherData = data;
          });
          getTime(value).then((timeData) {
            setState(() {
              time = timeData;
              print("HI");

              double currentTime =
                  time["hour"].toDouble() * 60 + time["minute"].toDouble();
              String sunrise_hour =
                  weatherData["daily"]["sunrise"][0].substring(11, 13);
              String sunrise_minute =
                  weatherData["daily"]["sunrise"][0].substring(14, 16);
              double sunrise = double.parse(sunrise_hour) * 60 +
                  double.parse(sunrise_minute);
              String sunset_hour =
                  weatherData["daily"]["sunset"][0].substring(11, 13);
              String sunset_minute =
                  weatherData["daily"]["sunset"][0].substring(14, 16);
              double sunset =
                  double.parse(sunset_hour) * 60 + double.parse(sunset_minute);

              if (currentTime >= sunrise && currentTime <= sunset) {
                setState(() {
                  themeVar = Brightness.light;
                });
              }
            });
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
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(brightness: themeVar).copyWith(
            textTheme: GoogleFonts.dosisTextTheme(
                ThemeData(brightness: themeVar).textTheme)),
        home: Builder(builder: (context) {
          if (weatherData.isNotEmpty &&
              cityName.isNotEmpty &&
              time.isNotEmpty) {
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
            String sunset_hour =
                weatherData["daily"]["sunset"][0].substring(11, 13);
            String sunset_minute =
                weatherData["daily"]["sunset"][0].substring(14, 16);
            double sunset =
                double.parse(sunset_hour) * 60 + double.parse(sunset_minute);
            String humidity =
                weatherData["hourly"]["relative_humidity_2m"][0].toString();
            String uvIndex = weatherData["daily"]["uv_index_max"][0].toString();
            String sunriseString =
                weatherData["daily"]["sunrise"][0].substring(11, 16);
            String sunsetString =
                weatherData["daily"]["sunset"][0].substring(11, 16);
            String windSpeed = weatherData["hourly"]["wind_speed_10m"]
                    [time["hour"]]
                .toString();
            List<Widget> widgetOptions = [
              WeatherWidget(
                  weatherData: weatherData, time: time, cityName: cityName),
              MiscPage(
                  sunrise: sunriseString,
                  sunset: sunsetString,
                  uvIndex: uvIndex,
                  humidity: humidity,
                  windSpeed: windSpeed)
            ];
            bool isDay = false;
            String image = "assets/default_bg.jpg";
            if (currentTime >= sunrise && currentTime <= sunset) {
              isDay = true;
            }
            // If 10 minutes within sunset
            if (currentTime <= sunset + 10 && currentTime >= sunset - 10) {
              image = "assets/bg_images/sunset_catbg.jpg";
            } else if (clearCodes.contains(int.parse(code))) {
              image =
                  "assets/bg_images/clear_${isDay ? "day" : "night"}_catbg.jpg";
            } else if (cloudyCodes.contains(int.parse(code))) {
              image =
                  "assets/bg_images/cloudy_${isDay ? "day" : "night"}_catbg.jpg";
            } else if (rainyCodes.contains(int.parse(code))) {
              image =
                  "assets/bg_images/rainy_${isDay ? "day" : "night"}_catbg.jpg";
            } else if (snowyCodes.contains(int.parse(code))) {
              image =
                  "assets/bg_images/rainy_${isDay ? "day" : "night"}_catbg.jpg";
            }
            return Scaffold(
              body: GestureDetector(
                onPanUpdate: (details) {
                  int sensitivity = 10;
                  // Swiping in right direction.
                  if (details.delta.dx > sensitivity) {
                    setState(() {
                      indexOptions = 0;
                    });
                  }

                  // Swiping in left direction.
                  if (details.delta.dx < -sensitivity) {
                    setState(() {
                      indexOptions = 1;
                    });
                  }
                },
                child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill, image: AssetImage(image))),
                    child: Builder(builder: (context) {
                      return widgetOptions[indexOptions];
                    })),
              ),
              bottomNavigationBar: NavigationBar(
                height: 60,
                indicatorColor: isDay ? Colors.amber[200] : Colors.blue[300],
                selectedIndex: indexOptions,
                backgroundColor: isDay ? Colors.amber[50] : Colors.blue[100],
                destinations: [
                  NavigationDestination(icon: Icon(Icons.home), label: "Home"),
                  NavigationDestination(
                      icon: Icon(Icons.sunny), label: "Others")
                ],
                onDestinationSelected: (int index) {
                  setState(() {
                    indexOptions = index;
                  });
                },
              ),
            );
          } else if (locationPermissionGiven) {
            return Scaffold(
              body: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("assets/default_bg.jpg"))),
                child: const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
            );
          } else if (!locationPermissionGiven) {
            return Scaffold(
              body: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("assets/default_bg.jpg"))),
                child: const Center(
                  child: Text(
                    "Please allow location access.",
                    textScaler: TextScaler.linear(4),
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: Text("Oops. Something went wrong."),
            );
          }
        }));
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
        SizedBox(height: 15),
        Center(
          child: Text(
            style: GoogleFonts.dosis(
              //   // textStyle: Theme.of(context).textTheme.displayLarge,
              // fontSize: 25,
              fontWeight: FontWeight.w500,
              //   // fontStyle: FontStyle.italic,
            ),
            widget.cityName["city"].toString(),
            textScaler: const TextScaler.linear(3),
          ),
        ),
        Center(
          child: Text(
            // style: GoogleFonts.dosis(
            //   fontSize: 8,
            //   fontWeight: FontWeight.w500,
            // ),
            widget.weatherData["hourly"]["temperature_2m"][widget.time["hour"]]
                    .toString() +
                "°C",
            textScaler: const TextScaler.linear(5),
          ),
        ),
        Center(
          child: Text(
            // style: GoogleFonts.dosis(
            //   fontSize: 15,
            //   fontWeight: FontWeight.w500,
            // ),
            "Feels like ${widget.weatherData["hourly"]["apparent_temperature"][widget.time["hour"]].toString() + "°C"}",
            textScaler: const TextScaler.linear(2),
          ),
        ),
        Builder(builder: (context) {
          if (currentTime <= sunset && currentTime >= sunrise) {
            return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset(
                      "assets/" + weatherCodes[code]["day"]["image"])),
              Text(
                weatherCodes[code]["day"]["description"],
                style: GoogleFonts.dosis(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              )
            ]);
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.asset(
                        "assets/" + weatherCodes[code]["night"]["image"])),
                Text(
                  weatherCodes[code]["night"]["description"],
                  style: GoogleFonts.dosis(
                    fontSize: 25,
                    //   fontWeight: FontWeight.w500,
                  ),
                )
              ],
            );
          }
        }),
        Center(
          child: Text(
            "Hourly Forecast",
            textScaler: TextScaler.linear(2),
            style: GoogleFonts.dosis(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
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
                  String currentHour =
                      (widget.time["hour"] + index * 2).toString();
                  if (int.parse(currentHour) >= 24) {
                    currentHour = (int.parse(currentHour) - 24).toString();
                  }
                  if (currentHour.length <= 1) {
                    currentHour = "0$currentHour";
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Text(
                          "$currentHour:00",
                          textAlign: TextAlign.end,
                          style: GoogleFonts.dosis(
                            fontSize: 20,
                            //   fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Builder(builder: (context) {
                          String code = widget.weatherData["hourly"]
                                  ["weather_code"]
                                  [widget.time["hour"] + index * 2]
                              .toString();
                          if ((widget.time["hour"] + index * 2) * 60 >=
                                  sunrise &&
                              (widget.time["hour"] + index * 2) * 60 <=
                                  sunset) {
                            return Image.asset(
                              "assets/" + weatherCodes[code]["day"]["image"],
                              height: 50,
                              width: 50,
                            );
                          } else {
                            return Image.asset(
                              "assets/" + weatherCodes[code]["night"]["image"],
                              height: 50,
                              width: 50,
                            );
                          }
                        }),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Text(
                          textAlign: TextAlign.start,
                          widget.weatherData["hourly"]["temperature_2m"]
                                      [widget.time["hour"] + index * 2]
                                  .toString() +
                              "°C",
                          style: GoogleFonts.dosis(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/" + "precipitation_percentage.png",
                            height: 40,
                          ),
                          Text(
                            "  " +
                                widget.weatherData["hourly"]
                                        ["precipitation_probability"]
                                        [widget.time["hour"] + index * 2]
                                    .toString() +
                                "%"+"  ",
                            style: GoogleFonts.dosis(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                })),
          ),
        ),
        Center(
          child: Text(
            "Weekly Forecast",
            style: GoogleFonts.dosis(
              fontWeight: FontWeight.w500,
            ),
            textScaler: TextScaler.linear(2),
          ),
        ),
        SizedBox(
          height: 400,
          child: Card(
              color: const Color.fromARGB(0, 226, 222, 222),
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
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: Text(
                            textAlign: TextAlign.end,
                            "$day $month",
                            style: GoogleFonts.dosis(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: Builder(builder: (context) {
                            String dailyCode = widget.weatherData["daily"]
                                    ["weather_code"][index]
                                .toString();
                            if (currentTime >= sunrise &&
                                currentTime <= sunset) {
                              return Image.asset(
                                  "assets/" +
                                      weatherCodes[dailyCode]["day"]["image"],
                                  height: 50,
                                  width: 50);
                            } else {
                              return Image.asset(
                                  "assets/" +
                                      weatherCodes[dailyCode]["night"]["image"],
                                  height: 50,
                                  width: 50);
                            }
                          }),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  style: GoogleFonts.dosis(
                                    fontSize: 20,
                                  ),
                                  "Max: ${widget.weatherData["daily"]["temperature_2m_max"][index].toString()} °C"),
                              Text(
                                  style: GoogleFonts.dosis(
                                    fontSize: 20,
                                  ),
                                  " Min: ${widget.weatherData["daily"]["temperature_2m_min"][index].toString()} °C")
                            ],
                          ),
                        ),
                        SizedBox(
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/" + "precipitation_percentage.png",
                                height: 40,
                              ),
                              Text(
                                "  " +
                                    widget.weatherData["daily"]
                                            ["precipitation_probability_max"]
                                            [index]
                                        .toString() +
                                    "%" + "  ",
                                style: GoogleFonts.dosis(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
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
  MiscPage(
      {super.key,
      required this.humidity,
      required this.uvIndex,
      required this.sunrise,
      required this.sunset,
      required this.windSpeed});
  String humidity;
  String uvIndex;
  String sunrise;
  String sunset;
  String windSpeed;
  @override
  Widget build(BuildContext context) {
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TileWidget(
            iconPath: "sunrise.png", description: "Sunrise", data: sunrise),
        TileWidget(iconPath: "sunset.png", description: "Sunset", data: sunset),
        TileWidget(
            iconPath: "humidity.png", description: "Humidity", data: "$humidity %"),
        TileWidget(
            iconPath: "uvindex.png", description: "UV Index", data: uvIndex),
        TileWidget(
            iconPath: "wind_speed.png",
            description: "Wind Speed",
            data: "$windSpeed km/h")
      ],
    );
  }
}

class TileWidget extends StatelessWidget {
  TileWidget(
      {super.key,
      required this.iconPath,
      required this.description,
      required this.data});
  String iconPath;
  String description;
  String data;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "assets/" + iconPath,
            height: 100,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  textScaler: TextScaler.linear(2),
                ),
                Text(data, textScaler: TextScaler.linear(2))
              ],
            ),
          )
        ],
      ),
    );
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
      "https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&hourly=temperature_2m,relative_humidity_2m,precipitation_probability,weather_code,apparent_temperature,wind_speed_10m&daily=sunrise,sunset,weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max,uv_index_max&timezone=auto"));

  // API Demo. Latitude longitude set to Bahan.
  // Time zone: GMT +6:30
  // https://api.open-meteo.com/v1/forecast?latitude=16.819171&longitude=96.158458&hourly=temperature_2m,relative_humidity_2m,precipitation_probability,weather_code,apparent_temperature,wind_speed_10m&daily=sunrise,sunset,weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max,uv_index_max&timezone=auto

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
