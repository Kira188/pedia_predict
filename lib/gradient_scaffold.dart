import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class GradientScaffold extends ConsumerWidget {
  final Widget body;
  final bool showBackButton;
  final String appBarText;

  const GradientScaffold({
    super.key,
    required this.body,
    this.showBackButton = true,
    this.appBarText = "Pedia Predict",
  });

  @override
    Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150.0),
        child: AppBar(
          automaticallyImplyLeading: false, // Disable the default back button
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 247, 227, 203),
                  Color.fromARGB(255, 247, 227, 203),
                ],
              ),
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            "lib/assets/aher-logo.jpeg",
                            width: 100,
                          ),
                          Image.asset(
                            "lib/assets/jss logo.jpg",
                            width: 100,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Center(
                        child: Text(
                          appBarText,
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                if (showBackButton)
                  Positioned(
                    top: 106.0, // Adjust this value to position the back button
                    left: 16.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 247, 227, 203),
              Color.fromARGB(255, 247, 227, 203),
              Colors.white,
            ],
          ),
        ),
        child: body,
      ),
    );
  }
}
