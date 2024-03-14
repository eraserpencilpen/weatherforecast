import 'package:flutter/material.dart';
import 'home.dart';
import 'const.dart';

// flutter run -d chrome --web-browser-flag "--disable-web-security"
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
