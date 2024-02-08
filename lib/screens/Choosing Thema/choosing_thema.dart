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
  int globalRowCounter = 1;
  List<bool> levelVisibility = [false, false, false, false, false];
  Map<String, Color> quizletCompletionStatus =
      {}; // Map to store completion status
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
          quizletCompletionStatus[quizletId] = isCompleted
              ? (completelyCorrect ? Colors.green : Colors.orange)
              : Colors.blue;
        });
      }
    }
  }

  // When the page is initialized or navigated to
  @override
  void initState() {
    super.initState();
    // Check if selected quizlet is completed
    //print("god");
    checkIfQuizletIsCompleted(selectedQuizlet).then((isCompleted) {
      if (isCompleted) {
        // Update button color to indicate completion
        // For example:
        //print("ALLAH");
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.pink,
          title: Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    "FLASH DUTCH",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (int i = 0; i < levelVisibility.length; i++)
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        levelVisibility[i] = !levelVisibility[i];
                      });
                    },
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.pink), // Add a black border
                      ),
                      child: Container(
                        height: 80,
                        color: Colors.blue,
                        child: Center(
                          child: Text(
                            (() {
                              switch (i) {
                                case 0:
                                  return 'A0';
                                case 1:
                                  return 'A1';
                                case 2:
                                  return 'A2';
                                case 3:
                                  return 'A2/B1';
                                case 4:
                                  return 'B1';
                                default:
                                  return '';
                              }
                            })(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (levelVisibility[i])
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          GridView.builder(
                            physics: NeverScrollableScrollPhysics(), // Disable GridView scrolling
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                            ),
                            itemCount: i == 0
                                ? 12
                                : (i == 1 ? 28 : (i == 2 ? 40 : (i == 3 ? 40 : 20))),
                            // Or whatever the number of buttons per level
                            itemBuilder: (context, index) {
                              // Build your buttons here
                              int row = 0;
                              if (i == 0) {
                                row = index ~/ 4 +
                                    1; // Rows from 1 to 20 for the first 80 items
                              }
                              if (i == 1) {
                                row = index ~/ 4 +
                                    1 +
                                    3; // Rows from 1 to 20 for the first 80 items
                              }
                              if (i == 2) {
                                row = index ~/ 4 +
                                    1 +
                                    10; // Rows from 1 to 20 for the first 80 items
                              }
                              if (i == 3) {
                                row = index ~/ 4 +
                                    1; // Rows from 1 to 20 for the first 80 items
                              }
                              if (i == 4) {
                                row = index ~/ 4 +
                                    1 + 10; // Rows from 1 to 20 for the first 80 items
                              }
                              /*if (index < 80) {
                                row = index ~/ 4 +
                                    1; // Rows from 1 to 20 for the first 80 items
                              } else {
                                row = (index - 80) ~/ 4 +
                                    1; // Rows from 1 to 15 for the remaining items
                              }*/
                              int column = (index % 4) + 1;
                              String quizletId;
                              String level;

                              // Determine the prefix based on the index range and the level
                              if (i == 0 && index < 80) {
                                quizletId = 'A0 - $row - $column';
                                level = "A0";
                              } else if (i == 1 && index < 80) {
                                quizletId = 'A1 - $row - $column';
                                level = "A1";
                              } else if (i == 2) {
                                quizletId = 'A2 - $row - $column';
                                level = "A2";
                              } else if (i == 3) {
                                quizletId = 'A2/B1 - $row - $column';
                                level = "A2/B1";
                              } else {
                                quizletId = 'B1 - $row - $column';
                                level = "B1";
                              }

                              checkIfQuizletIsCompleted(quizletId);
                              loadQuizletCompletionStatus;
                              return InkWell(
                                onTap: () {
                                  //print("$row $column");
                                  onSelectQuizlet(quizletId);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyHomePage(
                                        level: level,
                                        row: row,
                                        column: column,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: quizletCompletionStatus[quizletId] ??
                                        Colors.blue,
                                    // Use completion status to determine color
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '$level:\n$row - $column',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      // Make the text bold
                                      fontSize: 23, // Set the font size
                                    ),
                                    textAlign: TextAlign.center, // Center the text
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
