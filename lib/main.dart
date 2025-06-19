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
  await Hive.openBox('settingsBox');
  final box = await Hive.openBox('skillsBox');
  if (box.get('isInitialized') != true) {
    await box.clear(); // Only clears ONCE
    await box.put('isInitialized', true);
  }
  runApp(skillUp());

}


class skillUp extends StatefulWidget {

  @override
  State<skillUp> createState() => _skillUpState();
}

class _skillUpState extends State<skillUp> {

  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  void _loadTheme(){
    final settingsBox = Hive.box('settingsBox');
    final isDark = settingsBox.get('isDarkMode', defaultValue: false);
    
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    
  }
  void toggleTheme(bool isDark) {
    final settingsBox = Hive.box('settingsBox');
    settingsBox.put('isDarkMode', isDark);
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkillUp',
      theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
  
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      darkTheme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true, brightness: Brightness.dark ),
      home: HomePage(onThemeToggle: toggleTheme, isDarkMode: _themeMode == ThemeMode.dark),
    );
  }
}
