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
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/Choosing Thema/choosing_thema.dart';

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
  // Retrieve selected quizlet
  String quizlet = selectedQuizlet;
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
    //thema);
    //print(section);
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
        //print(_data[i]);
        //print("data i above, i below");
        //print(i);
        index1 = i;
        //return i;
      }
    }
    for (int i = index1 + 1; i < _data.length; i++) {
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

  // Function to handle quizlet completion
  void onQuizletCompleted(String quizletId, int row, int column) {
    // Store information about completed quizlet (e.g., in shared preferences)
    // Example using shared_preferences:
    SharedPreferences.getInstance().then((prefs) {
      // Set a flag indicating the completion status of the quizlet
      prefs.setBool('A2/B1 - $row - $column', true);
    });
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

  bool containsANumber(String str) {
    RegExp numberRegex = RegExp(r'\d+');
    return numberRegex.hasMatch(str);
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
    //print("ehre should be the same as above: $mainString");
    //print('we enter getcorrectstring with $index as index and $indexOfDutchWord');

    //print ma

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
                mainString.endsWith(articleCheckEN) |
                containsANumber(mainString)) {
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
                mainString.endsWith(articleCheck2) |
                containsANumber(mainString)) {
              //print("check other");
              //print(mainString);
              index++;
              mainString = _data[index][column]
                  .toString(); // Move to the next index until the condition is met
            }
        }
      }
    }
    //print("are they still the same? $index $indexOfDutchWord");
    if(indexOfDutchWord == index){
      mainString = _data[indexOfDutchWord][column].toString();
    }
    //print("I selected");
    //print("it changed to $mainString");
    // Additional logic for isVerb, isOther, etc.
    /*String displayedText = _data[index][column].toString();
    if (displayedText.endsWith(" het") || displayedText.endsWith(" de")) {
      displayedText = "${displayedText
          .split(' ')
          .last} ${displayedText
          .split(' ')
          .first}";

     */
    if (containsNumber(mainString)) {
      //print("ah ha $mainString $index");
      mainString = _data[index + 1][column].toString();
    }
    RegExp numberRegex = RegExp(r'\d+');
    bool doesItcontainsNumber = numberRegex.hasMatch(mainString);
    if (doesItcontainsNumber) {
      // If the string contains a number, replace it with a new string
      mainString = _data[index + 1][column]
          .toString(); // Replace "New String" with your desired replacement
    }
    if (mainString.endsWith(" het")) {
      var middleString = mainString.replaceAll(articleCheck2, '').trim();
      //var newString = mainString.substring(mainString.length - 4);
      mainString = 'Het' + ' ' + middleString;
    }
    if (mainString.endsWith(" de")) {
      var middleString = mainString.replaceAll(articleCheck, '').trim();
      //var newString = mainString.substring(mainString.length - 3);
      mainString = 'De' + ' ' + middleString;
    }
    if (mainString.endsWith(" the")) {
      var middleString = mainString.replaceAll(articleCheckEN, '').trim();
      mainString = 'The' + ' ' + middleString;
    }
    String displayedText = mainString;
    displayedText = modifyDisplayedText(displayedText);

    //displayedText = _data[index][column].toString();
    displayedText = modifyDisplayedTextForThe(displayedText);

    if ((isEnglishFlagVisible && column == 0) ||
        (!isEnglishFlagVisible && column == 1)) {
    } else {
      // Split the displayedText into words
      List<String> words = displayedText.split(' ');

      // Check if any word in the list has a length greater than 13
      bool isWordLong = words.any((word) => word.length > 13);

      // Adjust the font size based on the result
      fontSize2 = isWordLong ? 18.0 : 24.0;

      if (displayedText.length > 19) {
        fontSize2 = 14.0;
      }
    }
    //print("it changed to $displayedText");
    return displayedText;
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  Widget buildCard(int thema, int section, int index, bool isCorrect,
      int column, Function() onTap) {
    //print("We enter with index $index");
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
    //print("first try at getting the word: $mainString");
    //int newIndex = searchInCSV(thema, section) + 1;

    if (isThisTheFirstWordEverOfTheQuizlet) {
      //newIndex++;
      List<int> indices = searchInCSV(thema, section);

      // Access the returned indices
      index = indices[0] + 1;
      int indexEnd = indices[1];
      numberOfcircles = indexEnd - index;
      //print("number of circles is $numberOfcircles");
      //index, indexEnd = searchInCSV(thema, section) + 1;
      mainString = _data[index][column].toString();
      isThisTheFirstWordEverOfTheQuizlet = false;
      indexOfTheWordToGuess = index;
      //print(
      //    "the very first index of the thema section is $index, which is the same of $indexOfTheWordToGuess");
    } else {
      if ((column == 0 && isEnglishFlagVisible) ||
          (column == 1 && !isEnglishFlagVisible)) {
        indexOfTheWordToGuess++; //sequentially show the words from the thema/section
        //print("first word of the quizlet $indexOfTheWordToGuess");
        //print(
        //    "now this: $indexOfTheWordToGuess should be going up consequentially");
        mainString = _data[indexOfTheWordToGuess][column].toString();
      } else {
        if (indexOfDutchWord == index) {
          mainString = _data[indexOfDutchWord][column].toString();
          //print("are they ever the same?");
        }
        //index++;
        else {
          mainString = _data[index][column].toString();
        }
      }
    }
    //print(index);

    //print(mainString);
    //mainString = _data[index][column].toString();
    //print("first try at getting the word: $mainString");
    //print("we are identifying the type... $index and $indexOfDutchWord should be the same");
    //print("index of dutch word:");
    //print(indexOfDutchWord);
    //print("index");
    //print(index);
    //print("column");
    //print(column);
    if (column == 0 && isEnglishFlagVisible) {
      indexOfDutchWord = index;
      //print("now $indexOfDutchWord and $index are equal");
      if (mainString.endsWith(articleCheck) |
          mainString.endsWith(articleCheck2)) {
        isArticle = true;
      } else {
        if (mainString.endsWith(verbCheck) &&
            _data[index][1].toString().startsWith(verbCheckEN)) {
          isVerb = true;
        } else {
          isOther = true;
        }
      }
      //print(mainString);
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
          if (mainString.startsWith(verbCheckEN) &&
              _data[index][0].toString().endsWith(verbCheck)) {
            isVerb = true;
            //print("verb");
          } else {
            isOther = true;
            //print("oth");
          }
        }
      }
      //print(mainString);
      //print(isArticle);
      //print(isVerb);
      //print(isOther);
    }
    //String mainString = _data[index][column].toString();
    /*if (mainString.endsWith(" het") || mainString.endsWith(" de")) {
      List<String> words = mainString.split(' ');
      String article = words.removeLast(); // Remove the article from the end
      mainString = '$article ${words.join(' ')}'; // Concatenate the remaining words
    }*/
    while (containsANumber(mainString)) {
      mainString = _data[index++][column].toString();
    }
    if (mainString.endsWith(" het")) {
      var middleString = mainString.replaceAll(articleCheck2, '').trim();
      //var newString = mainString.substring(mainString.length - 4);
      mainString = 'Het' + ' ' + middleString;
    }
    if (mainString.endsWith(" de")) {
      var middleString = mainString.replaceAll(articleCheck, '').trim();
      //var newString = mainString.substring(mainString.length - 3);
      mainString = 'De' + ' ' + middleString;
    }
    if (mainString.endsWith(" the")) {
      var middleString = mainString.replaceAll(articleCheckEN, '').trim();
      mainString = 'The' + ' ' + middleString;
    }

    mainString = modifyDisplayedTextForThe(mainString);
    mainString = capitalize(mainString);
    //print(mainString);
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
                    if (displayedCardsCount == 3) {
                      //print(widget.row);
                      //print(widget.column);
                      // Call onQuizletCompleted() when quizlet is completed
                      onQuizletCompleted(
                          selectedQuizlet, widget.row, widget.column);
                      // Navigate to the new page with the "sucker" message
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SuckerPage(
                            rightAnswers: rightAnswers,
                            wrongAnswers: wrongAnswers,
                            whatWasIdoing: "questions",
                            row: widget.row,
                            column: widget.column,
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

    //print("im here once");
  }

  @override
  Widget build(BuildContext context) {
    bool isCorrect = false;
    int min = 0;
    int max = 3000;
    int row2 = widget.row;
    int column2 = widget.column;

    //print(numberOfcircles);
    //print(numberOfcircles);

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
              onPressed: () {
                // Handle the navigation accordingly, for example, pop the current screen
                Navigator.maybePop(
                    context); // Use maybePop to handle back navigation
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
                          //print("case 1");
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
                                        buildCard(row2, column2,
                                            indexOfTheWordToGuess, true, 1, () {
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
                          //print("case 2");
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
                                        buildCard(row2, column2,
                                            indexOfTheWordToGuess, true, 1, () {
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
                          //print("case 3");
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
                                        buildCard(row2, column2,
                                            indexOfTheWordToGuess, true, 1, () {
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
                          //print("case 4");
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
                                        buildCard(row2, column2,
                                            indexOfTheWordToGuess, true, 1, () {
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
