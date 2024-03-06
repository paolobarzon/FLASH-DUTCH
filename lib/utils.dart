import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_app_simple/screens/Choosing%20Thema/choosing_thema.dart';

import 'constants.dart';

int generateRandomNumber(int min, int max) {
  Random random = Random();
  return min + random.nextInt(max - min + 1);
}

void playLocalAsset() {
  final player = AudioPlayer();
  player.play(AssetSource('correct.mp3'));
}

void playLocalAssetWrong() {
  final player = AudioPlayer();
  player.play(AssetSource('wrong.mp3'));
}

void playLocalAssetEndLevel() {
  final player = AudioPlayer();
  player.play(AssetSource('end level.wav'));
}

void storeData(String key, bool value1, bool value2) {
  mySharedPreferences.setBool('$key-value1', value1);
  mySharedPreferences.setBool('$key-value2', value2);
}

/*Widget buildCard(BuildContext context,
    List<List<dynamic>> _data,
    bool isEnglishFlagVisible,
    int isCorrectNUM,
    String level,
    int thema,
    int section,
    int index,
    bool isCorrect,
    int column,
    Function() onTap) {
  ////print( "hey");
  ////print('$level, $thema, $section $column, index is $index');
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
  ////print("first try at getting the word: $mainString");
  //int newIndex = searchInCSV(thema, section) + 1;
  //Color backgroundColor = Colors.transparent;

// Assuming this part is executed when you initially set up the quizlet:
  if (isThisTheFirstWordEverOfTheQuizlet) {
    List<int> indices = searchInCSV(level, thema, section);
    //print(indices);
    int indexStart = indices[0] + 1;
    int indexEnd = indices[1] - 1;
    numberOfcircles = indexEnd - indexStart + 1;
    //print("number of circles is $numberOfcircles");

    // Initialize the list of indices and shuffle it
    shuffledIndices =
        List.generate(indexEnd - indexStart + 1, (i) => indexStart + i);
    shuffledIndices.shuffle();
    //print("Shuffled indices: $shuffledIndices");

    // Set the first word based on the shuffled list
    mainString = _data[shuffledIndices[currentIndex]][column].toString();
    isThisTheFirstWordEverOfTheQuizlet = false;
    indexOfTheWordToGuess = shuffledIndices[currentIndex];
  } else {
    if ((column == 0 && isEnglishFlagVisible) ||
        (column == 1 && !isEnglishFlagVisible)) {
      if (++currentIndex < shuffledIndices.length) {
        indexOfTheWordToGuess = shuffledIndices[currentIndex];
        mainString = _data[indexOfTheWordToGuess][column].toString();
      } else {
        // All words have been displayed, handle this case as needed
        ////print("All words have been displayed.");
      }
      //indexOfTheWordToGuess++; //sequentially show the words from the thema/section
      ////print("first word of the quizlet $indexOfTheWordToGuess");
      ////print(
      //    "now this: $indexOfTheWordToGuess should be going up consequentially");
      //mainString = _data[indexOfTheWordToGuess][column].toString();
    } else {
      if (indexOfDutchWord == index) {
        mainString = _data[indexOfDutchWord][column].toString();
        ////print("are they ever the same?");
      }
      //index++;
      else {
        mainString = _data[index][column].toString();
      }
    }
  }
  ////print(index);

  ////print(mainString);
  //mainString = _data[index][column].toString();
  ////print("first try at getting the word: $mainString");
  ////print("we are identifying the type... $index and $indexOfDutchWord should be the same");
  ////print("index of dutch word:");
  ////print(indexOfDutchWord);
  ////print("index");
  ////print(index);
  ////print("column");
  ////print(column);
  if (column == 0 && isEnglishFlagVisible) {
    indexOfDutchWord = index;
    ////print("now $indexOfDutchWord and $index are equal");
    if (mainString.endsWith(articleCheck) |
    mainString.endsWith(articleCheck2)) {
      isArticle = true;
    } else {
      if ( //mainString.endsWith(verbCheck) &&
      _data[indexOfTheWordToGuess][1]
          .toString()
          .startsWith(verbCheckEN)) {
        isVerb = true;
      } else {
        isOther = true;
      }
    }
    ////print(mainString);
    ////print(isArticle);
    ////print(isVerb);
    ////print(isOther);
    ////print("is it a dutch verb and a english verb??");
    ////print(mainString.endsWith(verbCheck));
    ////print(_data[indexOfTheWordToGuess][1].toString().startsWith(verbCheckEN));
    ////print("index is $indexOfTheWordToGuess, word is");
    ////print(_data[indexOfTheWordToGuess][1].toString());
  } else {
    if (column == 1 && !isEnglishFlagVisible) {
      indexOfDutchWord = index;
      if (mainString.endsWith(articleCheckEN)) {
        isArticle = true;
        ////print("art");
      } else {
        if (mainString.startsWith(verbCheckEN)
        //&& _data[index][0].toString().endsWith(verbCheck)
        ) {
          isVerb = true;
          ////print("verb");
        } else {
          isOther = true;
          ////print("oth");
        }
      }
    }
    ////print(mainString);
    ////print(isArticle);
    ////print(isVerb);
    ////print(isOther);
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
    mainString = 'Het $middleString';
  }
  if ((mainString.endsWith(" de") || (mainString.endsWith(" (de)")))) {
    var middleString = mainString.replaceAll(articleCheck, '').trim();
    //var newString = mainString.substring(mainString.length - 3);
    mainString = 'De $middleString';
  }
  if (mainString.endsWith(" the")) {
    var middleString = mainString.replaceAll(articleCheckEN, '').trim();
    mainString = 'The $middleString';
  }

  mainString = modifyDisplayedTextForThe(mainString);
  mainString = capitalize(mainString);
  ////print(mainString);
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
    child: Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: !(column == 0 && isEnglishFlagVisible) ||
            !(column == 1 && !isEnglishFlagVisible)
            ? kPrimaryGradient
            : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Card(
        elevation: 0, // Set elevation to 0 to make the card flat
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            width: 2, // Set border width
            color: Colors
                .transparent, // Initially set border color to transparent
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: (column == 0 && isEnglishFlagVisible) ||
                (column == 1 && !isEnglishFlagVisible)
                ? kPrimaryGradient
                : null,
            color: (column != 0 || !isEnglishFlagVisible) &&
                (column != 1 || isEnglishFlagVisible)
                ? Colors
                .black // Set the background to white if the condition is not met
                : null, // Otherwise, keep the background color null
          ),
          padding: const EdgeInsets.all(16),
          width: cardWidth,
          height: MediaQuery.of(context).size.height * 0.12, // 10% of screen height

          child: Align(
            alignment: Alignment.center,
            child: Text(
              (column == 0 && isEnglishFlagVisible) ||
                  (column == 1 && !isEnglishFlagVisible)
                  ? mainString
                  : getCorrectString(isEnglishFlagVisible, index, column,
                  isArticle, isVerb, isOther),
              style: TextStyle(
                fontSize: (column == 0 && isEnglishFlagVisible) ||
                    (column == 1 && !isEnglishFlagVisible)
                    ? getAdjustedFontSize(context, 28) // Adjusts the font size dynamically
                    : getAdjustedFontSize(context, 24),
                fontWeight: (column == 0 && isEnglishFlagVisible) ||
                    (column == 1 && !isEnglishFlagVisible)
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: (column == 0 && isEnglishFlagVisible) ||
                    (column == 1 && !isEnglishFlagVisible)
                    ? Colors.black
                    : Colors.white,
              ),
              softWrap: true,
            ),
          ),
        ),
      ),
    ),
  );
}

OverlayEntry _createOverlayEntry(isCorrect) {
  overlayEntry = OverlayEntry( // Use the class-level variable
    builder: (context) => Stack(
      children: [
        Positioned(
          left: 0,
          top: MediaQuery.of(context).size.height * 4 / 5 - 25, // 3/4 down
          right: 0,
          child:  GestureDetector(
            onTap: () {
              print("Overlay button tapped!");
              if (isCorrect) {
                overlayEntry.remove();
                setState(() {
                  // Reset hasAnsweredCorrectly when moving to the next card
                  hasAnsweredCorrectly = false;
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
                  if (displayedCardsCount == numberOfcircles) {
                    completelyCorrect = wrongAnswers == 0;
                    storeData(widget.quizletId, true, completelyCorrect);
                    // Call onQuizletCompleted() when quizlet is completed
                    onQuizletCompleted(selectedQuizlet, widget.level, widget.row,
                        widget.column)
                        .then((prefs) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SuckerPage(
                            rightAnswers: rightAnswers,
                            wrongAnswers: wrongAnswers,
                            whatWasIdoing: "questions",
                            level: widget.level,
                            row: widget.row,
                            column: widget.column,
                            isEnglishFlagVisible: widget.isEnglishFlagVisible,
                            // Pass the SharedPreferences instance
                            difficulty: '',
                          ),
                        ),
                      );
                    });
                  }
                });
              }
              else{
                overlayEntry.remove();

              }
              // Perform your action here
            },
            child: Container(
              /*width: 250, // Button width
                  height: 150, // Button height*/
              decoration: BoxDecoration(
                color: isCorrect ? Colors.green : Colors.red,
                // Button color
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
              child: IntrinsicWidth(
                // Use IntrinsicWidth to size the container to its child's width
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    // Minimize the row's width to fit its children
                    children: [
                      Icon(
                        isCorrect ? Icons.check : Icons.close,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        isCorrect ? "Correct!" : "Wrong!",
                        style: const TextStyle(
                          fontSize: 28.0,
                          fontFamily: 'Roboto',
                          // Set the font family for this Text widget to Roboto
                          color: Colors.black,
                          decoration: TextDecoration
                              .none, // Ensure no underline is applied
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
  return overlayEntry;
}*/