import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation().then((value) {
      if (value.runtimeType == Position) {
        print(value);
        getTime();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

void getTime() async {
  final response = await http.get(Uri.parse(
      "https://timeapi.io/api/Time/current/coordinate?latitude=16.84&longitude=96.17"));
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
