import 'package:flutter/material.dart';

class SelectorModeWidget extends StatefulWidget {
  const SelectorModeWidget({super.key});

  @override
  State<SelectorModeWidget> createState() => _SelectorModeWidgetState();
}

const List<BottomNavigationBarItem> icons = <BottomNavigationBarItem>[
  BottomNavigationBarItem(label: "Off", icon: Icon(Icons.power_settings_new)),
  BottomNavigationBarItem(label: "Antifreeze", icon: Icon(Icons.ac_unit)),
  BottomNavigationBarItem(label: "Manual", icon: Icon(Icons.back_hand)),
  BottomNavigationBarItem(label: "Daily", icon: Icon(Icons.schedule)),
  BottomNavigationBarItem(label: "Weekly", icon: Icon(Icons.calendar_month)),
];

class _SelectorModeWidgetState extends State<SelectorModeWidget> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: icons,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
    );
  }
}
