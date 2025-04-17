import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AddDeadlineScreen extends StatefulWidget {
  @override
  _AddDeadlineScreenState createState() => _AddDeadlineScreenState();
}

class _AddDeadlineScreenState extends State<AddDeadlineScreen> {
  final _titleController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedPriority = 'Medium';
  final Box deadlineBox = Hive.box('deadlines');

  void _saveDeadline() {
    if (_titleController.text.isEmpty || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a title and select a date.")),
      );
      return;
    }

    deadlineBox.add({
      'title': _titleController.text,
      'date': _selectedDate!.toIso8601String(),
      'priority': _selectedPriority,
    });

    Navigator.pop(context);
  }

  Future<void> _pickDate() async {
    DateTime now = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Deadline")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration:
                  InputDecoration(labelText: "Title (e.g., Math Assignment)"),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? "No date chosen"
                        : "Selected: ${_selectedDate!.toLocal().toString().split(' ')[0]}",
                  ),
                ),
                TextButton(
                  onPressed: _pickDate,
                  child: Text("Pick Date"),
                ),
              ],
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedPriority,
              decoration: InputDecoration(labelText: "Priority"),
              items: ["High", "Medium", "Low"]
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedPriority = val!),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveDeadline,
              child: Text("Save"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
              ),
            )
          ],
        ),
      ),
    );
  }
}
