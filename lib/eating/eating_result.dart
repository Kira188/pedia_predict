import 'package:flutter/material.dart';
import 'package:pedia_predict/gradient_scaffold.dart';
import 'package:pedia_predict/utils/database_helper.dart';
import 'package:pedia_predict/questions_screen.dart';

class EatingResult extends StatelessWidget {
  final int eatingScore;
  final DatabaseHelper dbHelper;

  const EatingResult(
      {super.key, required this.eatingScore, required this.dbHelper});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      showBackButton: false, // Turn off back button
      appBarText: "Eating Habits Result",
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Your Eating Score is: $eatingScore",
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return QuestionsScreen(
                    startIndex: 12,
                    endIndex: 15,
                    dbHelper: dbHelper,
                  );
                }));
              },
              child: const Text(
                "OK",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
