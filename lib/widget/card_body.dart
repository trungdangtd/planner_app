import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planner_app/data/model/task_model.dart';

class CardBody extends StatelessWidget {
  const CardBody({
    super.key,
    required this.item,
    required this.handleDelete,
    required this.updateTask,
    required this.index,
  });

  final Function(int) handleDelete;
  final Function(TaskModel) updateTask;
  final int index;
  final TaskModel item;

  @override
  Widget build(BuildContext context) {
    // Kiểm tra chế độ sáng tối
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Màu thẻ theo chế độ sáng hoặc tối
    Color cardColor = item.status == 'Đang thực hiện'
        ? (isDarkMode
            ? const Color.fromARGB(255, 58, 108, 108) 
            : const Color.fromARGB(255, 104, 189, 189)) 
        : (isDarkMode
            ? Colors.green[400]! 
            : Colors.green[700]!); 

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 20, // Kích thước chữ lớn hơn
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${DateFormat('dd/MM/yyyy').format(item.date)} | ${item.startTime.hour}:${item.startTime.minute.toString().padLeft(2, '0')} - ${item.endTime.hour}:${item.endTime.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 16, // Kích thước chữ lớn hơn
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item.status,
                    style: const TextStyle(
                      fontSize: 16, // Kích thước chữ lớn hơn
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIconButton(
                  icon: Icons.edit_outlined,
                  onTap: () {
                    updateTask(item);
                  },
                ),
                const SizedBox(height: 10),
                _buildIconButton(
                  icon: Icons.delete_forever_outlined,
                  onTap: () async {
                    // Confirmation before deletion
                    bool? confirmed = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Xác nhận'),
                        content: const Text(
                            'Bạn có chắc chắn muốn xóa công việc này không?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Hủy'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Xóa'),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      handleDelete(item.id!);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(
      {required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1), // Màu nền nhẹ
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
