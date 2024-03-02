import 'package:flutter/material.dart';
import 'package:location/location.dart';

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

void foo() {
  print("Hello World");
  final location = new Location();
  var data = location.getLocation();
  print(data);
}
