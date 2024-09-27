import 'package:flutter/material.dart';
import 'package:planner_app/data/model/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class SettingsWidgetScreen extends StatefulWidget {
  const SettingsWidgetScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsWidgetScreen> {
  final List<Color> _availableColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ];

  Color _selectedAppBarColor = Colors.blue; // Default AppBar color
  Color _selectedBackgroundColor = Colors.white; // Default background color

  @override
  void initState() {
    super.initState();
    loadSettings(); // Load settings when the app starts
  }

  Future<void> saveSettings(Color appBarColor, Color backgroundColor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedAppBarColor', appBarColor.value);
    prefs.setInt('selectedBackgroundColor', backgroundColor.value);
  }

  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      int? appBarColorValue = prefs.getInt('selectedAppBarColor');
      int? backgroundColorValue = prefs.getInt('selectedBackgroundColor');

      _selectedAppBarColor = Color(appBarColorValue ?? Colors.blue.value);
      _selectedBackgroundColor =
          Color(backgroundColorValue ?? Colors.white.value);
    });

    // Update the ColorProvider with loaded colors
    Provider.of<ColorProvider>(context, listen: false)
        .setColor(_selectedAppBarColor); // Set AppBar color
    Provider.of<ColorProvider>(context, listen: false)
        .setBackgroundColor(_selectedBackgroundColor); // Set Background color
  }

  void _openAppBarColorPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Chọn màu cho AppBar"),
          content: SingleChildScrollView(
            child: Column(
              children: _availableColors.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAppBarColor =
                          color; // Update selected AppBar color
                    });
                    saveSettings(_selectedAppBarColor, _selectedBackgroundColor); // Save settings
                    Provider.of<ColorProvider>(context, listen: false)
                        .setColor(_selectedAppBarColor); // Update app color
                    Navigator.pop(context); // Close dialog
                  },
                  child: Container(
                    width: 100,
                    height: 50,
                    color: color,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    alignment: Alignment.center,
                    child: Text(
                      "Màu ${color.toString()}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Đóng"),
            ),
          ],
        );
      },
    );
  }

  void _openBackgroundColorPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Chọn màu nền"),
          content: SingleChildScrollView(
            child: Column(
              children: _availableColors.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedBackgroundColor =
                          color; // Update selected background color
                    });
                    saveSettings(_selectedAppBarColor, _selectedBackgroundColor); // Save settings
                    Provider.of<ColorProvider>(context, listen: false)
                        .setBackgroundColor(_selectedBackgroundColor); // Update background color
                    Navigator.pop(context); // Close dialog
                  },
                  child: Container(
                    width: 100,
                    height: 50,
                    color: color,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    alignment: Alignment.center,
                    child: Text(
                      "Màu ${color.toString()}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Đóng"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _selectedBackgroundColor, // Set the background color to the selected background color
      appBar: AppBar(
        title: const Text("Cài đặt"),
        backgroundColor: _selectedAppBarColor, // Set AppBar color to the selected AppBar color
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Màu nền hiện tại:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openBackgroundColorPicker, // Open background color picker
              child: const Text("Chọn màu nền"),
            ),
            const SizedBox(height: 20),
            const Text(
              'Màu AppBar hiện tại:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openAppBarColorPicker, // Open AppBar color picker
              child: const Text("Chọn màu cho AppBar"),
            ),
          ],
        ),
      ),
    );
  }
}
