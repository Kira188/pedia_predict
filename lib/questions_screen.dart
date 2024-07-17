// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pedia_predict/data/questions_data.dart';
import 'package:pedia_predict/home_page.dart';
import 'package:pedia_predict/models/questions_model.dart';
import 'package:pedia_predict/gradient_scaffold.dart';
import 'package:pedia_predict/utils/database_helper.dart';
import 'package:pedia_predict/psss/psss_habits.dart';

class QuestionsScreen extends StatefulWidget {
  final int startIndex;
  final int endIndex;
  final DatabaseHelper dbHelper;
  final pageTitle;
  const QuestionsScreen({
    required this.pageTitle,
    required this.startIndex,
    required this.endIndex,
    required this.dbHelper,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  final Map<String, String> textAnswers = {};
  final Map<String, String> dropdownAnswers = {};
  final Set<String> expandedQuestions = {};

  @override
  void initState() {
    super.initState();
    initializeAnswers();
  }

  void initializeAnswers() async {
    textAnswers.clear();
    dropdownAnswers.clear();

    int latestSdcId = await widget.dbHelper.getLatestSdcId();
    for (int i = widget.startIndex; i <= widget.endIndex; i++) {
      if (questions.length > i) {
        QuizQuestion question = questions[i];
        await widget.dbHelper.insertSdcQuestion(latestSdcId, question.text, 'null');
        for (var subQuestion in question.subQuestions) {
          String subQuestionKey = '${question.text} - ${subQuestion.text}';
          await widget.dbHelper.insertSdcQuestion(latestSdcId, subQuestionKey, 'null');
        }
      }
    }
  }

  void handleDropdownAnswerChange(String questionKey, String? answer) {
    setState(() {
      dropdownAnswers[questionKey] = answer!;
      if (answer == 'Yes' || answer == 'Others') {
        expandedQuestions.add(questionKey);
      } else {
        expandedQuestions.remove(questionKey);
      }
    });
  }

  void handleTextAnswerChange(String questionKey, String answer) {
    setState(() {
      textAnswers[questionKey] = answer;
    });
  }

  Future<void> saveAnswers(BuildContext context) async {
    int latestSdcId = await widget.dbHelper.getLatestSdcId();

    for (var entry in textAnswers.entries) {
      await widget.dbHelper.insertSdcQuestion(latestSdcId, entry.key, entry.value);
    }

    for (var entry in dropdownAnswers.entries) {
      await widget.dbHelper.insertSdcQuestion(latestSdcId, entry.key, entry.value);
    }

    // Use mounted check to guard against context usage
    if (mounted) {
      // Directly navigate based on the startIndex
      if (widget.startIndex == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PsssHabits(habitType: 4, dbHelper: widget.dbHelper),
          ),
        );
      } else if (widget.startIndex == 12) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PsssHabits(habitType: 0, dbHelper: widget.dbHelper),
          ),
        );
      } else if (widget.startIndex == 16) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PsssHabits(habitType: 2, dbHelper: widget.dbHelper),
          ),
        );
      } else if (widget.startIndex == 19) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PsssHabits(habitType: 3, dbHelper: widget.dbHelper),
          ),
        );
      } else if (widget.startIndex == 21){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => 
        PsssHabits(habitType: 1, dbHelper: widget.dbHelper),
        ),
        );
      }
      else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(dbHelper: widget.dbHelper),
          ),
        );
      }
    }

    // Clear answers after saving
    textAnswers.clear();
    dropdownAnswers.clear();
  }

  Widget buildQuestion(QuizQuestion question, String parentKey) {
    String questionKey = parentKey.isEmpty ? question.text : '$parentKey - ${question.text}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            question.text,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        if (question.dropdownAnswers.isNotEmpty) ...[
          SizedBox(
            width: double.infinity,
            child: DropdownButton<String>(
              isExpanded: true,
              value: dropdownAnswers[questionKey],
              hint: const Text('Select an option'),
              onChanged: (value) {
                handleDropdownAnswerChange(questionKey, value);
              },
              items: question.dropdownAnswers.map((answer) {
                return DropdownMenuItem(
                  value: answer,
                  child: Text(answer),
                );
              }).toList(),
            ),
          ),
        ] else if (question.textAnswer) ...[
          TextField(
            onChanged: (value) {
              handleTextAnswerChange(questionKey, value);
            },
            decoration: const InputDecoration(
              hintText: 'Enter your answer',
            ),
          ),
        ],
        if (question.subQuestions.isNotEmpty && expandedQuestions.contains(questionKey))
          ...question.subQuestions.map((subQuestion) {
            return Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0),
              child: buildQuestion(subQuestion, questionKey),
            );
          }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBarText: widget.pageTitle,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.endIndex - widget.startIndex + 1,
                      itemBuilder: (context, index) {
                        final question = questions.length > widget.startIndex + index
                            ? questions[widget.startIndex + index]
                            : null;
                        return question != null
                            ? Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: buildQuestion(question, ''),
                              )
                            : Container(); // Return empty container if index exceeds questions length
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () async {
                  await saveAnswers(context);
                },
                child: const Text('Submit'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
