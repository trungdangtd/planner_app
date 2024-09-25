import 'package:flutter/material.dart';
import 'package:planner_app/widget/add_task.dart';
import 'package:planner_app/data/helper/db_helper.dart';
import 'package:planner_app/data/model/task_model.dart';
import 'package:planner_app/widget/calendar_view_screen.dart';
import 'package:planner_app/widget/card_body.dart';
import 'package:planner_app/widget/task_detail_screen.dart';
import 'package:planner_app/widget/update_task_screen.dart';

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
     _fetchTasks(); // Fetch tasks when the screen is initialized
  }

  Future<void> _fetchTasks() async {
    // Replace `currentUserId` with the actual logged-in user's ID
    int currentUserId = 1; // Example user ID

    List<TaskModel> tasks = await _dbHelper.getTasks(currentUserId);
    setState(() {
      _tasks = tasks.isNotEmpty
          ? tasks
          : []; // Ensure _tasks is an empty list if no tasks are found
    });
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
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        title: const Text('Danh sách công việc'),
        backgroundColor: const Color(0xFF398378),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              // Navigate to the Calendar View screen
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const CalendarViewScreen()));
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
