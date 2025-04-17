import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StudyPlannerScreen extends StatefulWidget {
  @override
  State<StudyPlannerScreen> createState() => _StudyPlannerScreenState();
}

class _StudyPlannerScreenState extends State<StudyPlannerScreen> {
  final _topicController = TextEditingController();
  final _box = Hive.box('study_plan');

  void _addPlan() {
    if (_topicController.text.isNotEmpty) {
      _box.add({'topic': _topicController.text});
      _topicController.clear();
    }
  }

  void _deletePlan(int index) {
    _box.deleteAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Study Planner")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Add New Plan
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _topicController,
                    decoration: InputDecoration(labelText: "Study Topic"),
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _addPlan,
                    child: Text("Add Plan"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48),
                      backgroundColor: Colors.teal,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            // View Plan List
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: _box.listenable(),
                builder: (context, Box box, _) {
                  if (box.isEmpty) {
                    return Center(child: Text("No study plans yet."));
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
                          title: Text(item['topic']),
                          trailing: IconButton(
                            icon: Icon(Icons.delete_outline),
                            onPressed: () => _deletePlan(index),
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
