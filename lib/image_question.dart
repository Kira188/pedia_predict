import 'package:flutter/material.dart';
import 'package:pedia_predict/gradient_scaffold.dart';
import 'package:pedia_predict/home_page.dart';
import 'package:pedia_predict/questions_screen.dart';
import 'package:pedia_predict/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageQuestion extends ConsumerStatefulWidget {
  const ImageQuestion({super.key, required this.ver});
  final int ver;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ImageQuestionState();
}

class _ImageQuestionState extends ConsumerState<ImageQuestion> {
  late String questionText;

  @override
  void initState() {
    super.initState();
    switch (widget.ver) {
      case 1:
        questionText = 'Please rate your Current Body Perception of your body image';
        break;
      case 2:
        questionText = 'Please rate your Desired Body Perception of your body image';
        break;
      default:
        questionText = 'Unknown';
    }
  }

  Future<void> _submitRating(int selectedRating) async {
  final dbHelper = ref.read(databaseHelperProvider);

  debugPrint("Selected rating: $selectedRating");

  final int latestSdcId = await dbHelper.getLatestSdcId();
  await dbHelper.insertSdcQuestion(
    latestSdcId,
    questionText,
    selectedRating.toString(),
  );

  if (!mounted) return;

  if (widget.ver == 1) {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ImageQuestion(ver: 2),
      ),
    );
  } else if (widget.ver == 2) {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QuestionsScreen(
          pageTitle: 'Sleep Quality',
          startIndex: 19,
          endIndex: 20,
        ),
      ),
    );
  } else {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final provider = widget.ver == 1 ? imageProvider1 : imageProvider2;
    final imageSelectionNotifier = ref.watch(provider.notifier);
    final selectedRating = ref.watch(provider).selectedRating;

    return GradientScaffold(
      appBarText: 'Figure Scale Rating',
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                'lib/assets/ratingscale.png',
                width: 800.0,
              ),
            ),
            Text(
              questionText,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      imageSelectionNotifier.setSelectedRating(index + 1);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedRating == index + 1
                              ? Colors.black
                              : Colors.grey,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 24,
                            color: selectedRating == index + 1
                                ? Colors.black
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: selectedRating != null
                    ? () => _submitRating(selectedRating)
                    : () {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please select a rating')),
                          );
                        }
                      },
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
