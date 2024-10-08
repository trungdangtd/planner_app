import 'package:flutter/material.dart';
import 'package:planner_app/data/helper/notification_helper.dart';
import 'package:planner_app/screen/add_task.dart';
import 'package:planner_app/data/helper/db_helper.dart';
import 'package:planner_app/data/model/task_model.dart';
import 'package:planner_app/screen/task_notification_screen.dart';
import 'package:planner_app/widget/card_body.dart';
import 'package:planner_app/screen/task_detail_screen.dart';
import 'package:planner_app/screen/update_task_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<TaskModel> _tasks = [];
  int _notificationCount = 0; // Số lượng thông báo

  @override
  void initState() {
    super.initState();
    _fetchTasks();
    _scheduleNotification(const TimeOfDay(hour: 0, minute: 1));
  }
void _scheduleNotification(TimeOfDay time) {
  final now = DateTime.now();
  final scheduledDate = DateTime(now.year, now.month, now.day, time.hour, time.minute);

  if (scheduledDate.isBefore(now)) {
    scheduledDate.add(const Duration(days: 1));
  }

  NotificationHelper().showNotification(0, 'Nhắc nhở công việc', 'Đến giờ thực hiện công việc!');
}
  Future<void> _fetchTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentUserId = prefs.getInt('userId') ?? 0;

    if (currentUserId != 0) {
      List<TaskModel> tasks = await _dbHelper.getTasks(currentUserId);
      setState(() {
        _tasks = tasks.isNotEmpty ? tasks : [];
      });
    } else {
      setState(() {
        _tasks = [];
      });
    }
  }

  void _handleDelete(int taskId) async {
    await _dbHelper.deleteTask(taskId);
    _fetchTasks(); // Làm mới danh sách nhiệm vụ sau khi xóa
  }

  void _updateTask(TaskModel task) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateTaskScreen(task: task),
      ),
    ).then((_) {
      // Làm mới danh sách nhiệm vụ khi trở về từ màn hình cập nhật
      _fetchTasks();
    });
  }

  // ignore: unused_element
  void _incrementNotificationCount() {
    setState(() {
      _notificationCount++;
    });
  }


  void _reorderTasks(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final TaskModel movedTask = _tasks.removeAt(oldIndex);
      _tasks.insert(newIndex, movedTask);
     
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách công việc'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  setState(() {
                    _notificationCount = 0;
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TaskNotificationScreen(),
                    ),
                  );
                },
              ),
              if (_notificationCount > 0) // Chỉ hiển thị khi có thông báo
                Positioned(
                  right: 11,
                  top: 11,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      '$_notificationCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: _tasks.isEmpty
          ? const Center(child: Text('Không có công việc nào.'))
          : ReorderableListView(
              padding: const EdgeInsets.all(15),
              onReorder: _reorderTasks,
              children: [
                for (int index = 0; index < _tasks.length; index++)
                  GestureDetector(
                    key: ValueKey(
                        _tasks[index].id), 
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TaskDetailScreen(task: _tasks[index]),
                        ),
                      );
                    },
                    child: CardBody(
                      item: _tasks[index],
                      handleDelete: _handleDelete,
                      updateTask: _updateTask,
                      index: index,
                    ),
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AddTaskScreen()))
              .then((_) => _fetchTasks());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
