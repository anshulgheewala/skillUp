import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class themeSwitch extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onToggle;

  const themeSwitch({
    Key? key,
    required this.isDark,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
                height: 30,
                width: 50,
                activeColor: Colors.blueGrey,
                inactiveColor: Colors.deepPurple,
                value: isDark,
                padding: 5,
                toggleSize: 20,

                activeIcon: Icon(
                  Icons.brightness_2_rounded,
                  color: Colors.blueGrey,
                  size: 20,
                ),
                inactiveIcon: Icon(
                  Icons.wb_sunny_rounded,
                  color: Colors.amber,
                  size: 20,
                ),

                onToggle: onToggle,
               

              );
  }
}