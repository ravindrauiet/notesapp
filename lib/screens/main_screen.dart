import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'home_screen.dart';
import 'archive_screen.dart';
import 'trash_screen.dart';
import 'reminders_screen.dart';
import 'labels_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const RemindersScreen(),
    const LabelsScreen(),
    const ArchiveScreen(),
    const TrashScreen(),
  ];

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: MdiIcons.lightbulb,
      label: 'Notes',
      index: 0,
    ),
    NavigationItem(
      icon: MdiIcons.bellOutline,
      label: 'Reminders',
      index: 1,
    ),
    NavigationItem(
      icon: MdiIcons.pencilOutline,
      label: 'Labels',
      index: 2,
    ),
    NavigationItem(
      icon: MdiIcons.archiveOutline,
      label: 'Archive',
      index: 3,
    ),
    NavigationItem(
      icon: MdiIcons.deleteOutline,
      label: 'Trash',
      index: 4,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _navigationItems.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item.icon),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  final int index;

  NavigationItem({
    required this.icon,
    required this.label,
    required this.index,
  });
}
