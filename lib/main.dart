import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_app_simple/screens/welcome/welcome_screen.dart';
import 'package:simple_app_simple/models/verbs.dart';

import 'models/questions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SharedPreferences? prefs; // Declare prefs as nullable SharedPreferences
    prefs = null;
    return GetMaterialApp(
      title: 'Quiz App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      routes: {
        '/questions': (context) {
          // Define the row and column variables here
          int row = 1; // Example row
          int column = 1; // Example column
          String level = "A0";
          String quizletId = '';
          bool IsEnglishFlagVisible = true;
          return MyHomePage(
              quizletId: quizletId,
              IsEnglishFlagVisible: IsEnglishFlagVisible,
              level: level,
              row: row,
              column: column);
        },
        // Add other routes as needed
      },
      home: WelcomeScreen(
      ),
    );
  }
}
