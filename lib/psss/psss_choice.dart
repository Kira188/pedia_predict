import 'package:flutter/material.dart';

class PsssChoice extends StatefulWidget {
  final dynamic category;
  final List<String> frequencyOptions;
  final String? selectedFrequency; // This will hold the index as a String

  const PsssChoice({
    super.key,
    required this.category,
    required this.frequencyOptions,
    this.selectedFrequency,
  });

  @override
  State<PsssChoice> createState() => _PsssChoiceState();
}

class _PsssChoiceState extends State<PsssChoice> {
  String? _selectedFrequency;

  @override
  void initState() {
    super.initState();
    _selectedFrequency = widget.selectedFrequency; // Set initial selected frequency
  }

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
                  leading: Radio<String>(
                    value: idx.toString(),
                    groupValue: _selectedFrequency,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedFrequency = value;
                      });
                      Navigator.pop(context, _selectedFrequency);
                    },
                  ),
                  title: Text(widget.frequencyOptions[idx]),
                  onTap: () {
                    setState(() {
                      _selectedFrequency = idx.toString();
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