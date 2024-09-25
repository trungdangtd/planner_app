import 'package:flutter/material.dart';
import 'package:planner_app/setting_screen.dart';
import 'package:planner_app/widget/calendar_view_screen.dart';
import 'package:planner_app/widget/task_list_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Default to the first tab

  // List of screens
  final List<Widget> _screens = [
    const TaskListScreen(), // Replace with your Task Screen
    const CalendarViewScreen(), // Replace with your Calendar Screen
    const SettingScreen(), // Replace with your Settings Screen
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Công việc',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Lịch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Cài đặt',
          ),
        ],
        currentIndex: _selectedIndex, // Set the current index
        selectedItemColor: Colors.green,
        onTap: _onItemTapped, // Update the selected index on tap
      ),
    );
  }
}
