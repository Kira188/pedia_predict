import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'package:pedia_predict/models/sdc_model.dart';
import 'package:share/share.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'sdc_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE student(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        weight REAL,
        height REAL,
        age TEXT,
        gender TEXT,
        schoolName TEXT,
        fullName TEXT,
        classSection TEXT,
        address TEXT,
        bmi REAL,
        riskFactor TEXT,
        district TEXT,
        taluk TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE questions(
        sdc_id INTEGER,
        question TEXT,
        answer TEXT,
        FOREIGN KEY (sdc_id) REFERENCES student(id) ON DELETE CASCADE,
        UNIQUE(sdc_id, question)
      )
    ''');

    await db.execute('''
      CREATE TABLE remaining_table_questions(
        sdc_id INTEGER,
        question TEXT,
        answer TEXT,
        FOREIGN KEY (sdc_id) REFERENCES student(id) ON DELETE CASCADE,
        UNIQUE(sdc_id, question)
      )
    ''');
  }
  Future<int> insertSdcModel(SdcModel sdcModel) async {
    final db = await database;
    return await db.insert(
      'student',
      sdcModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertSdcQuestion(int sdcId, String question, String answer) async {
    final db = await database;
    return await db.insert(
      'questions',
      {
        'sdc_id': sdcId,
        'question': question,
        'answer': answer,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertRemainingTableQuestion(
      int sdcId, String question, String answer) async {
    Database db = await database;
    return await db.insert(
      'remaining_table_questions',
      {
        'sdc_id': sdcId,
        'question': question,
        'answer': answer,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteStudentById(int id) async {
    final db = await database;
    await db.delete(
      'student',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  Future<List<Map<String, dynamic>>> getTableData(String tableName) async {
    final db = await database;
    return await db.query(tableName);
  }

  Future<int> getSdcCount() async {
    final db = await database;
    return Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM student')) ??
        0;
  }

  Future<int> getLatestSdcId() async {
    final db = await database;
    final result = await db.rawQuery('SELECT MAX(id) as id FROM student');
    return result.first['id'] as int? ?? 0;
  }
//   Future<String?> getSdcQuestionAnswer(int sdcId, String question) async {
//   final db = await database;
//   final result = await db.query(
//     'questions',
//     columns: ['answer'],
//     where: 'sdc_id = ? AND question = ?',
//     whereArgs: [sdcId, question],
//   );
//   if (result.isNotEmpty) {
//     return result.first['answer'] as String;
//   }
//   return null;
// }

  Future<void> exportDatabaseToExcel() async {
  final db = await database;

  // Create a new Excel document
  var excel = Excel.createExcel();

  // Export student table
  var studentSheet = excel['Student'];
  List<Map<String, dynamic>> studentData = await db.query('student');
  if (studentData.isNotEmpty) {
    studentSheet.appendRow(
        studentData.first.keys.map((key) => TextCellValue(key)).toList());
    for (var row in studentData) {
      studentSheet.appendRow(
          row.values.map((value) => TextCellValue(value.toString())).toList());
    }
  }

  // Export questions table
  var questionsSheet = excel['Questions'];
  List<Map<String, dynamic>> questionsData = await db.query('questions');
  if (questionsData.isNotEmpty) {
    questionsSheet.appendRow(
        questionsData.first.keys.map((key) => TextCellValue(key)).toList());
    for (var row in questionsData) {
      questionsSheet.appendRow(
          row.values.map((value) => TextCellValue(value.toString())).toList());
    }
  }

  // Export remaining_table_questions table
  var remainingTableSheet = excel['Remaining Table Questions'];
  List<Map<String, dynamic>> remainingTableData =
      await db.query('remaining_table_questions');
  if (remainingTableData.isNotEmpty) {
    remainingTableSheet.appendRow(remainingTableData.first.keys
        .map((key) => TextCellValue(key))
        .toList());
    for (var row in remainingTableData) {
      remainingTableSheet.appendRow(
          row.values.map((value) => TextCellValue(value.toString())).toList());
    }
  }

  // Get the path to the documents directory
  Directory directory = await getApplicationDocumentsDirectory();
  String filePath = '${directory.path}/sdc_database.xlsx';
  List<int>? fileBytes = excel.save();
  if (fileBytes != null) {
    File file = File(filePath)..writeAsBytesSync(fileBytes);
    debugPrint('Database exported to Excel at $filePath');

    // Share the file
    Share.shareFiles([file.path], text: 'Check out this database export!');
  } else {
    debugPrint('Failed to save Excel file.');
  }
}
}
