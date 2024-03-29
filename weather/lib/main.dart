import 'package:flutter/material.dart';
import 'home.dart';
import 'const.dart';
import 'package:google_fonts/google_fonts.dart';

// flutter run -d chrome --web-browser-flag "--disable-web-security"
void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
        theme: _buildTheme(Brightness.dark));
  }

  ThemeData _buildTheme(brightness) {
    var baseTheme = ThemeData(brightness: Brightness.dark);

    return baseTheme.copyWith(
      textTheme: GoogleFonts.dosisTextTheme(baseTheme.textTheme),
    );
  }
}
