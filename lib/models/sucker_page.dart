// sucker_page.dart
import 'package:simple_app_simple/models/questions.dart';
import 'package:flutter/material.dart';
import 'package:simple_app_simple/models/verbs.dart';

class SuckerPage extends StatelessWidget {
  final int rightAnswers;
  final int wrongAnswers;
  final String whatWasIdoing;

  SuckerPage({required this.rightAnswers, required this.wrongAnswers,
    required this.whatWasIdoing});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Recap:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Right Answers: $rightAnswers, Wrong Answers: $wrongAnswers',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to a new quiz page or MyVerbs based on whatWasIdoing
                    if (whatWasIdoing == "questions") {
                      /*Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MyHomePage()),
                      );
                       */
                      Navigator.pop(context);
                    } else if (whatWasIdoing == "verbs") {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MyVerbs()),
                      );
                    }
                  },
                  child: Text('Repeat'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the home page
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: Text('Home'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
