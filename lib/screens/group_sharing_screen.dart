import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class GroupSharingScreen extends StatefulWidget {
  @override
  State<GroupSharingScreen> createState() => _GroupSharingScreenState();
}

class _GroupSharingScreenState extends State<GroupSharingScreen> {
  final _groupController = TextEditingController();
  final _reminderController = TextEditingController();

  void _shareReminder() {
    final groupBox = Hive.box('group_reminders');
    if (_groupController.text.isNotEmpty &&
        _reminderController.text.isNotEmpty) {
      groupBox.add({
        'group': _groupController.text,
        'reminder': _reminderController.text,
      });
      _groupController.clear();
      _reminderController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter both group and reminder.")),
      );
    }
  }

  void _deleteReminder(int index) {
    final groupBox = Hive.box('group_reminders');
    groupBox.deleteAt(index);
  }

  @override
  Widget build(BuildContext context) {
    final groupBox = Hive.box('group_reminders');

    return Scaffold(
      appBar: AppBar(title: Text("Group Sharing")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Input Form
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _groupController,
                    decoration: InputDecoration(labelText: "Group Code"),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: _reminderController,
                    decoration: InputDecoration(labelText: "Reminder Title"),
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _shareReminder,
                    child: Text("Share"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48),
                      backgroundColor: Colors.teal,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Shared List
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: groupBox.listenable(),
                builder: (context, Box box, _) {
                  if (box.isEmpty) {
                    return Center(child: Text("No shared reminders yet."));
                  }

                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final item = box.getAt(index);
                      return Container(
                        margin: EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 4)
                          ],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          title: Text(item['reminder']),
                          subtitle: Text("Shared with Group: ${item['group']}"),
                          trailing: IconButton(
                            icon: Icon(Icons.delete_outline),
                            onPressed: () => _deleteReminder(index),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
