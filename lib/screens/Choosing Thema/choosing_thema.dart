import 'package:flutter/material.dart';
import 'package:simple_app_simple/screens/welcome/welcome_screen.dart';

import '../../models/questions.dart';

class ButtonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Button Page'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemCount: 60,
        itemBuilder: (context, index) {
          int row = index ~/ 4 + 1;
          int column = (index % 4) + 1;
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(row: row, column: column),
                ),
              );
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'A2/B1 - $row - $column',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}