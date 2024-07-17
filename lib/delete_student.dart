import 'package:flutter/material.dart';
import 'package:pedia_predict/gradient_scaffold.dart';
import 'utils/database_helper.dart';

class DeleteStudent extends StatefulWidget {
  const DeleteStudent({super.key, required this.dbHelper});
  final DatabaseHelper dbHelper;

  @override
  State<StatefulWidget> createState() => _DeleteStudentState();
}

class _DeleteStudentState extends State<DeleteStudent> {
  Future<List<Map<String, dynamic>>> _fetchStudents() async {
    return await widget.dbHelper.getTableData('student');
  }

  void _onRemoveStudent(int id) async {
    await widget.dbHelper.deleteStudentById(id);
    setState(() {});
  }

  Future<void> _confirmDelete(int id) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this student?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      _onRemoveStudent(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBarText: 'Student Select',
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchStudents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No students found.'));
          } else {
            final students = snapshot.data!;
            return ListView.builder(
              itemCount: students.length,
              itemBuilder: (ctx, index) {
                final student = students[index];
                return Dismissible(
                  key: ValueKey(student['id']),
                  direction: DismissDirection.horizontal,
                  confirmDismiss: (direction) async {
                    await _confirmDelete(student['id']);
                    return false; // Prevent automatic dismissal
                  },
                  background: Container(
                    color: const Color.fromARGB(255, 51, 36, 17),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      // Wrap ListTile with Card
                      color: const Color.fromARGB(255, 238, 198, 150), // Set desired card color
                      child: ListTile(
                        title: Text(student['fullName']),
                        subtitle: Text('ID: ${student['id']}'),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
