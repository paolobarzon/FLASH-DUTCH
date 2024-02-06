/*
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:simple_app_simple/controllers/question_controller.dart';

import '../../models/questions.dart';

// import 'components/body.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    QuestionController controller = Get.put(QuestionController());
    return Scaffold(

      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // Fluttter show the back button automatically
        backgroundColor: Colors.amber,
        elevation: 0,
        actions: [
          TextButton(onPressed: controller.nextQuestion, child: const Text("Skip")),
        ],
      ),
      body: Center(
        child: Container(
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyHomePage(row: row, column: column)
            ],
            ),
          ),
        ),
      ),
      );
  }
}
 */