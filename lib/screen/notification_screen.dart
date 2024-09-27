import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:planner_app/data/model/task_model.dart';

class TaskNotificationScreen extends StatefulWidget {
  final List<TaskModel> tasks;
  final Function incrementNotificationCount;

  const TaskNotificationScreen(
      {super.key, required this.tasks, required this.incrementNotificationCount});

  @override
  _TaskNotificationScreenState createState() => _TaskNotificationScreenState();
}

class _TaskNotificationScreenState extends State<TaskNotificationScreen> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initializeNotifications();
    _scheduleTaskNotifications(); // Schedule notifications
  }

  // Initialize notifications
  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('icon_app');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Schedule task notifications
  void _scheduleTaskNotifications() {
    _timer = Timer.periodic(const Duration(minutes: 1), (Timer timer) {
      _checkForTaskNotifications();
    });
  }

  // Check if there are any tasks that should trigger a notification
  void _checkForTaskNotifications() {
    final now = DateTime.now();
    for (var task in widget.tasks) {
      // Convert TimeOfDay and Date to a DateTime object
      final taskDateTime = DateTime(
        task.date.year,
        task.date.month,
        task.date.day,
        task.startTime.hour,
        task.startTime.minute,
      );

      // Schedule the notification 1 minute before the task start time
      final notificationTime = taskDateTime.subtract(const Duration(minutes: 1));

      // Trigger notification if the current time matches the notification time
      if (notificationTime.year == now.year &&
          notificationTime.month == now.month &&
          notificationTime.day == now.day &&
          notificationTime.hour == now.hour &&
          notificationTime.minute == now.minute) {
        _showTaskNotification(task); 
      }
    }
  }

  // Show the notification
  void _showTaskNotification(TaskModel task) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Nhắc nhở công việc',
      'Đến giờ bắt đầu công việc: ${task.name}',
      platformChannelSpecifics,
      payload: 'task',
    );

    // Increment the notification count
    widget.incrementNotificationCount();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo nhiệm vụ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: widget.tasks.isEmpty
            ? const Center(
                child: Text(
                  'Không có nhiệm vụ nào cho ngày hôm nay.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              )
            : ListView.builder(
                itemCount: widget.tasks.length,
                itemBuilder: (context, index) {
                  final task = widget.tasks[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      leading: const Icon(
                        Icons.notifications_active,
                        size: 30,
                      ),
                      title: Text(
                        task.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            'Giờ bắt đầu: ${task.startTime.format(context)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Ngày: ${task.date.toLocal().toString().split(' ')[0]}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Nội dung: ${task.content}',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: const Icon(
                        Icons.alarm,
                        size: 30,
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
