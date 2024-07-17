import 'package:flutter/material.dart';

class PsssChoice extends StatefulWidget {
  final dynamic category;
  final List<String> frequencyOptions;

  const PsssChoice({super.key, required this.category, required this.frequencyOptions});

  @override
  State<StatefulWidget> createState() {
    return _PsssChoiceState();
  }
}

class _PsssChoiceState extends State<PsssChoice> {
  String? _selectedFrequency;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(32.0),
            child: Text(
              'Select Frequency',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.frequencyOptions.length,
              itemBuilder: (ctx, idx) {
                return ListTile(
                  title: Text(widget.frequencyOptions[idx]),
                  onTap: () {
                    setState(() {
                      _selectedFrequency = widget.frequencyOptions[idx];
                    });
                    Navigator.pop(context, _selectedFrequency);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
