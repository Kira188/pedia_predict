import 'package:flutter/material.dart';
import 'package:pedia_predict/gradient_scaffold.dart';
import 'package:pedia_predict/image_question.dart';
import 'package:pedia_predict/utils/database_helper.dart';
import 'package:pedia_predict/questions_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedia_predict/providers.dart';

class PsssResult extends ConsumerWidget {
  final int score;
  final int habitType;
  final String appBarText;

  const PsssResult({
    super.key,
    required this.score,
    required this.habitType,
    required this.appBarText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbHelper = ref.read(databaseHelperProvider); // Use provider here

    String resultTitle;
    String risk;

    switch (habitType) {
      case 0:
        resultTitle = 'Physical Activity';
        risk = score >= 0 && score <= 44 ? 'High Risk' : 'Low Risk';
        break;
      case 1:
        resultTitle = 'Sedentary Habits';
        risk = score >= 0 && score <= 14 ? 'Low Risk' : 'High Risk';
        break;
      case 2:
        resultTitle = 'Mental Health And Wellbeing';
        risk = score >= 0 && score <= 8 ? 'Low Risk' : 'High Risk';
        break;
      case 3:
        resultTitle = 'Sleeping Habits';
        risk = score >= 0 && score <= 9 ? 'Low Risk' : 'High Risk';
        break;
      case 4:
        resultTitle = 'Eating Habits';
        risk = score >= 0 && score <= 20 ? 'Low Risk' : 'High Risk';
        break;
      default:
        resultTitle = 'Result';
        risk = '404: Risk Not Found';
    }

    _saveResultsToDatabase(dbHelper, resultTitle, score, risk);

    return GradientScaffold(
      appBarText: appBarText,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Your score is: $score\n Calculated Risk is: $risk',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  if (habitType == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QuestionsScreen(
                          pageTitle: 'Physical Activity',
                          startIndex: 21,
                          endIndex: 29,
                        ),
                      ),
                    );
                  } else if (habitType == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QuestionsScreen(
                          pageTitle: 'Mental Health\nAnd Wellbeing',
                          startIndex: 16,
                          endIndex: 18,
                        ),
                      ),
                    );
                  } else if (habitType == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ImageQuestion(
                          ver: 1,
                        ),
                      ),
                    );
                  } else if (habitType == 4) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QuestionsScreen(
                          pageTitle: "Eating Habits",
                          startIndex: 12,
                          endIndex: 15,
                        ),
                      ),
                    );
                  } else {
                    // Dispose all notifiers when navigating back to the home page
                    ProviderManager.resetAllProviders(ref);

                    Navigator.popUntil(
                      context,
                      (route) => route.isFirst,
                    );
                  }
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveResultsToDatabase(DatabaseHelper dbHelper, String resultTitle, int score, String risk) async {
    int sdcId = await dbHelper.getLatestSdcId(); // Retrieve the latest student ID or use a specific ID

    await dbHelper.insertRemainingTableQuestion(
      sdcId,
      '$resultTitle: score',
      score.toString(),
    );

    await dbHelper.insertRemainingTableQuestion(
      sdcId,
      '$resultTitle: risk',
      risk,
    );
  }
}
