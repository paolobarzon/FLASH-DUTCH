import 'package:country_icons/country_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_app_simple/constants.dart';
import 'package:simple_app_simple/screens/quiz/quiz_screen.dart';
import 'package:simple_app_simple/models/questions.dart';
import 'package:simple_app_simple/screens/Choosing Thema/choosing_thema.dart';
import '../../models/verbs.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                      const Spacer(flex: 2),
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text("FLASH DUTCH",
                          style: TextStyle(fontWeight: FontWeight.bold,
                              fontSize: 30),),
                    ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ButtonPage())),
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(kDefaultPadding * 0.75),
                              decoration: const BoxDecoration(
                                gradient: kPrimaryGradient,
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                              ),
                              child: const Text(
                                "Vocabulary",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                            ),
                          ),

                          SizedBox(height: 16), // Adjust the spacing between the buttons as needed
                          InkWell(
                            onTap: () => Get.to(() => MyVerbs()),
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(kDefaultPadding * 0.75),
                              decoration: const BoxDecoration(
                                gradient: kPrimaryGradient,
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                              ),
                              child: const Text(
                                "Verbs",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Spacer(flex: 2),
                          ]
                  ),
                )
              )
            ]
        ),

    );
  }
}
