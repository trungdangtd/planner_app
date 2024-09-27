import 'package:flutter/material.dart';
import 'package:planner_app/screen/statistics_task_screen.dart';
import 'package:planner_app/screen/widget_setting_screen.dart';
import 'package:planner_app/widget/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:planner_app/screen/task_notification_screen.dart'; // Import the TaskNotificationScreen

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài Đặt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSettingOption(
              context,
              Icons.bar_chart,
              'Xem Thống Kê Công Việc',
              const StatisticScreen(),
            ),
            const SizedBox(height: 20),
            _buildSettingOption(
              context,
              Icons.color_lens,
              'Chỉnh sửa giao diện',
              const SettingsWidgetScreen(),
            ),
            const SizedBox(height: 20),

            _buildSettingOption(
              context,
              Icons.notifications,
              'Cài Đặt Thông Báo Nhiệm Vụ',
              const TaskNotificationScreen(), 
            ),
            const SizedBox(height: 20),

            SwitchListTile(
              title: const Text('Chế độ tối'),
              value: themeNotifier.isDarkMode,
              onChanged: (value) {
                themeNotifier.toggleTheme();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingOption(
      BuildContext context, IconData icon, String title, Widget destination) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFF398378),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => destination,
            ),
          );
        },
      ),
    );
  }
}
