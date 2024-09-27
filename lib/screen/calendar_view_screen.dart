import 'package:flutter/material.dart';
import 'package:planner_app/data/helper/db_helper.dart';
import 'package:planner_app/data/model/task_model.dart';
import 'package:planner_app/widget/card_body.dart';
import 'package:planner_app/screen/update_task_screen.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarViewScreen extends StatefulWidget {
  const CalendarViewScreen({super.key});

  @override
  State<CalendarViewScreen> createState() => _CalendarViewScreenState();
}

class _CalendarViewScreenState extends State<CalendarViewScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<TaskModel>> _tasksByDate = {};
  List<TaskModel> _selectedDayTasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasksForCalendar();
  }

  Future<void> _fetchTasksForCalendar() async {
    // Replace `currentUserId` with the actual logged-in user's ID
    int currentUserId = 1; // Example user ID

    List<TaskModel> tasks = await _dbHelper.getTasks(currentUserId);
    setState(() {
      _tasksByDate = _groupTasksByDate(tasks);
      _selectedDayTasks = _tasksByDate[_focusedDay] ?? [];
    });
  }

  Map<DateTime, List<TaskModel>> _groupTasksByDate(List<TaskModel> tasks) {
    Map<DateTime, List<TaskModel>> data = {};

    for (var task in tasks) {
      // Normalize the task date to just the date (time set to midnight)
      DateTime taskDate =
          DateTime(task.date.year, task.date.month, task.date.day);

      // Initialize the list if it doesn't exist for the given date
      if (data[taskDate] == null) {
        data[taskDate] = [];
      }

      // Add the task to the list for that date
      data[taskDate]!.add(task);
    }

    return data;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;

      // Normalize the selected day for lookup
      DateTime normalizedSelectedDay =
          DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
      _selectedDayTasks = _tasksByDate[normalizedSelectedDay] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Lịch công việc'),
          ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2022, 1, 1),
            lastDay: DateTime.utc(2050, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: (day) => _tasksByDate[day] ?? [],
            onDaySelected: _onDaySelected,
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              markerDecoration: const BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.blue.shade100,
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: Color(0xFF398378),
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF398378),
              ),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Color(0xFF398378)),
              weekendStyle: TextStyle(color: Colors.red),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _selectedDayTasks.isEmpty
                ? const Center(
                    child: Text(
                    'Không có công việc nào trong ngày này.',
                  ))
                : ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: _selectedDayTasks.length,
                    itemBuilder: (context, index) {
                      return CardBody(
                        item: _selectedDayTasks[index],
                        handleDelete: (taskId) {
                          _handleDelete(taskId);
                        },
                        updateTask: (task) {
                          // Navigate to the Update Task screen
                          // and pass the task object to update
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => UpdateTaskScreen(task: task),
                            ),
                          ).then((_) {
                            _fetchTasksForCalendar();
                          });
                        },
                        index: index,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _handleDelete(int taskId) async {
    await _dbHelper.deleteTask(taskId);
    _fetchTasksForCalendar(); // Refresh the task list after deletion
  }
}
