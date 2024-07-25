import 'package:flutter/material.dart';
import 'package:pedia_predict/models/eating_model.dart';// Import the new file

class EatingChoice extends StatefulWidget {
  final Category category; // Add this parameter

  const EatingChoice({super.key, required this.category});

  @override
  State<StatefulWidget> createState() {
    return _EatingChoiceState();
  }
}

class _EatingChoiceState extends State<EatingChoice> {
  final Map<int, String> _selectedFrequencies = {}; // To store the selected frequency for each option
  String? _errorMessage; // To store the error message

  @override
  void initState() {
    super.initState();
    // Initialize all options with 'Never' frequency
    for (int i = 0; i < (eatingOptions[widget.category]?.length ?? 0); i++) {
      _selectedFrequencies[i] = 'Never';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(32.0),
            child: Text(
              'Select Frequencies',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: eatingOptions[widget.category]?.length ?? 0,
              itemBuilder: (ctx, idx) {
                return ListTile(
                  title: Text(eatingOptions[widget.category]![idx]),
                  trailing: DropdownButton<String>(
                    value: _selectedFrequencies[idx],
                    items: frequencyOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedFrequencies[idx] = newValue!;
                        _errorMessage = null; // Clear the error message
                      });
                    },
                  ),
                );
              },
            ),
          ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _selectedFrequencies);
              },
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }
}
