import 'dart:math';
import 'package:simple_app_simple/main.dart';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_app_simple/models/sucker_page.dart';

import '../constants.dart';

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
  bool solutionGiven = false;
  bool isCorrect = false;

  List<Widget> progressDots = List.generate(
    10,
    (index) => const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      // Adjust the horizontal padding as needed
      child: Icon(
        Icons.circle,
        size: 20.0, // Set the size as needed
        color: Colors.white,
      ),
    ),
  );

  void updateProgress(bool isCorrect) {
    int indexToUpdate = displayedCardsCount - 1;
    Widget updatedDot = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      // Adjust the horizontal padding as needed
      child: Icon(
        isCorrect ? Icons.circle : Icons.circle,
        color: isCorrect ? Colors.green : Colors.red,
        size: 20.0, // Set the size as needed
      ),
    );

    setState(() {
      progressDots[indexToUpdate] = updatedDot;
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
            whatWasIdoing: "verbs",
            level: "A0",
            row: 999,
            column: 999,
            IsEnglishFlagVisible: true,
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
        prompt = "Imperfectum";
        correctAnswer = imperfectum;
        notPrompt1 = "Translation";
        notPrompt2 = "Perfectum";
        whichCase = 0;
        break;
      case 1:
        prompt = "Perfectum";
        correctAnswer = perfectum;
        notPrompt1 = "Translation";
        notPrompt2 = "Imperfectum";
        whichCase = 1;
        break;
      case 2:
        prompt = "translation";
        correctAnswer = translation;
        notPrompt1 = "Imperfectum";
        notPrompt2 = "Perfectum";
        whichCase = 2;
        break;
      default:
        prompt = "Imperfectum";
        correctAnswer = imperfectum;
        notPrompt1 = "Translation";
        notPrompt2 = "Perfectum";
        whichCase = 3;
    }

    // Set the state with the selected values
    setState(() {
      this.infinitive = infinitive;
    });
  }

  // Function to handle user input
  void handleUserInput(String input) {
    String sanitizedInput = input.trim().toLowerCase();

    // Check if the input starts with "to "
    if (sanitizedInput.startsWith("to ")) {
      // Remove "to " from the input
      sanitizedInput = sanitizedInput.substring(3);
    }

    // Split the correct answer by "/"
    List<String> correctAnswers = correctAnswer.split("/");

    // Check if any part of the correct answer matches the input
    isCorrect =
        correctAnswers.any((answer) => sanitizedInput == answer.toLowerCase());

    //bool isCorrect = sanitizedInput == correctAnswer.toLowerCase();
    //bool isCorrect = input.toLowerCase() == correctAnswer.toLowerCase();

    // Update counters
    if (isCorrect) {
      correctCounter++;
    } else {
      wrongCounter++;
    }

    displayedCardsCount++;

    // Update UI based on correctness
    setState(() {
      //print( "im in set state");
      solutionGiven = true;
      displayAdditionalInfo(solutionGiven, isCorrect);
      showNextButton = true;
      updateProgress(isCorrect);
      /*if (isCorrect) {
        feedbackMessage = "Correct! The solution is: $correctAnswer";
        updateProgress(isCorrect);
        showNextButton = true; // Show the "Next" button
      } else {
        feedbackMessage = "Wrong! The correct solution is: $correctAnswer";
        updateProgress(isCorrect);
        showNextButton = true; // Show the "Next" button
      }
      resultMessage =
          "Correct Answers: $correctCounter | Wrong Answers: $wrongCounter";
      // style: TextStyle(fontSize: 18),
      // textAlign: TextAlign.center,*/
    });
  }

  double shrinkFont(String word){
    List<String> words = word.split(' ');

// Determine the length of the longest word
    //int maxLength = words.fold(0, (max, word) => word.length > max ? word.length : max);

// Check if any word is longer than 13 characters
    bool anyLongerThan13 = words.any((word) => word.length > 13);

// Set the font size conditionally
    double fontSize = anyLongerThan13 ? 16.0 : 22.0;

    return fontSize;
  }

  Widget displayAdditionalInfo(bool solutionGiven, bool isCorrect) {

    //print( "im in add info");
    //print(solutionGiven);
    //print(isCorrect);
    if (!hintsOn) {
      return SizedBox.shrink(); // Return an empty widget if hints are off
    }

    // Switch based on whichCase
    switch (whichCase) {
      case 0:
        return Column(
          children: [Container(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: kPrimaryGradient, // Apply the gradient background
                    borderRadius: BorderRadius.circular(10),  // Apply the gradient background
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        "Imperfectum:",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  // Add space between "Infinitive" and the divider
                  Container(
                    height: 30,
                    // Adjust the height of the divider according to your UI design
                    width: 2,
                    // Set the width of the vertical divider
                    color: Colors.white, // Set color of the divider
                  ),
                  SizedBox(width: 10),
                  // Add space between the divider and "$infinitive"
                  Expanded(
                    child: Center(
                      child: Text(
                        solutionGiven
                            ? isCorrect
                            ? "$imperfectum"
                            : "$imperfectum"
                            : "?",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: solutionGiven
                              ? isCorrect
                              ? Colors.green // Dark green color
                              : Colors.red // Dark red color
                              : Colors.white, // Default color
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: kPrimaryGradient, // Apply the gradient background
                    borderRadius: BorderRadius.circular(10),  // Apply the gradient background
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          "Perfectum:",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    // Add space between "Infinitive" and the divider
                    Container(
                      height: 30,
                      // Adjust the height of the divider according to your UI design
                      width: 2,
                      // Set the width of the vertical divider
                      color: Colors.white, // Set color of the divider
                    ),
                    SizedBox(width: 10),
                    // Add space between the divider and "$infinitive"
                    Expanded(
                      child: Center(
                        child: Text(
                          "$perfectum",
                          style: TextStyle(
                              fontSize: shrinkFont(perfectum),
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: kPrimaryGradient, // Apply the gradient background
                    borderRadius: BorderRadius.circular(10),  // Apply the gradient background
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          "Translation:",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    // Add space between "Infinitive" and the divider
                    Container(
                      height: 30,
                      // Adjust the height of the divider according to your UI design
                      width: 2,
                      // Set the width of the vertical divider
                      color: Colors.white, // Set color of the divider
                    ),
                    SizedBox(width: 10),
                    // Add space between the divider and "$infinitive"
                    Expanded(
                      child: Center(
                        child: Text(
                          "$translation",
                          style: TextStyle(
                              fontSize: shrinkFont(translation),
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      case 1:
        return Column(
          children: [Container(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: kPrimaryGradient, // Apply the gradient background
                    borderRadius: BorderRadius.circular(10),  // Apply the gradient background
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        "Imperfectum:",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  // Add space between "Infinitive" and the divider
                  Container(
                    height: 30,
                    // Adjust the height of the divider according to your UI design
                    width: 2,
                    // Set the width of the vertical divider
                    color: Colors.white, // Set color of the divider
                  ),
                  SizedBox(width: 10),
                  // Add space between the divider and "$infinitive"
                  Expanded(
                    child: Center(
                      child: Text(
                        "$imperfectum",
                        style: TextStyle(
                            fontSize: shrinkFont(imperfectum),
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: kPrimaryGradient, // Apply the gradient background
                    borderRadius: BorderRadius.circular(10),  // Apply the gradient background
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          "Perfectum:",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    // Add space between "Infinitive" and the divider
                    Container(
                      height: 30,
                      // Adjust the height of the divider according to your UI design
                      width: 2,
                      // Set the width of the vertical divider
                      color: Colors.white, // Set color of the divider
                    ),
                    SizedBox(width: 10),
                    // Add space between the divider and "$infinitive"
                    Expanded(
                      child: Center(
                        child: Text(
                          solutionGiven
                              ? isCorrect
                              ? "$perfectum"
                              : "$perfectum"
                              : "?",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: solutionGiven
                                ? isCorrect
                                ? Colors.green // Dark green color
                                : Colors.red // Dark red color
                                : Colors.white, // Default color
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: kPrimaryGradient, // Apply the gradient background
                    borderRadius: BorderRadius.circular(10),  // Apply the gradient background
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          "Translation:",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    // Add space between "Infinitive" and the divider
                    Container(
                      height: 30,
                      // Adjust the height of the divider according to your UI design
                      width: 2,
                      // Set the width of the vertical divider
                      color: Colors.white, // Set color of the divider
                    ),
                    SizedBox(width: 10),
                    // Add space between the divider and "$infinitive"
                    Expanded(
                      child: Center(
                        child: Text(
                          "$translation",
                          style: TextStyle(
                              fontSize: shrinkFont(translation),
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      case 2:
        return Column(
          children: [Container(padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: kPrimaryGradient, // Apply the gradient background
                    borderRadius: BorderRadius.circular(10),  // Apply the gradient background
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        "Imperfectum:",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  // Add space between "Infinitive" and the divider
                  Container(
                    height: 30,
                    // Adjust the height of the divider according to your UI design
                    width: 2,
                    // Set the width of the vertical divider
                    color: Colors.white, // Set color of the divider
                  ),
                  SizedBox(width: 10),
                  // Add space between the divider and "$infinitive"
                  Expanded(
                    child: Center(
                      child: Text(
                        "$imperfectum",
                        style: TextStyle(
                            fontSize: shrinkFont(imperfectum),
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
            Container(padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: kPrimaryGradient, // Apply the gradient background
                    borderRadius: BorderRadius.circular(10),  // Apply the gradient background
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          "Perfectum:",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    // Add space between "Infinitive" and the divider
                    Container(
                      height: 30,
                      // Adjust the height of the divider according to your UI design
                      width: 2,
                      // Set the width of the vertical divider
                      color: Colors.white, // Set color of the divider
                    ),
                    SizedBox(width: 10),
                    // Add space between the divider and "$infinitive"
                    Expanded(
                      child: Center(
                        child: Text(
                          "$perfectum",
                          style: TextStyle(
                              fontSize: shrinkFont(perfectum),
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: kPrimaryGradient, // Apply the gradient background
                    borderRadius: BorderRadius.circular(10),  // Apply the gradient background
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          "Translation:",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    // Add space between "Infinitive" and the divider
                    Container(
                      height: 30,
                      // Adjust the height of the divider according to your UI design
                      width: 2,
                      // Set the width of the vertical divider
                      color: Colors.white, // Set color of the divider
                    ),
                    SizedBox(width: 10),
                    // Add space between the divider and "$infinitive"
                    Expanded(
                      child: Center(
                        child: Text(
                          solutionGiven
                              ? isCorrect
                              ? translation
                              : translation
                              : "?",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: solutionGiven
                                ? isCorrect
                                ? Colors.green // Dark green color
                                : Colors.red // Dark red color
                                : Colors.white, // Default color
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
        title: Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Text(
            "FLASH DUTCH",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
        //backgroundColor: Colors.pink,
        elevation: 0,
        actions: [
          // Add a button to toggle hints
          Padding(
            padding: EdgeInsets.only(top: 16.0, right: 8.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: kPrimaryGradient,
                borderRadius:
                    BorderRadius.circular(16), // Adjust the radius as needed
              ),
              child: TextButton(
                onPressed: () {
                  // Toggle the hintsOn variable
                  setState(() {
                    hintsOn = !hintsOn;
                  });
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor:
                      Colors.transparent, // Set background color to transparent
                ),
                child: Text(
                  hintsOn ? 'Hints: ON' : 'Hints: OFF',
                  style: TextStyle(color: Colors.black),
                ),
              ),
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
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4), // Add padding around the container
              child: Container(
                padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: kPrimaryGradient, // Apply the gradient background
                    borderRadius: BorderRadius.circular(10), // Set rounded corners
                  ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          "Infinitive:",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    // Add space between "Infinitive" and the divider
                    Container(
                      height: 30,
                      // Adjust the height of the divider according to your UI design
                      width: 2,
                      // Set the width of the vertical divider
                      color: Colors.white, // Set color of the divider
                    ),
                    SizedBox(width: 10),
                    // Add space between the divider and "$infinitive"
                    Expanded(
                      child: Center(
                        child: Text(
                          "$infinitive",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            /*SizedBox(height: 10),
            if (prompt == "translation")
              Text(
                "Translate to English",
                style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
              )
            else
              Text(
                "Conjugate in $prompt",
                style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
              ),*/
            //SizedBox(height: 20),
            displayAdditionalInfo(solutionGiven, isCorrect),
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
            SizedBox(height: 5),
            // Only show the TextField when the "Next" button is not visible
            if (!showNextButton)
              Container(
                child: TextField(
                  onSubmitted: (input) {
                    // Handle user input
                    handleUserInput(input);
                  },
                  decoration: InputDecoration(
                    hintText: "Type your answer here",
                    border: InputBorder.none,
                    // Remove default border
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.tealAccent, width: 2),
                      // Set border color to green
                      borderRadius:
                          BorderRadius.circular(8), // Set border radius
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.tealAccent, width: 2),
                      // Set border color to green
                      borderRadius:
                          BorderRadius.circular(8), // Set border radius
                    ),
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),

            SizedBox(height: 20),
            // Show the "Next" button when it's visible
            if (showNextButton)
              Container(
                decoration: BoxDecoration(
                  gradient: kPrimaryGradient,
                  borderRadius:
                      BorderRadius.circular(8), // Adjust the radius as needed
                ),
                child: ElevatedButton(
                  onPressed: () {

                    solutionGiven = false;
                    isCorrect = false;
                    // Load a new verb for the next question
                    selectRandomVerb();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    // Set background color to transparent
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          8), // Adjust the radius as needed
                    ),
                  ),
                  child: Text(
                    "Next",
                    style: TextStyle(
                      fontSize: 18, // Adjust the font size as needed
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
