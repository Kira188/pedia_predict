import 'package:flutter/material.dart';
import 'package:pedia_predict/models/psss_data.dart';
import 'package:pedia_predict/psss/psss_choice.dart';
import 'package:pedia_predict/gradient_scaffold.dart';
import 'package:pedia_predict/psss/psss_result.dart';
import 'package:pedia_predict/utils/database_helper.dart';

class PsssHabits extends StatefulWidget {
  final int habitType;
  final DatabaseHelper dbHelper;

  const PsssHabits({
    super.key,
    required this.habitType,
    required this.dbHelper,
  });

  @override
  State<StatefulWidget> createState() => _PsssHabitsState();
}

class _PsssHabitsState extends State<PsssHabits> {
  late dynamic _data;
  late List<dynamic> _categoryValues;
  late List<String> _categoryNames;
  late List<dynamic> _frequencyOptions;
  late Function _calculatedScore;

  @override
  void initState() {
    super.initState();
    switch (widget.habitType) {
      case 0:
        _data = PhysicalData();
        _categoryValues = PhysicalCategory.values;
        _categoryNames = physicalCategoryNames;
        _frequencyOptions = physicalFrequencyOptions;
        _calculatedScore = () => (_data as PhysicalData).calculatedPhysicalScore;
        break;
      case 1:
        _data = SedentaryData();
        _categoryValues = SedentaryCategory.values;
        _categoryNames = sedentaryCategoryNames;
        _frequencyOptions = sedentaryFrequencyOptions;
        _calculatedScore = () => (_data as SedentaryData).calculatedSedentaryScore;
        break;
      case 2:
        _data = SedentaryDataTwo();
        _categoryValues = SedentaryCategoryTwo.values;
        _categoryNames = sedentaryCategoryNamesTwo;
        _frequencyOptions = sedentaryFrequencyOptionsTwo;
        _calculatedScore = () => (_data as SedentaryDataTwo).calculatedSedentaryScore;
        break;
      case 3:
        _data = SleepingData();
        _categoryValues = SleepingCategory.values;
        _categoryNames = sleepingCategoryNames;
        _frequencyOptions = sleepingFrequencyOptions;
        _calculatedScore = () => (_data as SleepingData).calculatedSleepingScore;
        break;
      case 4:
        _data = EatingData();
        _categoryValues = EatingCategory.values;
        _categoryNames = eatingCategoryNames;
        _frequencyOptions = eatingFrequencyOptions;
        _calculatedScore = () => (_data as EatingData).calculatedEatingScore;
        break;
      default:
        throw Exception('Invalid habit type');
    }
  }

  void _openChoiceOverlay(dynamic category) async {
    List<String> frequencyOptions = _frequencyOptions as List<String>;

    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => PsssChoice(
        category: category,
        frequencyOptions: frequencyOptions,
      ),
    );

    if (result != null) {
      setState(() {
        (_data as dynamic).choices[category] = result;
      });
      debugPrint('Selected Option for ${_categoryNames[_categoryValues.indexOf(category)]}: $result');
    }
  }

  Future<void> _savePsssHabits() async {
    int latestSdcId = await widget.dbHelper.getLatestSdcId();

    for (var entry in (_data as dynamic).choices.entries) {
      String question = _categoryNames[_categoryValues.indexOf(entry.key)];
      String answer = entry.value;
      await widget.dbHelper.insertRemainingTableQuestion(latestSdcId, question, answer);
    }
  }

  void _showResultScreen() {
    int totalScore = _calculatedScore();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PsssResult(score: totalScore, habitType: widget.habitType, dbHelper: widget.dbHelper),
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
                itemCount: _categoryNames.length,
                itemBuilder: (context, index) {
                  final category = _categoryValues[index];
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
                        color: _data.choices[category] != null ? Colors.green : Colors.red,
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Text(
                              _categoryNames[index],
                              style: const TextStyle(color: Colors.white),
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
                await _savePsssHabits();
                _showResultScreen();
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
