import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  final String calendarUrl =
      "https://calendar.google.com/calendar/embed?src=en.indian%23holiday%40group.v.calendar.google.com&ctz=Asia%2FKolkata";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calendar Sync")),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 12),
            Text(
              "Google Calendar (Holiday Sync)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SelectableText(
                  "🗓️ Calendar view is not available in Flutter Web/Desktop.\nUse `webview_flutter` on Android/iOS.\n\nCalendar Link:\n$calendarUrl",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
