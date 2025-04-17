import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class PriorityReminderScreen extends StatelessWidget {
  final Box deadlineBox = Hive.box('deadlines');

  Color getPriorityColor(String priority) {
    switch (priority) {
      case "High":
        return Colors.redAccent;
      case "Medium":
        return Colors.orangeAccent;
      case "Low":
        return Colors.greenAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Priority Reminders")),
      body: deadlineBox.isEmpty
          ? Center(child: Text("No priority reminders found."))
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: deadlineBox.length,
              itemBuilder: (context, index) {
                final item = deadlineBox.getAt(index) as Map;
                final color = getPriorityColor(item['priority']);

                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(left: BorderSide(color: color, width: 5)),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 4)
                    ],
                  ),
                  child: ListTile(
                    title: Text(item['title']),
                    subtitle: Text("Due: ${item['date']}"),
                    trailing: Text(
                      item['priority'],
                      style:
                          TextStyle(color: color, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
