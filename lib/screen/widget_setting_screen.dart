import 'package:flutter/material.dart';
import 'package:planner_app/data/model/color_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class SettingsWidgetScreen extends StatefulWidget {
  const SettingsWidgetScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsWidgetScreen> {
  final List<Color> _availableColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
    Colors.teal,
    Colors.indigo,
  ];

  final List<String> _availableFonts = [
    'Roboto',
    'Arial',
    'Courier New',
    'Times New Roman',
    'Georgia',
  ];

  Color _selectedAppBarColor = Colors.blue; // Default AppBar color
  Color _selectedBackgroundColor = Colors.white; // Default background color
  String _selectedFont = 'Roboto'; // Default font

  @override
  void initState() {
    super.initState();
    loadSettings(); // Load settings when the app starts
  }

  Future<void> saveSettings(Color appBarColor, Color backgroundColor, String font) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedAppBarColor', appBarColor.value);
    prefs.setInt('selectedBackgroundColor', backgroundColor.value);
    prefs.setString('selectedFont', font);
  }

  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      int? appBarColorValue = prefs.getInt('selectedAppBarColor');
      int? backgroundColorValue = prefs.getInt('selectedBackgroundColor');
      _selectedFont = prefs.getString('selectedFont') ?? 'Roboto';

      _selectedAppBarColor = Color(appBarColorValue ?? Colors.blue.value);
      _selectedBackgroundColor = Color(backgroundColorValue ?? Colors.white.value);
    });
    Provider.of<ColorTextProvider>(context, listen: false)
        .setColor(_selectedAppBarColor); // Set AppBar color
    Provider.of<ColorTextProvider>(context, listen: false)
        .setBackgroundColor(_selectedBackgroundColor); // Set Background color
    Provider.of<ColorTextProvider>(context, listen: false)
        .setFont(_selectedFont); // Set font
  }

  void _openColorPicker(String type) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Chọn màu ${type == 'appBar' ? 'cho AppBar' : 'nền'}"),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.0,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: _availableColors.length,
              itemBuilder: (context, index) {
                Color color = _availableColors[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (type == 'appBar') {
                        _selectedAppBarColor = color; // Update selected AppBar color
                      } else {
                        _selectedBackgroundColor = color; // Update selected background color
                      }
                    });
                    saveSettings(_selectedAppBarColor, _selectedBackgroundColor, _selectedFont); // Save settings
                    Provider.of<ColorTextProvider>(context, listen: false)
                        .setColor(_selectedAppBarColor); // Update app color
                    Provider.of<ColorTextProvider>(context, listen: false)
                        .setBackgroundColor(_selectedBackgroundColor); // Update background color
                    Navigator.pop(context); // Close dialog
                  },
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _selectedAppBarColor == color ||
                                _selectedBackgroundColor == color
                            ? Colors.black
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      " ",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
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

  void _openFontPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Chọn phông chữ"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: _availableFonts.length,
              itemBuilder: (context, index) {
                String font = _availableFonts[index];
                return ListTile(
                  title: Text(font,
                      style: TextStyle(
                          fontFamily: font,
                          color: _selectedFont == font ? _selectedAppBarColor : Colors.black)),
                  onTap: () {
                    setState(() {
                      _selectedFont = font; // Update selected font
                    });
                    saveSettings(_selectedAppBarColor, _selectedBackgroundColor, _selectedFont); // Save settings
                    Provider.of<ColorTextProvider>(context, listen: false)
                        .setFont(_selectedFont); // Update font
                    Navigator.pop(context); // Close dialog
                  },
                );
              },
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
      backgroundColor: _selectedBackgroundColor,
      appBar: AppBar(
        title: const Text("Cài đặt giao diện"),
        backgroundColor: _selectedAppBarColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Màu nền hiện tại:',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _selectedAppBarColor),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _selectedAppBarColor, // Use selected AppBar color
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: () => _openColorPicker(
                    'background'), // Open background color picker
                child: const Text("Chọn màu nền",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              const SizedBox(height: 20),
              Text(
                'Màu AppBar hiện tại:',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _selectedAppBarColor),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _selectedAppBarColor, // Use selected AppBar color
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: () =>
                    _openColorPicker('appBar'), // Open AppBar color picker
                child: const Text("Chọn màu cho AppBar",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              const SizedBox(height: 20),
              Text(
                'Phông chữ hiện tại:',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _selectedAppBarColor),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _selectedAppBarColor, // Use selected AppBar color
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: () => _openFontPicker(), // Open font picker
                child: const Text("Chọn phông chữ",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
