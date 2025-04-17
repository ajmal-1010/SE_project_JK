import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'add_deadline_screen.dart';

class DeadlineScreen extends StatelessWidget {
  final String userName;
  DeadlineScreen({required this.userName});

  final Box deadlineBox = Hive.box('deadlines');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Deadlines")),
      body: ValueListenableBuilder(
        valueListenable: deadlineBox.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return Center(child: Text("No deadlines added yet."));
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: box.length,
            itemBuilder: (context, index) {
              final item = box.getAt(index);
              final priorityColor = {
                    "High": Colors.redAccent,
                    "Medium": Colors.orange,
                    "Low": Colors.green,
                  }[item['priority']] ??
                  Colors.grey;

              return Container(
                margin: EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border:
                      Border(left: BorderSide(color: priorityColor, width: 4)),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: ListTile(
                  title: Text(item['title']),
                  subtitle: Text("Due: ${item['date']}"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_outline),
                    onPressed: () => box.deleteAt(index),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddDeadlineScreen()),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
