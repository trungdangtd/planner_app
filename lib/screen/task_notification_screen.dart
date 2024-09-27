import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskNotificationScreen extends StatefulWidget {
  const TaskNotificationScreen({super.key});

  @override
  State<TaskNotificationScreen> createState() => _TaskNotificationScreenState();
}

class _TaskNotificationScreenState extends State<TaskNotificationScreen> {
  bool _notificationsEnabled = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
      final savedHour = prefs.getInt('reminderHour') ?? 9;
      final savedMinute = prefs.getInt('reminderMinute') ?? 0;
      _reminderTime = TimeOfDay(hour: savedHour, minute: savedMinute);
    });
  }

  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', _notificationsEnabled);
    await prefs.setInt('reminderHour', _reminderTime.hour);
    await prefs.setInt('reminderMinute', _reminderTime.minute);
  }

  void _selectReminderTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (pickedTime != null) {
      setState(() {
        _reminderTime = pickedTime;
      });
      _saveSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt thông báo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('Bật thông báo'),
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                });
                _saveSettings();
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Thời gian nhắc nhở'),
                Text(
                    '${_reminderTime.hour}:${_reminderTime.minute.toString().padLeft(2, '0')}'),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _selectReminderTime(context),
              child: const Text('Chọn thời gian'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
              },
              child: const Text('Lưu cài đặt'),
            ),
          ],
        ),
      ),
    );
  }
}
