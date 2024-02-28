// sucker_page.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_app_simple/models/questions.dart';
import 'package:flutter/material.dart';
import 'package:simple_app_simple/models/verbs.dart';
import 'package:simple_app_simple/screens/Choosing Thema/choosing_thema.dart';
import '../constants.dart';
import '../screens/Choosing Thema/choosing_thema.dart';
import '../screens/welcome/welcome_screen.dart';

bool completelyCorrect = false;

class SuckerPage extends StatelessWidget {
  final int rightAnswers;
  final int wrongAnswers;
  final String whatWasIdoing;
  final int row;
  final int column;
  final String level;
  final bool IsEnglishFlagVisible;
  final String difficulty;

  SuckerPage(
      {required this.rightAnswers,
      required this.wrongAnswers,
      required this.whatWasIdoing,
      required this.row,
      required this.column,
      required this.level,
      required this.IsEnglishFlagVisible, required this.difficulty,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle the navigation accordingly, for example, pop the current screen
            Navigator.maybePop(
                context); // Use maybePop to handle back navigation
          },
        ),
        title: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width *
                  0.05, // Use a percentage of the screen width
              top: 16.0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "FLASH DUTCH",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 50),
                /*GestureDetector(
                      onTap: () {
                        setState(() {
                          IsEnglishFlagVisible = !IsEnglishFlagVisible;
                          isVerb = false;
                          isArticle = false;
                          isOther = false;
                        });
                      },
                      child: IsEnglishFlagVisible
                          ? Image.asset(
                              'assets/english_flag.png',
                              height: 30,
                              width: 30,
                            )
                          : Image.asset(
                              'assets/dutch.png.png',
                              // Replace with the path to your Dutch flag image
                              height: 30,
                              width: 30,
                            ),
                    ),*/
              ],
            ),
          ),
        ),
        centerTitle: true,
        // Set preferredSize to zero height
        // This will effectively hide the app bar
        // by making it invisible and not taking up any space
        //toolbarHeight: 0,
        //backgroundColor: Colors.transparent, // Set background color to transparent
        //elevation: 0, // No shadow
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Recap:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
                padding: const EdgeInsets.all(16),
                child: Center(
                  // Center the text
                  child: Text(
                    'Right Answers: $rightAnswers',
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
                padding: const EdgeInsets.all(16),
                child: Center(
                  // Center the text
                  child: Text(
                    'Wrong Answers: $wrongAnswers',
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    completelyCorrect = wrongAnswers == 0;
                    // Navigate to a new quiz page or MyVerbs based on whatWasIdoing
                    if (whatWasIdoing == "questions") {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ButtonPage(
                            completelyCorrect:
                                completelyCorrect, // Pass the SharedPreferences instance
                          ),
                        ),
                      );
                    } else if (whatWasIdoing == "verbs") {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MyVerbs(difficulty: difficulty)),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 32),
                    // Adjust padding for size
                    decoration: BoxDecoration(
                      gradient: kPrimaryGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    // Determine if the quizlet was completely correct
                    completelyCorrect = wrongAnswers == 0;

                    // Navigate to the home page with the completelyCorrect parameter
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 32),
                    // Adjust padding for size
                    decoration: BoxDecoration(
                      gradient: kPrimaryGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        'Home',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
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
