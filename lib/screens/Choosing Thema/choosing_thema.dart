import 'package:flutter/material.dart';
import 'package:simple_app_simple/screens/welcome/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/questions.dart';
import '../../models/sucker_page.dart';

String selectedQuizlet = ''; // Example of a global variable

class ButtonPage extends StatefulWidget {
  @override
  _ButtonPageState createState() => _ButtonPageState();
}

class _ButtonPageState extends State<ButtonPage> {
  Map<String, Color> quizletCompletionStatus = {}; // Map to store completion status
  Color buttonColor = Colors.blue;
  Future<bool> checkIfQuizletIsCompleted(String quizletId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retrieve the completion status from shared preferences
    bool? isCompleted = prefs.getBool(quizletId) ?? false;
    return isCompleted;
  }
  Future<void> loadQuizletCompletionStatus(bool completelyCorrect) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Load completion status for each quizlet from shared preferences
    for (int row = 1; row <= 15; row++) {
      for (int column = 1; column <= 4; column++) {
        String quizletId = 'A2/B1 - $row - $column';
        bool isCompleted = prefs.getBool(quizletId) ?? false;
        setState(() {
          quizletCompletionStatus[quizletId] = isCompleted ? (completelyCorrect ? Colors.green : Colors.orange) : Colors.blue;
        });
      }
    }
  }

  // When the page is initialized or navigated to
  @override
  void initState() {
    super.initState();
    // Check if selected quizlet is completed
    print( "god");
    checkIfQuizletIsCompleted(selectedQuizlet).then((isCompleted) {
      if (isCompleted) {
        // Update button color to indicate completion
        // For example:
        print("ALLAH");
        //setState(() {
        //   buttonColor = Colors.green;
        // });

        // Load quizlet completion status with the parameter
        loadQuizletCompletionStatus(completelyCorrect);
      }
    });
    loadQuizletCompletionStatus(completelyCorrect);
  }

  // When user selects a quizlet
  void onSelectQuizlet(String quizlet) {
    selectedQuizlet = quizlet;
    // Navigate to questions page
    Navigator.pushNamed(context, '/questions');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Button Page'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemCount: 60,
        itemBuilder: (context, index) {
          int row = index ~/ 4 + 1;
          int column = (index % 4) + 1;
          String quizletId = 'A2/B1 - $row - $column';
          checkIfQuizletIsCompleted(quizletId);
          loadQuizletCompletionStatus;
          return InkWell(
            onTap: () {
              onSelectQuizlet('A2/B1 - $row - $column');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(row: row, column: column),
                ),
              );
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: quizletCompletionStatus[quizletId] ?? Colors.blue, // Use completion status to determine color
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'A2/B1 - $row - $column',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
