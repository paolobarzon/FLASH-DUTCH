// sucker_page.dart
import 'package:simple_app_simple/models/questions.dart';
import 'package:flutter/material.dart';
import 'package:simple_app_simple/models/verbs.dart';
import 'package:simple_app_simple/screens/Choosing Thema/choosing_thema.dart';
import '../screens/Choosing Thema/choosing_thema.dart';

bool completelyCorrect = false;

class SuckerPage extends StatelessWidget {
  final int rightAnswers;
  final int wrongAnswers;
  final String whatWasIdoing;
  final int row;
  final int column;
  final String level;

  SuckerPage(
      {required this.rightAnswers,
      required this.wrongAnswers,
      required this.whatWasIdoing,
      required this.row,
      required this.column,
      required this.level});

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
                      //print(row);
                      //print("and");
                      //print(column);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MyHomePage(level: level, row: row, column: column)),
                      );

                      //Navigator.pop(context);
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
                  onPressed: () async {
                    // Determine if the quizlet was completely correct
                    completelyCorrect = wrongAnswers == 0;
                    //print(selectedQuizlet);
                    completelyCorrect = wrongAnswers == 0;

                    // Update quizlet completion status based on completelyCorrect
                    //await loadQuizletCompletionStatus(completelyCorrect);

                    // Navigate to the home page with the completelyCorrect parameter
                    Navigator.pop(context, completelyCorrect);
                    Navigator.pop(context, completelyCorrect);
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
