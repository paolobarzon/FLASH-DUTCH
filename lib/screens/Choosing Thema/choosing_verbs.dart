import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants.dart';
import '../../models/verbs.dart';

class DifficultySelectionPage extends StatelessWidget {
  const DifficultySelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0), // Set the preferred height
        child: AppBar(
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
                  SizedBox(width: 80),
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
          //backgroundColor: Colors.pink,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          children: [
            Text(
              'Select the difficulty:',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyVerbs(
                            difficulty: "easy",
                          ))),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(kDefaultPadding * 0.75),
                decoration: const BoxDecoration(
                  gradient: kPrimaryGradient,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: const Text(
                  "EASY",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
            ),

            const SizedBox(height: 16),
            // Adjust the spacing between the buttons as needed
            InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyVerbs(
                        difficulty: "hard",
                      ))),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(kDefaultPadding * 0.75),
                decoration: const BoxDecoration(
                  gradient: kPrimaryGradient,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: const Text(
                  "HARD",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
