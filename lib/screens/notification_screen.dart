import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class NotificationScreen extends StatelessWidget {
  final Box deadlineBox = Hive.box('deadlines');

  String _getTimeLeft(String dateString) {
    try {
      DateTime dueDate = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = dueDate.difference(now);

      if (difference.inHours < 1) {
        return "Due very soon";
      } else if (difference.inHours < 24) {
        return "Due in ${difference.inHours} hour(s)";
      } else {
        return "Due in ${difference.inDays} day(s)";
      }
    } catch (e) {
      return "Invalid date";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notifications")),
      body: deadlineBox.isEmpty
          ? Center(child: Text("No notifications available."))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: deadlineBox.length,
              itemBuilder: (context, index) {
                final item = deadlineBox.getAt(index) as Map;

                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 4)
                    ],
                  ),
                  child: ListTile(
                    leading:
                        Icon(Icons.notifications_active, color: Colors.teal),
                    title: Text(item['title']),
                    subtitle: Text(_getTimeLeft(item['date'])),
                  ),
                );
              },
            ),
    );
  }
}
