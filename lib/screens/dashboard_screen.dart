import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'add_deadline_screen.dart';
import 'calendar_screen.dart';
import 'group_sharing_screen.dart';
import 'study_planner_screen.dart';
import 'notification_screen.dart';
import 'priority_screen.dart';
import 'deadline_screen.dart';
import 'login_screen.dart';


class DashboardScreen extends StatelessWidget {
  final String userName;

  DashboardScreen({required this.userName});

  final List<Map<String, dynamic>> features = [
    {
      "title": "Add Deadline",
      "icon": Icons.add_task,
      "screen": AddDeadlineScreen(),
    },
    {
      "title": "Calendar",
      "icon": Icons.calendar_month,
      "screen": CalendarScreen(),
    },
    {
      "title": "Group Sharing",
      "icon": Icons.group,
      "screen": GroupSharingScreen(),
    },
    {
      "title": "Study Planner",
      "icon": Icons.menu_book,
      "screen": StudyPlannerScreen(),
    },
    {
      "title": "Notifications",
      "icon": Icons.notifications,
      "screen": NotificationScreen(),
    },
    {
      "title": "Priority Reminders",
      "icon": Icons.warning_amber,
      "screen": PriorityReminderScreen(),
    },
    {
      "title": "All Deadlines",
      "icon": Icons.event_note,
      "screen": DeadlineScreen(userName: "Ajmal"),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome back, $userName"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 79, 91, 218),
        actions: [
  IconButton(
    icon: Icon(Icons.logout),
    onPressed: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    },
  ),
],

      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔁 Live Stats Row
            ValueListenableBuilder(
              valueListenable: Hive.box('deadlines').listenable(),
              builder: (context, Box deadlineBox, _) {
                final highPriority = deadlineBox.values
                    .where((item) => item['priority'] == 'High')
                    .length;

                return ValueListenableBuilder(
                  valueListenable: Hive.box('group_reminders').listenable(),
                  builder: (context, Box groupBox, _) {
                    return Row(
                      children: [
                        _buildStatCard(
                            "Deadlines", deadlineBox.length, Colors.teal),
                        _buildStatCard(
                            "High Priority", highPriority, Colors.redAccent),
                        _buildStatCard(
                            "Group Shared", groupBox.length, Colors.deepPurple),
                      ],
                    );
                  },
                );
              },
            ),

            SizedBox(height: 24),

            // 🧭 Feature Grid
            Expanded(
              child: GridView.builder(
                itemCount: features.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  final item = features[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => item['screen']),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 4)
                        ],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(item['icon'], size: 40, color: Colors.teal),
                          SizedBox(height: 12),
                          Text(item['title'],
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, int count, Color color) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(left: BorderSide(color: color, width: 4)),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text(
              "$count",
              style: TextStyle(
                  fontSize: 22, color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
