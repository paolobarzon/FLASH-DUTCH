import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as s;
import 'package:csv/csv.dart';
import 'dart:math';
import 'package:country_icons/country_icons.dart';
import 'package:simple_app_simple/main.dart';
import 'package:simple_app_simple/models/sucker_page.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

class MyHomePage extends StatefulWidget {
  final int row;
  final int column;

  const MyHomePage({
    Key? key,
    required this.row,
    required this.column,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<List<dynamic>> _data = [];
  Color myCardColor = Colors.white;

  String articleCheck = " de";
  String articleCheck2 = " het";
  String verbCheck = "en";
  String articleCheckEN = " the";
  String verbCheckEN = "to ";

  bool isArticle = false;
  bool isVerb = false;
  bool isOther = false;

  bool isA0A1Selected = false;
  bool isA2Selected = false;
  bool isA2B1Selected = true;

  bool showNextButton = true;
  int indexOfDutchWord = 0;

  int rightAnswers = 0;
  int wrongAnswers = 0;

  bool isEnglishFlagVisible = true;

  int displayedCardsCount = 0;
  bool isThisTheFirstTry = true;
  bool didIgetItWrongFirst = false;

  bool isThisTheFirstWordEverOfTheQuizlet = true;

  double fontSize2 = 24.0;

  int indexOfTheWordToGuess = 0;
  int numberOfcircles = 25;

  List<Widget> progressDots = List.generate(
    25,
    (index) => Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.0),
      // Adjust the horizontal padding as needed
      child: Icon(
        Icons.circle,
        size: 10.0, // Set the size as needed
        color: Colors.white,
      ),
    ),
  );

  List<int> searchInCSV(int thema, int section) {
    int index1 = 0;
    int index2 = 0;
    print(thema);
    print(section);
    // Get the path to the CSV file
    //String csvPath = 'C:\Users\paolo\AndroidStudioProjects\simple_app_simple\assets\wordscopy.csv'; // Update the path as needed
    final csvPath = rootBundle.loadString("assets/wordscopy.csv");

    // Read the CSV file
    //final File file = File(csvPath);
    // List<List<dynamic>> csvData = [];

    // Check if the file exists
    /* if (await file.exists()) {
      // Read the CSV file
      String csvString = await file.readAsString();

      // Parse the CSV string
      csvData = CsvToListConverter().convert(csvString);
    } else {
      throw Exception('CSV file not found.');
    }

     */
    //print(_data);
    //print(_data[2262][1]);
    // Iterate over the CSV data to find the index
    for (int i = 0; i < _data.length; i++) {
      // Check if the current row matches the search criteria
      if ( //_data[i].length >= 4 &&
          _data[i][0] == 'A2/B1' &&
              _data[i][1] == thema &&
              _data[i][2] == section) {
        // Return the index if a match is found
        print(_data[i]);
        print("data i above, i below");
        print(i);
        index1 = i;
        //return i;
      }
    }
    for (int i = index1+1; i < _data.length; i++) {
      if ( //_data[i].length >= 4 &&
      _data[i][0] == 'A2/B1') {
        // Return the index if a match is found
        //print(_data[i]);
        //print("data i above, i below");
        //print(i);
        index2 = i;
        //return i;
      }
    }

    // Return -1 if the value is not found
    return [index1, index2];
  }

  bool containsNumber(String input) {
    // Regular expression to match a number
    RegExp regex = RegExp(r'\d');
    // Check if the input string contains a number
    return regex.hasMatch(input);
  }


  void updateProgress(bool isCorrect) {
    int indexToUpdate = displayedCardsCount - 1;
    Icon updatedIcon = isCorrect
        ? Icon(Icons.check, color: Colors.green, size: 10.0)
        : Icon(Icons.close, color: Colors.red, size: 10.0);

    setState(() {
      progressDots[indexToUpdate] = updatedIcon;
    });
  }

  void _loadCSV() async {
    final rawData = await rootBundle.loadString("assets/wordscopy.csv");
    List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);
    setState(() {
      _data = listData;
    });
  }

  String modifyDisplayedTextForThe(String text) {
    if (text.endsWith(" the")) {
      text = "${text.split(' ').last} ${text.split(' ').first}";
    }
    return text;
  }

  String modifyDisplayedText(String text) {
    if (text.endsWith(" het") || text.endsWith(" de")) {
      text = "${text.split(' ').last} ${text.split(' ').first}";
    }
    return text;
  }

  String getCorrectString(
      int index, int column, bool isArticle, bool isVerb, bool isOther) {
    //print( "in function correct string");
    //print(isArticle);
    //print(isVerb);
    //print(isOther);
    //print("index of dutch word:");
    //print(indexOfDutchWord);
    //print("index");
    //print(index);
    String mainString = _data[index][column].toString();
    //print ma
    if (containsNumber(mainString)){
      print("ah ha $mainString $index");
      mainString = _data[index+1][column].toString();
    }
    //print(mainString);
    //print("contains article?");
    //print(mainString.contains(articleCheck));
    //print(mainString.contains(articleCheck2));
    //print("contains verb?");
    //print(mainString.contains(verbCheck));

    if (isEnglishFlagVisible) {
      if (isArticle & !(indexOfDutchWord == index)) {
        // Your logic to modify index based on isArticle
        while (!mainString.endsWith(articleCheckEN)) {
          //print("check article");
          index++;
          mainString = _data[index][column]
              .toString(); // Move to the next index until the condition is met
        }
      } else {
        if (isVerb & !(indexOfDutchWord == index)) {
          while (!mainString.startsWith(verbCheckEN)) {
            //print("check verb");
            //print(mainString);
            index++;
            mainString = _data[index][column]
                .toString(); // Move to the next index until the condition is met
          }
        } else {
          if (!(indexOfDutchWord == index))
            while (mainString.startsWith(verbCheckEN) |
                mainString.endsWith(articleCheckEN)) {
              //print("check other");
              //print(mainString);
              index++;
              mainString = _data[index][column]
                  .toString(); // Move to the next index until the condition is met
            }
        }
      }
    } else {
      if (isArticle & !(indexOfDutchWord == index)) {
        // Your logic to modify index based on isArticle
        while (!mainString.endsWith(articleCheck) &&
            !mainString.endsWith(articleCheck2)) {
          //print("check article");
          index++;
          mainString = _data[index][column]
              .toString(); // Move to the next index until the condition is met
        }
      } else {
        if (isVerb & !(indexOfDutchWord == index)) {
          while (!mainString.endsWith(verbCheck)) {
            //print("check verb");
            //print(mainString);
            index++;
            mainString = _data[index][column]
                .toString(); // Move to the next index until the condition is met
          }
        } else {
          if (!(indexOfDutchWord == index))
            while (mainString.endsWith(verbCheck) |
                mainString.endsWith(articleCheck) |
                mainString.endsWith(articleCheck2)) {
              //print("check other");
              //print(mainString);
              index++;
              mainString = _data[index][column]
                  .toString(); // Move to the next index until the condition is met
            }
        }
      }
    }
    //print("I selected");
    //print(mainString);
    // Additional logic for isVerb, isOther, etc.
    /*String displayedText = _data[index][column].toString();
    if (displayedText.endsWith(" het") || displayedText.endsWith(" de")) {
      displayedText = "${displayedText
          .split(' ')
          .last} ${displayedText
          .split(' ')
          .first}";

     */
    String displayedText = mainString;
    displayedText = modifyDisplayedText(displayedText);

    //displayedText = _data[index][column].toString();
    displayedText = modifyDisplayedTextForThe(displayedText);

    if ((isEnglishFlagVisible && column == 0) ||
        (!isEnglishFlagVisible && column == 1)) {
    } else {
      fontSize2 = (displayedText.length > 15) ? 18.0 : 24.0;
    }

    return displayedText;
  }

  Widget buildCard(int thema, int section, int index, bool isCorrect,
      int column, Function() onTap) {
    //print("function buildcard");
    //print("english flag?");
    //print(isEnglishFlagVisible);
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = (column == 1) ? screenWidth / 2 - 20 : screenWidth - 20;
    if (!isEnglishFlagVisible) {
      // If the English flag is not visible, adjust the column value
      if (column == 1) {
        column = 0;
      } else {
        column = 1;
      }
    }
    String mainString = _data[index][column].toString();
    //int newIndex = searchInCSV(thema, section) + 1;

    if (isThisTheFirstWordEverOfTheQuizlet) {
      //newIndex++;
      List<int> indices = searchInCSV(thema, section);

      // Access the returned indices
      int index = indices[0] + 1;
      int indexEnd = indices[1];
      numberOfcircles = indexEnd - index;
      print("number of circles is $numberOfcircles");
      //index, indexEnd = searchInCSV(thema, section) + 1;
      mainString = _data[index][column].toString();
      isThisTheFirstWordEverOfTheQuizlet = false;
      indexOfTheWordToGuess = index;
    } else {
      if ((column == 0 && isEnglishFlagVisible) ||
          (column == 1 && !isEnglishFlagVisible)) {
        indexOfTheWordToGuess++;
        print("first word of the quizlet $indexOfTheWordToGuess");
        mainString = _data[indexOfTheWordToGuess][column].toString();
      } else {
        //index++;
        mainString = _data[index][column].toString();
      }
    }
    print(index);

    print(mainString);


    //print("index of dutch word:");
    //print(indexOfDutchWord);
    //print("index");
    //print(index);
    //print("column");
    //print(column);
    if (column == 0 && isEnglishFlagVisible) {
      indexOfDutchWord = index;
      if (mainString.endsWith(articleCheck) |
          mainString.endsWith(articleCheck2)) {
        isArticle = true;
      } else {
        if (mainString.endsWith(verbCheck)) {
          isVerb = true;
        } else {
          isOther = true;
        }
      }
      print(mainString);
      //print(isArticle);
      //print(isVerb);
      //print(isOther);
    } else {
      if (column == 1 && !isEnglishFlagVisible) {
        indexOfDutchWord = index;
        if (mainString.endsWith(articleCheckEN)) {
          isArticle = true;
          //print("art");
        } else {
          if (mainString.startsWith(verbCheckEN)) {
            isVerb = true;
            //print("verb");
          } else {
            isOther = true;
            //print("oth");
          }
        }
      }
      print(mainString);
      //print(isArticle);
      //print(isVerb);
      //print(isOther);
    }
    //String mainString = _data[index][column].toString();
    if (mainString.endsWith(" het") || mainString.endsWith(" de")) {
      mainString =
          "${mainString.split(' ').last} ${mainString.split(' ').first}";
    }
    mainString = modifyDisplayedTextForThe(mainString);
    print(mainString);
    /*double fontSize2 = 24.0;
    if ((isEnglishFlagVisible && column==0) ||
        (!isEnglishFlagVisible && column==1)){
    }
    else{
      fontSize2 = (displayedText.length > 15) ? 18.0 : 24.0;
    }

     */

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(10),
        color: myCardColor,
        child: Container(
          padding: const EdgeInsets.all(16),
          width: cardWidth,
          height: 100,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              (column == 0 && isEnglishFlagVisible) |
                      (column == 1 && !isEnglishFlagVisible)
                  ? mainString
                  : getCorrectString(index, column, isArticle, isVerb, isOther),
              style: TextStyle(fontSize: fontSize2, color: Colors.black),
              softWrap: true, // Allow text to wrap to a new line
            ),
          ),
        ),
      ),
    );
  }

  void showMessage(bool isCorrect) {
    String message = isCorrect ? "Correct!" : "Wrong!";
    Color snackBarColor = isCorrect ? Colors.green : Colors.red;
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    double labelFontSize = 28.0; // Increased font size
    FontWeight labelFontWeight = FontWeight.bold;

    // Increment wrongAnswers when the answer is incorrect
    if (isThisTheFirstTry) {
      if (!isCorrect) {
        wrongAnswers++;
        didIgetItWrongFirst = true;
        isThisTheFirstTry = false;
      } else {
        rightAnswers++;
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isCorrect ? Icons.check : Icons.close,
                  color: Colors.white,
                ),
                SizedBox(width: 8.0),
                Text(
                  isCorrect ? "Correct!" : "Wrong!",
                  style: TextStyle(
                    fontSize: labelFontSize,
                    fontWeight: labelFontWeight,
                  ),
                ),
              ],
            ),
            /*SizedBox(height: 8.0),
          Row(
            children: [
              Icon(
                Icons.check,
                color: Colors.black, // Set the color to black
              ),
              SizedBox(width: 8.0),
              Text(
                '$rightAnswers',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 16.0), // Adjust spacing
              Icon(
                Icons.close,
                color: Colors.black, // Set the color to black
              ),
              SizedBox(width: 8.0),
              Text(
                '$wrongAnswers',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),*/
          ],
        ),
        duration: Duration(seconds: 300),
        backgroundColor: snackBarColor,
        action: isCorrect
            ? SnackBarAction(
                label: 'Next',
                onPressed: () {
                  setState(() {
                    isThisTheFirstTry = true;
                    displayedCardsCount++;
                    if (didIgetItWrongFirst) {
                      updateProgress(!isCorrect);
                    } else {
                      updateProgress(isCorrect);
                    }
                    didIgetItWrongFirst = false;
                    isCorrect = false;
                    isArticle = false;
                    isVerb = false;
                    isOther = false;
                    if (displayedCardsCount == 10) {
                      // Navigate to the new page with the "sucker" message
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SuckerPage(
                            rightAnswers: rightAnswers,
                            wrongAnswers: wrongAnswers,
                            whatWasIdoing: "questions",
                          ),
                        ),
                      );
                    }
                  });
                },
              )
            : SnackBarAction(
                label: 'Dismiss',
                onPressed: () {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                },
              ),
      ),
    );
    // Check if the user has answered 10 quizzes
  }

  void changeColor(String color) {
    if (color == "green") {
      // Change background color to green
      // For example, you can set the background color of a container or a card widget
      myCardColor =
          Colors.green; // Replace myCardColor with your actual variable
    } else {
      // Change background color to red
      myCardColor = Colors.red; // Replace myCardColor with your actual variable
    }
  }

  int generateRandomNumber(int min, int max) {
    Random random = Random();
    return min + random.nextInt(max - min + 1);
  }

  @override
  void initState() {
    super.initState();
    _loadCSV();
  }

  @override
  Widget build(BuildContext context) {
    bool isCorrect = false;
    int min = 0;
    int max = 3000;
    int row2 = widget.row;
    int column2 = widget.column;

    print(numberOfcircles);
    print(numberOfcircles);

    return Center(
        // Center the content vertically and horizontally
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      // Align the content to the center horizontally
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      // Align the content to the center vertically
      children: [
        Container(
          height: 100.0,
          child: AppBar(
            // Add an AppBar with a leading icon button
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              // You can use Icons.home for a home icon
              onPressed: () {
                // Handle the navigation accordingly, for example, pop the current screen
                Navigator.of(context).pop();
              },
            ),
            title: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "FLASH DUTCH",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 50),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isEnglishFlagVisible = !isEnglishFlagVisible;
                        isVerb = false;
                        isArticle = false;
                        isOther = false;
                      });
                    },
                    child: isEnglishFlagVisible
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
                  ),
                ],
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.pink,
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: Scaffold(
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isA0A1Selected = !isA0A1Selected; // Toggle the state
                          if (!isA0A1Selected &&
                              !isA2Selected &&
                              !isA2B1Selected) {
                            // Ensure at least one button is turned on
                            isA0A1Selected = true;
                          }
                          //isA2Selected = false;
                          //isA2B1Selected = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: isA0A1Selected ? Colors.pink : Colors.black,
                      ),
                      child: Text("A0/A1"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          //isA0A1Selected = false;
                          isA2Selected = !isA2Selected; // Toggle the state
                          if (!isA0A1Selected &&
                              !isA2Selected &&
                              !isA2B1Selected) {
                            // Ensure at least one button is turned on
                            isA2Selected = true;
                          }
                          //isA2B1Selected = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: isA2Selected ? Colors.pink : Colors.black,
                      ),
                      child: Text("A2"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          //isA0A1Selected = false;
                          //isA2Selected = false;
                          isA2B1Selected = !isA2B1Selected; // Toggle the state
                          if (!isA0A1Selected &&
                              !isA2Selected &&
                              !isA2B1Selected) {
                            // Ensure at least one button is turned on
                            isA2B1Selected = true;
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: isA2B1Selected ? Colors.pink : Colors.black,
                      ),
                      child: Text("A2/B1"),
                    ),
                  ],
                ),
                // Display the counter
                // Display the progress dots
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: progressDots,
                    /*List.generate(
                      numberOfcircles,
                          (index) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.0),
                        // Adjust the horizontal padding as needed
                        child: Icon(
                          Icons.circle,
                          size: 30.0, // Set the size as needed
                          color: Colors.white,
                        ),
                      ),
                    )
                      */
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (_, index) {
                      // Check if _data is not null and not empty
                      if (_data.isEmpty) {
                        return const CircularProgressIndicator();
                      }

                      Random random = Random();
                      if (isA0A1Selected && isA2Selected && !isA2B1Selected) {
                        // A0/A1 and A2 are selected
                        min = 1;
                        max = 2059;
                      } else if (isA0A1Selected &&
                          !isA2Selected &&
                          isA2B1Selected) {
                        // A0/A1 and A2/B1 are selected
                        min = 1;
                        max = 3300;
                      } else if (!isA0A1Selected &&
                          isA2Selected &&
                          isA2B1Selected) {
                        // A2 and A2/B1 are selected
                        min = 931;
                        max = 3300;
                      } else if (isA0A1Selected &&
                          !isA2Selected &&
                          !isA2B1Selected) {
                        // Only A0/A1 is selected
                        min = 1;
                        max = 930;
                      } else if (!isA0A1Selected &&
                          isA2Selected &&
                          !isA2B1Selected) {
                        // Only A2 is selected
                        min = 931;
                        max = 2059;
                      } else if (!isA0A1Selected &&
                          !isA2Selected &&
                          isA2B1Selected) {
                        // Only A2/B1 is selected
                        min = 2060;
                        max = 3300;
                      } else {
                        // None or all buttons are selected, handle accordingly
                      }
                      int randomIndex = generateRandomNumber(min, max);
                      int randomIndexSecondColumn =
                          generateRandomNumber(min, max);
                      int randomIndexThirdColumn =
                          generateRandomNumber(min, max);
                      int randomIndexFourthColumn =
                          generateRandomNumber(min, max);

                      int caseNumber = random.nextInt(4) + 1;
                      //print("row");
                      //print(row2);
                      //print("column");
                      //print(column2);

                      switch (caseNumber) {
                        case 1:
                          return Column(
                            children: [
                              buildCard(row2, column2, randomIndex,
                                  !random.nextBool(), 0, () {
                                isCorrect = !random.nextBool();
                              }),
                              const SizedBox(height: 40),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        buildCard(
                                            row2, column2, indexOfTheWordToGuess, true, 1,
                                            () {
                                          isCorrect = true;
                                          showMessage(isCorrect);
                                        }),
                                        buildCard(
                                            row2,
                                            column2,
                                            randomIndexSecondColumn,
                                            false,
                                            1, () {
                                          isCorrect = false;
                                          showMessage(isCorrect);
                                        }),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        buildCard(
                                            row2,
                                            column2,
                                            randomIndexThirdColumn,
                                            false,
                                            1, () {
                                          isCorrect = false;
                                          showMessage(isCorrect);
                                        }),
                                        buildCard(
                                            row2,
                                            column2,
                                            randomIndexFourthColumn,
                                            false,
                                            1, () {
                                          isCorrect = false;
                                          showMessage(isCorrect);
                                        }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );

                        case 2:
                          return Column(
                            children: [
                              buildCard(row2, column2, randomIndex,
                                  !random.nextBool(), 0, () {
                                isCorrect = !random.nextBool();
                              }),
                              const SizedBox(height: 40),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        buildCard(
                                            row2,
                                            column2,
                                            randomIndexSecondColumn,
                                            false,
                                            1, () {
                                          isCorrect = false;
                                          showMessage(isCorrect);
                                        }),
                                        buildCard(
                                            row2, column2, indexOfTheWordToGuess, true, 1,
                                            () {
                                          isCorrect = true;
                                          showMessage(isCorrect);
                                        }),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        buildCard(
                                            row2,
                                            column2,
                                            randomIndexThirdColumn,
                                            false,
                                            1, () {
                                          isCorrect = false;
                                          showMessage(isCorrect);
                                        }),
                                        buildCard(
                                            row2,
                                            column2,
                                            randomIndexFourthColumn,
                                            false,
                                            1, () {
                                          isCorrect = false;
                                          showMessage(isCorrect);
                                        }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );

                        case 3:
                          return Column(
                            children: [
                              buildCard(row2, column2, randomIndex,
                                  !random.nextBool(), 0, () {
                                isCorrect = !random.nextBool();
                              }),
                              const SizedBox(height: 40),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        buildCard(
                                            row2,
                                            column2,
                                            randomIndexSecondColumn,
                                            false,
                                            1, () {
                                          isCorrect = false;
                                          showMessage(isCorrect);
                                        }),
                                        buildCard(
                                            row2,
                                            column2,
                                            randomIndexThirdColumn,
                                            false,
                                            1, () {
                                          isCorrect = false;
                                          showMessage(isCorrect);
                                        }),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        buildCard(
                                            row2, column2, indexOfTheWordToGuess, true, 1,
                                            () {
                                          isCorrect = true;
                                          showMessage(isCorrect);
                                        }),
                                        buildCard(
                                            row2,
                                            column2,
                                            randomIndexFourthColumn,
                                            false,
                                            1, () {
                                          isCorrect = false;
                                          showMessage(isCorrect);
                                        }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );

                        case 4:
                          return Column(
                            children: [
                              buildCard(row2, column2, randomIndex,
                                  !random.nextBool(), 0, () {
                                isCorrect = !random.nextBool();
                              }),
                              const SizedBox(height: 40),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        buildCard(
                                            row2,
                                            column2,
                                            randomIndexSecondColumn,
                                            false,
                                            1, () {
                                          isCorrect = false;
                                          showMessage(isCorrect);
                                        }),
                                        buildCard(
                                            row2,
                                            column2,
                                            randomIndexThirdColumn,
                                            false,
                                            1, () {
                                          isCorrect = false;
                                          showMessage(isCorrect);
                                        }),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        buildCard(
                                            row2,
                                            column2,
                                            randomIndexFourthColumn,
                                            false,
                                            1, () {
                                          isCorrect = false;
                                          showMessage(isCorrect);
                                        }),
                                        buildCard(
                                            row2, column2, indexOfTheWordToGuess, true, 1,
                                            () {
                                          isCorrect = true;
                                          showMessage(isCorrect);
                                        }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        default:
                          return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
                /*Padding(
                  padding: const EdgeInsets.only(bottom: 70.0),
                  // Adjust the value as needed
                  child: Text(
                    'Correct Answers: $rightAnswers, Wrong Answers: $wrongAnswers',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),*/
              ],
            ),
            /* floatingActionButton: showNextButton
                ? FloatingActionButton(
                    child: const Icon(Icons.navigate_next_outlined),
                    onPressed: () {
                      setState(() {
                        showNextButton = false; // Hide the button again
                      });

                      isCorrect = false;
                      isArticle = false;
                      isVerb = false;
                      isOther = false;
                      _loadCSV();
                    },
                  )
                : null, // Set to null when you want to hide the button

             */
          ),
        ),
      ],
    ));
  }
}
