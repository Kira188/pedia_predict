import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedia_predict/data/questions_data.dart';
import 'package:pedia_predict/home_page.dart';
import 'package:pedia_predict/models/questions_model.dart';
import 'package:pedia_predict/gradient_scaffold.dart';
import 'package:pedia_predict/psss/psss_habits.dart';
import 'package:pedia_predict/providers.dart';

class QuestionsScreen extends ConsumerStatefulWidget {
  final int startIndex;
  final int endIndex;
  final String pageTitle;

  const QuestionsScreen({
    required this.pageTitle,
    required this.startIndex,
    required this.endIndex,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends ConsumerState<QuestionsScreen> {
  final Set<String> expandedQuestions = {};

  @override
  void initState() {
    super.initState();
    initializeAnswers();
  }

  Future<void> initializeAnswers() async {
    final dbHelper = ref.read(databaseHelperProvider);
    final latestSdcId = await dbHelper.getLatestSdcId();
    if (!mounted) return;

    for (int i = widget.startIndex; i <= widget.endIndex; i++) {
      if (questions.length > i) {
        final question = questions[i];
        await dbHelper.insertSdcQuestion(latestSdcId, question.text, '');
        for (var subQuestion in question.subQuestions) {
          final subQuestionKey = '${question.text} - ${subQuestion.text}';
          await dbHelper.insertSdcQuestion(latestSdcId, subQuestionKey, '');
        }
      }
    }
  }

  void handleDropdownAnswerChange(String questionKey, String? answer) {
    if (!mounted) return;
    
    setState(() {
      ref.read(questionProvider.notifier).setAnswer(questionKey, answer ?? '');
      if (answer == 'Yes' || answer == 'Others') {
        expandedQuestions.add(questionKey);
      } else {
        expandedQuestions.remove(questionKey);
      }
    });
  
}
  Future<void> saveAnswers() async {
     if (!mounted) return;


    final dbHelper = ref.read(databaseHelperProvider);
    final latestSdcId = await dbHelper.getLatestSdcId();

    final questionState = ref.read(questionProvider);

     if (mounted) {
    questionState.textControllers.forEach((key, controller) async {
      await dbHelper.insertSdcQuestion(latestSdcId, key, controller.text);
    });

    questionState.answers.forEach((key, answer) async {
      await dbHelper.insertSdcQuestion(latestSdcId, key, answer);
    });

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => determineNextPage(),
        ),
      );
    }
  }
}

  Widget determineNextPage() {
    if (widget.startIndex == 0) {
      return const PsssHabits(habitType: 4);
    } else if (widget.startIndex == 12) {
      return const PsssHabits(habitType: 0);
    } else if (widget.startIndex == 16) {
      return const PsssHabits(habitType: 2);
    } else if (widget.startIndex == 19) {
      return const PsssHabits(habitType: 3);
    } else if (widget.startIndex == 21) {
      return const PsssHabits(habitType: 1);
    } else {
      return const HomePage();
    }
  }

  Widget buildQuestion(QuizQuestion question, String parentKey) {
    String questionKey = parentKey.isEmpty ? question.text : '$parentKey - ${question.text}';
    final textController = ref.read(questionProvider.notifier).getController(questionKey);
    if (textController == null) {
      final newController = TextEditingController();
      ref.read(questionProvider.notifier).setController(questionKey, newController);
    }

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
              value: ref.watch(questionProvider).answers[questionKey],
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
              ref.read(questionProvider.notifier).setAnswer(questionKey, value);
            },
            decoration: const InputDecoration(
              hintText: 'Enter your answer',
            ),
            controller: ref.read(questionProvider.notifier).getController(questionKey),
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
  void dispose() {
    ref.read(questionProvider.notifier).disposeAll();
    super.dispose();
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
                            : Container();
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
                onPressed: saveAnswers,
                child: const Text('Submit'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
