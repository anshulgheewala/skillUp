import 'package:flutter/material.dart';

class skillCard extends StatelessWidget {
  final String skillname;
  final int total_hours;
  final int goal_hours;
  final VoidCallback onAddLogs;
  final int streak;

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const skillCard({
    Key? key,
    required this.skillname,
    required this.total_hours,
    required this.goal_hours,
    required this.onAddLogs,
    required this.streak,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 3.0,
      child: Padding(
        padding: EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  skillname,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: onEdit,
                      tooltip: "Edit Skill",
                      iconSize: 20,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: onDelete,
                      tooltip: "Delete Skill",
                      iconSize: 20,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 4.0),
            Text(
              'Total Hours: $total_hours',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 4),
            LinearProgressIndicator(
              value: total_hours / (goal_hours == 0 ? 1 : goal_hours),
              backgroundColor: Colors.grey[300],
              color: Colors.deepPurple,
            ),
            SizedBox(height: 10.0),
            Text(
              '🔥 Streak: $streak days',
              style: TextStyle(fontSize: 16.0, color: Colors.orange),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("$total_hours / $goal_hours hours"),
                TextButton(
                  onPressed: onAddLogs,
                  child: Text("Add Logs"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
