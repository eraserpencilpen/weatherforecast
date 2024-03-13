import 'package:flutter/material.dart';
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
    foo();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

void foo() async {
  print("Hello World");
  LocationPermission permission = await Geolocator.requestPermission();
  if (permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse) {
    print("We got Access!");
    var position = await Geolocator.getCurrentPosition();
    print(position);
  } else {
    print("Request Access");
  }
}
