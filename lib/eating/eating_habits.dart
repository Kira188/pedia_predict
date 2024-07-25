import 'package:flutter/material.dart';
import 'package:pedia_predict/eating/eating_choice.dart';
import 'package:pedia_predict/models/eating_model.dart';
import 'package:pedia_predict/gradient_scaffold.dart';
import 'package:pedia_predict/eating/eating_result.dart';
import 'package:pedia_predict/utils/database_helper.dart';

class EatingHabits extends StatefulWidget {
  final DatabaseHelper dbHelper;

  const EatingHabits({super.key, required this.dbHelper});

  @override
  State<StatefulWidget> createState() {
    return _EatingHabitsState();
  }
}

class _EatingHabitsState extends State<EatingHabits> {
  EatingModel eatingData = EatingModel();

  void _openChoiceOverlay(Category category) async {
    final result = await showModalBottomSheet<Map<int, String>>(
      backgroundColor: const Color.fromARGB(255, 247, 227, 203),
      context: context,
      isScrollControlled: true,
      builder: (ctx) => EatingChoice(category: category),
    );

    if (result != null) {
      setState(() {
        eatingData.choices[category] = result;
      });
      debugPrint(
          'Selected Options for ${categoryNames[category.index]}: $result');
    }
  }

  Future<void> _saveEatingHabits() async {
    int latestSdcId = await widget.dbHelper.getLatestSdcId();

    for (var entry in eatingData.choices.entries) {
      for (var subEntry in entry.value.entries) {
        String question =
            '${categoryNames[entry.key.index]} - ${eatingOptions[entry.key]![subEntry.key]}';
        String answer = subEntry.value;
        await widget.dbHelper.insertEatingHabit(latestSdcId, question, answer);
      }
    }
  }

  void _showEatingResultScreen() {
    int totalScore = eatingData.calculatedEatingScore;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EatingResult(
          eatingScore: totalScore,
          dbHelper: widget.dbHelper,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 3, 16, 3),
              child: ListView.builder(
                itemCount: categoryNames.length,
                itemBuilder: (context, index) {
                  final category = Category.values[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: InkWell(
                      onTap: () {
                        _openChoiceOverlay(category);
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        color: eatingData.choices[category] != null
                            ? Colors.green
                            : Colors.red,
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Text(
                              categoryNames[index],
                              style: const TextStyle(
                                  color: Colors
                                      .white), // To ensure text is readable on both red and green background
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                await _saveEatingHabits();
                _showEatingResultScreen();
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
