import 'package:flutter/material.dart';
import 'package:pedia_predict/gradient_scaffold.dart';
import 'package:pedia_predict/utils/database_helper.dart';
import 'package:pedia_predict/questions_screen.dart';

class ImageQuestion extends StatefulWidget {
  const ImageQuestion({super.key, required this.dbHelper});
  final DatabaseHelper dbHelper;

  @override
  State<StatefulWidget> createState() => _ImageQuestionState();
}

class _ImageQuestionState extends State<ImageQuestion> {
  int? _selectedRating;

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBarText: 'Figure Scale Rating',
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                  'lib/assets/ratingscale.png', // Ensure you have this image in your assets folder.
                  width: 800.0),
            ),
            const Text(
              'Please rate your Current Body Perception of your body image',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                shrinkWrap: true, // Ensures GridView takes only the necessary space
                physics: const NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 9, // There are 9 figures in the image
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedRating = index + 1; // Ratings are 1 to 9
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedRating == index + 1
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
                            color: _selectedRating == index + 1
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
                onPressed: () async {
                  if (_selectedRating != null) {
                    final int selectedRating = _selectedRating!;
                    debugPrint("Selected rating: $selectedRating");

                    // Get the latest student ID
                    final int latestSdcId = await widget.dbHelper.getLatestSdcId();

                    // Insert the rating into the database
                    await widget.dbHelper.insertSdcQuestion(
                      latestSdcId,
                      'Figure Rating',
                      selectedRating.toString(),
                    );
                  if (context.mounted){
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {return QuestionsScreen(startIndex: 19, endIndex: 20, dbHelper: widget.dbHelper);}));
                    
                  }} else {
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
