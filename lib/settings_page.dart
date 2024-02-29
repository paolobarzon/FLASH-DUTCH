import 'package:flutter/material.dart';
import 'package:simple_app_simple/screens/Choosing%20Thema/choosing_thema.dart';
import '../../constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isFlagSwapped = false;
  String message =
      'The words to guess are now in English; the solutions are in Dutch.';

  void toggleFlagPosition() {
    setState(() {
      isFlagSwapped = !isFlagSwapped;
      message = isFlagSwapped
          ? 'The words to guess are now in Dutch; the solutions are in English.'
          : 'The words to guess are now in English; the solutions are in Dutch.';
    });
  }

  void resetData() {
    // Reset data
    mySharedPreferences.clear();

    // Trigger a rebuild of the widget tree
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    // Default to false if args is null or not a bool
    isFlagSwapped = args is bool ? args : false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          title: Text(
            'Settings',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, isFlagSwapped);
              }),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: toggleFlagPosition,
                child: isFlagSwapped
                    ? Image.asset(
                        'assets/dutch.png.png',
                        height: 60,
                        width: 80,
                      )
                    : Image.asset(
                        'assets/english_flag.png',
                        height: 60,
                        width: 80,
                      ),
              ),
              SizedBox(height: 5),
              Icon(Icons.arrow_downward, size: 48),
              SizedBox(height: 5),
              GestureDetector(
                onTap: toggleFlagPosition,
                child: isFlagSwapped
                    ? Image.asset(
                        'assets/english_flag.png',
                        height: 60,
                        width: 80,
                      )
                    : Image.asset(
                        'assets/dutch.png.png',
                        height: 60,
                        width: 80,
                      ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  gradient: kPrimaryGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(20),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.black, // Set text color to black
                    fontWeight: FontWeight.bold, // Make text bold
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Click on the flags to change',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 180),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    resetData();
                    Navigator.of(context).pop(); // Optionally, go back to the previous screen after resetting.
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Background color
                    padding: EdgeInsets.all(20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    'Reset Progress',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
