import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/add_deadline_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive with path
  // final appDir = await getApplicationDocumentsDirectory();
  // await Hive.initFlutter(appDir.path);
  await Hive.initFlutter(); // No path needed for web
  await Hive.openBox('study_plan');
  await Hive.openBox('deadlines');
  await Hive.openBox('group_reminders');

  runApp(JKPlannerApp());
}

class JKPlannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JK Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Color(0xFFF4F4F9),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
      home: LoginScreen(), // Will move to HomeScreen after login
    );
  }
}
