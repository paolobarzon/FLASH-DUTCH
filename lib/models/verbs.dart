import 'dart:math';
import 'package:simple_app_simple/main.dart';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_app_simple/models/sucker_page.dart';

class MyVerbs extends StatefulWidget {
  const MyVerbs({super.key});

  @override
  _MyVerbsState createState() => _MyVerbsState();
}

class _MyVerbsState extends State<MyVerbs> {
  List<List<dynamic>> _data = []; // CSV data

  //String infinitive = ""; // To store the randomly selected infinitive
  String prompt =
      ""; // To store the prompt ("imperfectum" or "perfectum" or "translation")
  String correctAnswer = ""; // To store the correct answer based on the prompt
  String notPrompt1 = "";
  String notPrompt2 = "";
  int whichCase = 0;
  bool showNextButton =
      false; // Flag to control the visibility of the "Next" button

  String feedbackMessage = ""; // To store the feedback message for the user
  String resultMessage = "";
  int correctCounter = 0; // Counter for correct answers
  int wrongCounter = 0; // Counter for wrong answers

  bool hintsOn = false;

  String infinitive = "";
  String imperfectum = "";
  String perfectum = "";
  String translation = "";
  int displayedCardsCount = 0;

  List<Widget> progressDots = List.generate(
    10,
        (index) => Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.0),
      // Adjust the horizontal padding as needed
      child: Icon(
        Icons.circle,
        size: 30.0, // Set the size as needed
        color: Colors.white,
      ),
    ),
  );

  void updateProgress(bool isCorrect) {
    int indexToUpdate = displayedCardsCount - 1;
    Icon updatedIcon = isCorrect
        ? Icon(Icons.check, color: Colors.green, size: 30.0)
        : Icon(Icons.close, color: Colors.red, size: 30.0);

    setState(() {
      progressDots[indexToUpdate] = updatedIcon;
    });
  }

  @override
  void initState() {
    super.initState();
    // Load CSV data when the widget is initialized
    loadData();
  }

  // Function to load CSV data
  void loadData() async {
    // Load CSV data from "verbs 2.csv"
    String raw = await rootBundle.loadString('assets/verbs 2.csv');
    List<List<dynamic>> csvTable = CsvToListConverter().convert(raw);

    setState(() {
      _data = csvTable;
    });

    // Randomly select a verb
    selectRandomVerb();
  }

  // Function to randomly select a verb
  void selectRandomVerb() {
    if (displayedCardsCount == 10) {
      // Navigate to the new page with the "sucker" message
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SuckerPage(
            rightAnswers: correctCounter,
            wrongAnswers: wrongCounter,
            whatWasIdoing : "verbs",
            row: 999,
            column: 999,
          ),
        ),
      );
    }
    // Reset the flag and hide the "Next" button
    setState(() {
      showNextButton = false;
      feedbackMessage = ""; // Clear the feedback message
      resultMessage = "";
    });

    // Randomly select a row
    int randomRowIndex = Random().nextInt(_data.length);

    // Get infinitive, imperfectum, perfectum, and translation from the selected row
    infinitive = _data[randomRowIndex][0];
    imperfectum = _data[randomRowIndex][1];
    perfectum = _data[randomRowIndex][2];
    translation = _data[randomRowIndex][3];

    // Randomly decide whether to prompt "imperfectum", "perfectum", or "translation"
    int randomPrompt = Random().nextInt(3);
    switch (randomPrompt) {
      case 0:
        prompt = "imperfectum";
        correctAnswer = imperfectum;
        notPrompt1 = "translation";
        notPrompt2 = "perfectum";
        whichCase = 0;
        break;
      case 1:
        prompt = "perfectum";
        correctAnswer = perfectum;
        notPrompt1 = "translation";
        notPrompt2 = "imperfectum";
        whichCase = 1;
        break;
      case 2:
        prompt = "translation";
        correctAnswer = translation;
        notPrompt1 = "imperfectum";
        notPrompt2 = "perfectum";
        whichCase = 2;
        break;
      default:
        prompt = "imperfectum";
        correctAnswer = imperfectum;
        notPrompt1 = "translation";
        notPrompt2 = "perfectum";
        whichCase = 3;
    }

    // Set the state with the selected values
    setState(() {
      this.infinitive = infinitive;
    });
  }

  // Function to handle user input
  void handleUserInput(String input) {
    bool isCorrect = input.toLowerCase() == correctAnswer.toLowerCase();

    // Update counters
    if (isCorrect) {
      correctCounter++;
    } else {
      wrongCounter++;
    }

    displayedCardsCount++;

    // Update UI based on correctness
    setState(() {
      if (isCorrect) {
        feedbackMessage = "Correct! The solution is: $correctAnswer";
        updateProgress(isCorrect);
        showNextButton = true; // Show the "Next" button
      } else {
        feedbackMessage = "Wrong! The correct solution is: $correctAnswer";
        updateProgress(isCorrect);
        showNextButton = true; // Show the "Next" button
      }
      resultMessage = "Correct Answers: $correctCounter | Wrong Answers: $wrongCounter";
        // style: TextStyle(fontSize: 18),
        // textAlign: TextAlign.center,

    });
  }

  Widget displayAdditionalInfo() {
    if (!hintsOn) {
      return SizedBox.shrink(); // Return an empty widget if hints are off
    }

    // Switch based on whichCase
    switch (whichCase) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              "$notPrompt1 = $translation",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Text(
              "$notPrompt2 = $perfectum",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              "$notPrompt1 = $translation",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Text(
              "$notPrompt2 = $imperfectum",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              "$notPrompt1 = $imperfectum",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Text(
              "$notPrompt2 = $perfectum",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        );
      default:
        return SizedBox.shrink(); // Return an empty widget for unknown cases
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "FLASH DUTCH",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.pink,
        elevation: 0,
        actions: [
          // Add a button to toggle hints
          TextButton(
            onPressed: () {
              // Toggle the hintsOn variable
              setState(() {
                hintsOn = !hintsOn;
              });
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
            ),
            child: Text(
              hintsOn ? 'Hints: ON' : 'Hints: OFF',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: progressDots,
              ),
            ),
            SizedBox(height: 60),
            Text(
              "Infinitive: $infinitive",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            if (prompt == "translation")
              Text(
                "Translate to English",
                style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
              )
            else
              Text(
                "Conjugate in $prompt",
                style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
              ),
            SizedBox(height: 20),
            displayAdditionalInfo(),
            //SizedBox(height: 10),
            // Display feedback message
            Text(
              feedbackMessage,
              style: TextStyle(
                fontSize: 20,
                color: feedbackMessage.contains("Correct")
                    ? Colors.green
                    : Colors.red,
              ),
            ),
            /*Text(
              resultMessage,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),*/
            SizedBox(height: 20),
            // Only show the TextField when the "Next" button is not visible
            if (!showNextButton)
              TextField(
                onSubmitted: (input) {
                  // Handle user input
                  handleUserInput(input);
                },
                decoration: InputDecoration(
                  hintText: "Type your answer here",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            SizedBox(height: 20),
            // Show the "Next" button when it's visible
            if (showNextButton)
              ElevatedButton(
                onPressed: () {
                  // Load a new verb for the next question
                  selectRandomVerb();
                },
                child: Text("Next"),
              ),
            SizedBox(height: 20),
            // Display counters

          ],
        ),
      ),
    );
  }
}
