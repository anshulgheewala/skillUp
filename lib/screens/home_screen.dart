import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:skillup/screens/add_skills.dart';
import 'package:skillup/screens/skill_details.dart';
import 'package:skillup/widgets/skill_card.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final skillsBox = Hive.box('skillsBox');
    final savedSkills = skillsBox.get('skillsList', defaultValue: []) as List;

    setState(() {
      skills = (savedSkills as List)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    });
  }

  void _showLogBottomSheet(int index) {
    final TextEditingController controller = TextEditingController();

    showModalBottomSheet(
      elevation: 10,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Add Log for ${skills[index]['skillName']}",
                  style: TextStyle(fontSize: 18)),
              SizedBox(height: 12),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Hours Practiced"),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  final entered = int.tryParse(controller.text);
                  if (entered != null && entered > 0) {
                    final today = DateTime.now();
                    final todayString =
                        today.toIso8601String().split('T').first;

                    final lastLogString = skills[index]['lastLogDate'] ?? '';
                    DateTime? lastLogDate = lastLogString.isNotEmpty
                        ? DateTime.tryParse(lastLogString)
                        : null;

                    int newStreak = 1;
                    if (lastLogDate != null) {
                      final diff = today.difference(lastLogDate).inDays;
                      if (diff == 1) {
                        newStreak = (skills[index]['streak'] ?? 0) + 1;
                      } else if (diff == 0) {
                        newStreak = skills[index]['streak'] ?? 1;
                      } else {
                        newStreak = 1;
                      }
                    }

                    
                    final updatedSkill =
                        Map<String, dynamic>.from(skills[index]);


                    if (updatedSkill['logs'] == null ||
                        updatedSkill['logs'] is! List) {
                      updatedSkill['logs'] = [];
                    }

                    updatedSkill['hoursDone'] += entered;
                    updatedSkill['lastLogDate'] = todayString;
                    updatedSkill['streak'] = newStreak;
                    updatedSkill['logs'].add({
                      'date': todayString,
                      'hours': entered,
                    });

                    skills[index] = updatedSkill;
                    skillsBox.put('skillsList', skills);

                    // Force re-fetch from Hive
                    final savedSkills =
                        skillsBox.get('skillsList', defaultValue: []) as List;
                    final updatedSkills = savedSkills
                        .map((item) => Map<String, dynamic>.from(item as Map))
                        .toList();

                    setState(() {
                      skills = updatedSkills;
                    });

                    Navigator.pop(context);
                  }
                },
                child: Text("Save"),
              ),
              SizedBox(height: 200),
            ],
          ),
        );
      },
    );
  }

  void _editSkill(int index) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => addSkills(
        initialData: skills[index], // Pass current data
      ),
    ),
  );

  if (result != null && result['skillName'] != null) {
    setState(() {
      skills[index]['skillName'] = result['skillName'];
      skills[index]['description'] = result['description'] ?? '';
      skills[index]['goalHours'] = result['goalHours'] ?? skills[index]['goalHours'];
    });

    skillsBox.put('skillsList', skills);
  }
}


void _deleteSkill(int index) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Delete Skill"),
      content: Text("Are you sure you want to delete '${skills[index]['skillName']}'?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              skills.removeAt(index);
              skillsBox.put('skillsList', skills);
            });
            Navigator.pop(context);
          },
          child: Text("Delete"),
        ),
      ],
    ),
  );
}


  final skillsBox = Hive.box('skillsBox');
  List<Map<String, dynamic>> skills = [];
  @override
  Widget build(BuildContext context) {
    int completedSkills = skills.where((skill) {
      return skill['hoursDone'] >= skill['goalHours'];
    }).length;
    return Scaffold(
      appBar: AppBar(
        title: Text('SkillUp'),
        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: (){
                  SnackBar snackBar = SnackBar(
                    content: Text('Hurray!! You have completed $completedSkills skills!'),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(16),
                    
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  
                },
                child: Icon(
                  Icons.celebration_rounded,
                  color: Colors.amber,
                  
                ),
              ),
              SizedBox(width: 4),
              Text(
                '$completedSkills',
              ),
              SizedBox(width: 25),
            ],
          )
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: skills.length,
        itemBuilder: (context, index) {
          final skill = skills[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SkillDetails(skill: skill),
                ),
              );
            },
            child: skillCard(
              skillname: skill['skillName'] ?? 'Unknown Skill',
              total_hours: skill['hoursDone'] ?? 0,
              goal_hours: skill['goalHours'] ?? 1,
              onAddLogs: () => _showLogBottomSheet(index),
              streak: skill['streak'] ?? 0,
              onEdit: () => _editSkill(index),
              onDelete: () => _deleteSkill(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => addSkills()));

          if (result != null && result['skillName'] != null) {
            setState(() {
              skills.add({
                'skillName': result['skillName'],
                'description': result['description'] ?? '',
                'goalHours': result['goalHours'] ?? 0,
                'hoursDone': 0, // initialize this here!
                'lastLogDate': '',
                'streak': 0,
                'logs': [],
              });
            });

            skillsBox.put('skillsList', skills);
          }
        },
        child: Icon(Icons.add),
        tooltip: "Add Skill",
      ),
    );
  }
}
