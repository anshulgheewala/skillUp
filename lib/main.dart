import "dart:async";

import "package:flutter/material.dart";
import "package:hive_flutter/adapters.dart";
import "package:skillup/screens/home_screen.dart";
import "package:skillup/screens/notification.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  NotificationService.scheduleDailyReminder();
  await Hive.initFlutter();

  await Hive.openBox('skillsBox');
  final box = await Hive.openBox('skillsBox');
  if (box.get('isInitialized') != true) {
    await box.clear(); // Only clears ONCE
    await box.put('isInitialized', true);
  }
  runApp(skillUp());

}


class skillUp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkillUp',
      theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
