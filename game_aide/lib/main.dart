import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'pages/gameaide_homepage.dart';

//Custom Theme Definitions
const Color color1 = Color(0xFF363732);
const Color color2 = Color(0xFF53D8FB);
const Color color3 = Color(0xFF66C3FF);
const Color color4 = Color(0xFFDCE1E9);
const Color color5 = Color(0xFFD4AFB9);

MaterialColor createMaterialColor(Color color) {
  List<double> strengths = <double>[0.5];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

final MaterialColor customPrimarySwatch = createMaterialColor(color3);

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = ColorScheme.fromSeed(seedColor: color3);

    return MaterialApp(
      title: 'Game Aide',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: color4,
        cardColor: color5,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
          titleLarge: TextStyle(
              fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 2,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: color3,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          labelStyle: const TextStyle(color: Colors.black87),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: color4,
            backgroundColor: color1,
          ),
        ),
        cardTheme: CardTheme(
          color: color3,
          elevation: 4,
        ),
      ),
      home: const GameAideHomePage(),
    );
  }
}
