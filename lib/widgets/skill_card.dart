import 'package:flutter/material.dart';

class skillCard extends StatelessWidget {
  final String skillname;
  final int total_hours;
  final int goal_hours;
  final VoidCallback onAddLogs;
  final int streak;

  const skillCard({
    Key? key,
    required this.skillname,
    required this.total_hours,
    required this.goal_hours,
    required this.onAddLogs,
    required this.streak,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 3.0,
      child: ListTile(
        contentPadding: EdgeInsets.all(18.0),
        title: Text(
          skillname,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.0),
            Text(
              'Total Hours: $total_hours',
              style: TextStyle(fontSize: 16.0),
            ),
            LinearProgressIndicator(
              value: total_hours / goal_hours,
              backgroundColor: Colors.grey[300],
              color: Colors.deepPurple,
            ),
            SizedBox(height: 10.0),
            Text(
              '🔥 Streak: $streak days',
              style: TextStyle(fontSize: 16.0, color: Colors.orange),
            ),
            SizedBox(height: 4.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("$total_hours / $goal_hours hours"),
                TextButton(onPressed: onAddLogs, child: Text("Add Logs"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
