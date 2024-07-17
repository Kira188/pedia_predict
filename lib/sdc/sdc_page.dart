import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pedia_predict/gradient_scaffold.dart';
import 'package:pedia_predict/models/sdc_model.dart';
import 'package:pedia_predict/data/sdc_data.dart';
import 'package:pedia_predict/utils/database_helper.dart';
import 'package:pedia_predict/questions_screen.dart';

class SdcPage extends StatefulWidget {
  final DatabaseHelper dbHelper;

  const SdcPage({super.key, required this.dbHelper});

  @override
  State<StatefulWidget> createState() {
    return _SdcPageState();
  }
}

class _SdcPageState extends State<SdcPage> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();
  final _schoolNameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _classSectionController = TextEditingController();
  final _addressController = TextEditingController();
  final _talukController = TextEditingController();
  final _districtController = TextEditingController();
  String? _gender;
  DateTime? _selectedDate;
  final List<SdcModel> _sdcDataList = [];

  @override
  void initState() {
    super.initState();
  }

  int _calculateAgeInMonths(DateTime birthDate, DateTime currentDate) {
    int years = currentDate.year - birthDate.year;
    int months = currentDate.month - birthDate.month;
    if (months < 0) {
      years--;
      months += 12;
    }

    double dayFraction = (currentDate.day - birthDate.day) / 30.0;

    return (years * 12 + months + dayFraction).floor();
  }

  String _calculateRisk(
      String gender, DateTime birthDate, DateTime currentDate, double bmi) {
    int ageInMonths = _calculateAgeInMonths(birthDate, currentDate);
    debugPrint("Age in Months is $ageInMonths");
    Map<int, List<double>> genderMap;

    if (gender.toLowerCase() == 'male') {
      genderMap = SdcData.maleMap;
    } else if (gender.toLowerCase() == 'female') {
      genderMap = SdcData.femaleMap;
    } else {
      return 'Invalid gender';
    }

    if (!genderMap.containsKey(ageInMonths)) {
      return 'Age data not available';
    }

    List<double>? sdValues = genderMap[ageInMonths];
    if (sdValues != null) {
      if (bmi > sdValues[6]) {
        return 'Obese';
      } else if (bmi <= sdValues[6] && bmi > 0) {
        return 'Not Obese';
      } else {
        return 'Cannot Handle BMI';
      }
    } else {
      return 'Cannot Generate SD';
    }
  }

  void _addSdcData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final weight = double.parse(_weightController.text);
    final height = double.parse(_heightController.text);
    final birthDate = _selectedDate!;
    final gender = _gender!;
    final schoolName = _schoolNameController.text;
    final fullName = _fullNameController.text;
    final classSection = _classSectionController.text;
    final address = _addressController.text;
    final district = _districtController.text;
    final taluk = _talukController.text;
    final bmi = weight / (height * height);
    final currentDate = DateTime.now();
    final riskCategory = _calculateRisk(gender, birthDate, currentDate, bmi);

    final sdcData = SdcModel(
      weight: weight,
      height: height,
      age: birthDate,
      gender: gender,
      schoolName: schoolName,
      fullName: fullName,
      classSection: classSection,
      address: address,
      bmi: bmi,
      riskFactor: riskCategory,
      taluk: taluk,
      district: district,
    );

    setState(() {
      _sdcDataList.add(sdcData);
    });

    await widget.dbHelper.insertSdcModel(sdcData);

    _weightController.clear();
    _heightController.clear();
    _ageController.clear();
    _schoolNameController.clear();
    _fullNameController.clear();
    _classSectionController.clear();
    _addressController.clear();
    _talukController.clear();
    _districtController.clear();
    setState(() {
      _gender = null;
      _selectedDate = null;
    });
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Success'),
            content: Text(
                'Data has been added successfully!\n\nBMI: ${bmi.toStringAsFixed(2)}\nRisk Category: $riskCategory'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return QuestionsScreen(
                      pageTitle: "Part A",
                      //ends at Is anybody in the family suffering from thyroid dysfunction
                        startIndex: 0, endIndex: 11, dbHelper: widget.dbHelper);
                  }));
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _presentDatepicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 17, now.month, now.day);
    final lastDate = DateTime(now.year - 10, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: firstDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    setState(() {
      _selectedDate = pickedDate;
      if (_selectedDate != null) {
        _ageController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      }
    });
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    _schoolNameController.dispose();
    _fullNameController.dispose();
    _classSectionController.dispose();
    _addressController.dispose();
    _talukController.dispose();
    _districtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBarText: "SDC Page",
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _buildTextField(_schoolNameController,
                          'Name of the School', TextInputType.text),
                      _buildTextField(_districtController,
                          'Enter School District', TextInputType.text),
                      _buildTextField(_talukController, 'Enter School Taluk',
                          TextInputType.text),
                      _buildTextField(
                          _fullNameController, 'Full Name', TextInputType.text),
                      _buildTextField(_classSectionController,
                          'Class and Section', TextInputType.text),
                      _buildTextField(
                          _addressController, 'Address', TextInputType.text),
                      _buildTextField(
                          _weightController, 'Weight (kg)', TextInputType.text),
                      _buildTextField(
                          _heightController, 'Height (m)', TextInputType.text),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _ageController,
                              decoration: const InputDecoration(
                                labelText: 'Birthday (yyyy-mm-dd)',
                              ),
                              readOnly: true,
                              onTap: _presentDatepicker,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your birthday';
                                }
                                return null;
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: _presentDatepicker,
                            icon: const Icon(Icons.calendar_today),
                          ),
                        ],
                      ),
                      DropdownButtonFormField(
                        value: _gender,
                        hint: const Text('Select Gender'),
                        items: ['Male', 'Female'].map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _gender = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select your gender';
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: _addSdcData,
                          child: const Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      TextInputType keyboardType) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $labelText';
        }
        return null;
      },
    );
  }
}
