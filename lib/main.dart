import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
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
          return MyHomePage(level: level, row: row, column: column);
        },
        // Add other routes as needed
      },
      home: const WelcomeScreen(),
    );
  }
}
