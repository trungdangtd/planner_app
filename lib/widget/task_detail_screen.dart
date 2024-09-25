import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planner_app/data/helper/db_helper.dart';
import 'package:planner_app/data/model/task_model.dart';
import 'package:planner_app/widget/update_task_screen.dart'; // Make sure to import your UpdateTaskScreen

class TaskDetailScreen extends StatelessWidget {
  final TaskModel task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text('Chi Tiết Công Việc'),
        backgroundColor: const Color(0xFF398378),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailCard('Tên Công Việc', task.name, Icons.task),
              const SizedBox(height: 10),
              _buildDetailCard(
                  'Ngày',
                  DateFormat('dd/MM/yyyy').format(task.date),
                  Icons.calendar_today),
              const SizedBox(height: 10),
              _buildDetailCard('Nội Dung', task.content, Icons.description),
              const SizedBox(height: 10),
              _buildDetailCard(
                'Thời Gian',
                '${task.startTime.hour}:${task.startTime.minute.toString().padLeft(2, '0')} giờ - ${task.endTime.hour}:${task.endTime.minute.toString().padLeft(2, '0')} giờ',
                Icons.access_time,
              ),
              const SizedBox(height: 10),
              _buildDetailCard('Địa Điểm', task.location, Icons.location_on),
              const SizedBox(height: 10),
              _buildDetailCard('Người Dẫn Dắt', task.leader, Icons.person),
              const SizedBox(height: 10),
              _buildDetailCard('Ghi Chú', task.notes, Icons.notes),
              const SizedBox(height: 20),

              // Button to navigate to the edit task screen
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateTaskScreen(task: task),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: const Color(0xFF398378), // Text color
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 30),
                    ),
                    child: const Text('Chỉnh Sửa Công Việc'),
                  ),
                  const SizedBox(height: 10),

                  // Button to mark the task as completed
                  ElevatedButton(
                    onPressed: () async {
                      if (task.status != 'Đã hoàn thành') {
                        // Show confirmation dialog before marking as completed
                        bool? confirmed = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Xác nhận'),
                            content: const Text(
                                'Bạn có chắc chắn muốn đánh dấu công việc này đã hoàn thành không?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Hủy'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Đồng Ý'),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true) {
                          // Update the task status in the database
                          await DatabaseHelper()
                              .updateTaskStatus(task.id!, 'Đã hoàn thành');

                          // Show a message and navigate back to the task list
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Công việc đã được đánh dấu hoàn thành!')),
                          );

                          Navigator.pop(
                            context,
                          ); // Navigate back to the previous screen
                        }
                      } else {
                        // Show a message that the task is already completed
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Công việc này đã hoàn thành!')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: const Color(0xFF398378), // Button color
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 30),
                    ),
                    child: const Text('Đánh Dấu Hoàn Thành'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build a detail card
  Widget _buildDetailCard(String title, String value, IconData icon) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF398378), size: 30),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(value, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
