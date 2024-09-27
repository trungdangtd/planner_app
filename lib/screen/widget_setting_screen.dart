import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsWidgetScreen extends StatefulWidget {
  const SettingsWidgetScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsWidgetScreen> {
  final List<Color> _availableColors = [Colors.blue, Colors.red, Colors.green];
  Color _selectedColor = Colors.blue;

  final List<String> _availableFonts = ['Roboto', 'Montserrat', 'Lobster'];
  String _selectedFont = 'Roboto';

  @override
  void initState() {
    super.initState();
    loadSettings(); // Tải cài đặt đã lưu khi khởi động màn hình
  }

  // Hàm lưu cài đặt
  Future<void> saveSettings(Color color, String font) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedColor', color.value);
    prefs.setString('selectedFont', font);
  }

  // Hàm tải cài đặt
  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedColor =
          Color(prefs.getInt('selectedColor') ?? Colors.blue.value);
      _selectedFont = prefs.getString('selectedFont') ?? 'Roboto';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tùy chỉnh giao diện'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Chọn màu chủ đạo:'),
            DropdownButton<Color>(
              value: _selectedColor,
              items: _availableColors.map((color) {
                return DropdownMenuItem(
                  value: color,
                  child: Container(
                    width: 100,
                    height: 20,
                    color: color,
                  ),
                );
              }).toList(),
              onChanged: (Color? newColor) {
                setState(() {
                  _selectedColor = newColor!;
                });
                saveSettings(_selectedColor, _selectedFont); 
              },
            ),
            const SizedBox(height: 20),
            const Text('Chọn font chữ:'),
            DropdownButton<String>(
              value: _selectedFont,
              items: _availableFonts.map((font) {
                return DropdownMenuItem(
                  value: font,
                  child: Text(font),
                );
              }).toList(),
              onChanged: (String? newFont) {
                setState(() {
                  _selectedFont = newFont!;
                });
                saveSettings(_selectedColor, _selectedFont); // Lưu lại cài đặt
              },
            ),
          ],
        ),
      ),
    );
  }
}
