import 'package:country_icons/country_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_app_simple/constants.dart';
import 'package:simple_app_simple/screens/quiz/quiz_screen.dart';
import 'package:simple_app_simple/models/questions.dart';
import 'package:simple_app_simple/screens/Choosing Thema/choosing_thema.dart';
import '../../models/sucker_page.dart';
import '../../models/verbs.dart';
import '../Choosing Thema/choosing_verbs.dart';

class WelcomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(children: [
        SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const Spacer(flex: 2),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Image.asset(
                'assets/FLASHDUTCH.png', // Replace 'assets/flash_dutch.png' with the actual path to your image
                width: screenWidth, // Set the width of the image to the screen width
              ),
              /*child: Text(
                "FLASH DUTCH",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),*/
            ),
            Column(
              children: [
                InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ButtonPage(
                                completelyCorrect: completelyCorrect,
                              ))),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(kDefaultPadding * 0.75),
                    decoration: const BoxDecoration(
                      gradient: kPrimaryGradient,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: const Text(
                      "VOCABULARY",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                // Adjust the spacing between the buttons as needed
                InkWell(
                  onTap: () => Get.to(() => DifficultySelectionPage(
                      )),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(kDefaultPadding * 0.75),
                    decoration: const BoxDecoration(
                      gradient: kPrimaryGradient,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: const Text(
                      "VERBS",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(flex: 2),
          ]),
        ))
      ]),
    );
  }
}
