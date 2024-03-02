import 'package:flutter/material.dart';
import 'home.dart';
import 'const.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

void foo() {
  print("Hello World");
}
