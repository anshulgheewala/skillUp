import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:skillup/screens/barchart.dart';



class SkillDetails extends StatelessWidget {
  final Map<String, dynamic> skill;

  const SkillDetails({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    final logs = (skill['logs'] as List?)
    ?.where((log) => log != null)
    .map((log) => Map<String, dynamic>.from(log as Map))
    .toList() ?? [];


    return Scaffold(
      appBar: AppBar(
        title: Text(skill['skillName'] ?? 'Skill Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'description: ${skill['description'] ?? 'No description provided'}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8),
            Text('Progress: ${skill['hoursDone']} / ${skill['goalHours']} hours'),
            SizedBox(height: 8),
            Text('🔥 Streak: ${skill['streak']} days'),
            SizedBox(height: 8),
            Text('📅 Last Log: ${skill['lastLogDate'] ?? 'Never'}'),
            SizedBox(height: 16),
            Text('Logs:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 8),
            Expanded(
              child: logs.isEmpty
                  ? Center(child: Text('No logs available.'))
                  : ListView.builder(
                      itemCount: logs.length,
                      itemBuilder: (context, index) {
                        final log = logs[index];
                        return ListTile(
                          title: Text('${log['hours']} hours'),
                          subtitle: Text('updated at ${DateTime.now().hour.toString()}:${DateTime.now().minute.toString()} on ${DateTime.now().day.toString()}/${DateTime.now().month.toString()}/${DateTime.now().year.toString()}'),
                        );
                      },
                    ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                "Weekly Chart for ${skill['skillName']}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            WeeklyBarChart(logs: logs),
          ],
        ),
      ),
    );
  }
}

