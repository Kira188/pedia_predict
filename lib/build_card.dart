import 'package:flutter/material.dart';

class ContainerOne extends StatelessWidget {
  const ContainerOne({required this.text1, required this.text2, super.key});
  final String text1;
  final String text2;

  @override
  Widget build(context) {
    return Container(
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 238, 198, 150),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.8),
            spreadRadius: 2,
            blurRadius: 1,
            offset: const Offset(0, 0),
          )
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(100),
                bottomLeft: Radius.circular(0),
                topRight: Radius.circular(100),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 239, 171, 89),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                padding: const EdgeInsets.all(23.0),
                child: Center(
                  child: Text(
                    text1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const VerticalDivider(
            color: Colors.black,
            width: 1,
            thickness: 1,
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 238, 198, 150),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0), // Adjust this radius to change shape
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                  bottomLeft: Radius.circular(0), // Adjust this radius to change shape
                ),
              ),
              padding: const EdgeInsets.all(15.0),
              child: Text(
                text2,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
