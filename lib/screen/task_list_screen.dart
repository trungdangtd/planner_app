import 'package:flutter/material.dart';
import 'package:planner_app/screen/add_task.dart';
import 'package:planner_app/data/helper/db_helper.dart';
import 'package:planner_app/data/model/task_model.dart';
import 'package:planner_app/screen/calendar_view_screen.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchTasks();
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
    _fetchTasks(); // Refresh the task list after deletion
  }

  void _updateTask(TaskModel task) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateTaskScreen(task: task),
      ),
    ).then((_) {
      // Refresh the task list when coming back from update screen
      _fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách công việc'),
        
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              // Navigate to the Calendar View screen
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const CalendarViewScreen()));
            },
          ),
        ],
      ),
      body: _tasks.isEmpty
          ? const Center(child: Text('Không có công việc nào.'))
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Navigate to the Task Detail screen
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
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the Add New Task screen
          Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AddTaskScreen()))
              .then((_) => _fetchTasks());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
