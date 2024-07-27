import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedia_predict/models/psss_data.dart';
import 'package:pedia_predict/psss/psss_choice.dart';
import 'package:pedia_predict/gradient_scaffold.dart';
import 'package:pedia_predict/psss/psss_result.dart';
import 'package:pedia_predict/providers.dart';

class PsssHabits extends ConsumerStatefulWidget {
  final int habitType;

  const PsssHabits({
    super.key,
    required this.habitType,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PsssHabitsState();
}

class _PsssHabitsState extends ConsumerState<PsssHabits> {
  late String _habitTitle;
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
        _habitTitle = "Physical Activity";
        _data = PhysicalData();
        _categoryValues = PhysicalCategory.values;
        _categoryNames = physicalCategoryNames;
        _frequencyOptions = physicalFrequencyOptions;
        _calculatedScore =
            () => (_data as PhysicalData).calculatedPhysicalScore;
        break;
      case 1:
        _habitTitle = "Sedentary Lifestyle";
        _data = SedentaryData();
        _categoryValues = SedentaryCategory.values;
        _categoryNames = sedentaryCategoryNames;
        _frequencyOptions = sedentaryFrequencyOptions;
        _calculatedScore =
            () => (_data as SedentaryData).calculatedSedentaryScore;
        break;
      case 2:
        _habitTitle = "Mental Health\nAnd Wellbeing";
        _data = SedentaryDataTwo();
        _categoryValues = SedentaryCategoryTwo.values;
        _categoryNames = sedentaryCategoryNamesTwo;
        _frequencyOptions = sedentaryFrequencyOptionsTwo;
        _calculatedScore =
            () => (_data as SedentaryDataTwo).calculatedSedentaryScore;
        break;
      case 3:
        _habitTitle = "Sleep Quality";
        _data = SleepingData();
        _categoryValues = SleepingCategory.values;
        _categoryNames = sleepingCategoryNames;
        _frequencyOptions = sleepingFrequencyOptions;
        _calculatedScore =
            () => (_data as SleepingData).calculatedSleepingScore;
        break;
      case 4:
        _habitTitle = "Eating Habits";
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
StateNotifierProvider<PsssHabitsNotifier, PsssHabitsState> _getProvider(int habitType) {
    switch (habitType) {
      case 0:
        return physicalHabitsProvider;
      case 1:
        return sedentaryHabitsProvider;
      case 2:
        return mentalHabitsProvider;
      case 3:
        return sleepHabitsProvider;
      case 4:
        return eatingHabitsProvider;
      default:
        throw Exception('Invalid habit type');
    }
  }
  void _openChoiceOverlay(dynamic category) async {
    List<String> frequencyOptions = _frequencyOptions as List<String>;
     final provider = _getProvider(widget.habitType);
    final state = ref.read(provider);
    String selectedFrequency = state.choices[category] ?? '0';

    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      builder: (ctx) => PsssChoice(
        category: category,
        frequencyOptions: frequencyOptions,
        selectedFrequency: selectedFrequency,
      ),
    );

   if (result != null && mounted) {
      ref.read(provider.notifier).setChoice(category, result);
      _data.choices[category] = result;
    }
  }

  Future<void> _savePsssHabits() async {
    final dbHelper = ref.read(databaseHelperProvider);
    final provider = _getProvider(widget.habitType);
    final state = ref.read(provider);

    int latestSdcId = await dbHelper.getLatestSdcId();

    for (var entry in state.choices.entries) {
      String question = _categoryNames[_categoryValues.indexOf(entry.key)];
      String answer = entry.value;
      await dbHelper.insertRemainingTableQuestion(
          latestSdcId, question, answer);
      _data.choices[entry.key] = answer;
    }
  }

  void _showResultScreen() {
    int totalScore = _calculatedScore();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PsssResult(
          appBarText: _habitTitle,
          score: totalScore,
          habitType: widget.habitType,
        ),
      ),
    );
  }

  void _submit() async {
    await _savePsssHabits();
    _showResultScreen();
  }

  @override
  Widget build(BuildContext context) {
    final provider = _getProvider(widget.habitType);
    final state = ref.watch(provider);

    return GradientScaffold(
      appBarText: _habitTitle,
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
                        color: state.choices[category] != null
                            ? Colors.green
                            : Colors.red,
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
              onPressed: _submit,
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
