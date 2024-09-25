import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planner_app/data/model/task_model.dart';

class CardBody extends StatelessWidget {
  const CardBody(
      {super.key,
      required this.item,
      required this.handleDelete,
      required this.updateTask, 
      required this.index});

  final Function(int) handleDelete;
  final Function(TaskModel) updateTask;
  final int index;
  final TaskModel item;

  @override
  Widget build(BuildContext context) {
    Color cardColor = item.status == 'Đang thực hiện'
        ? const Color.fromARGB(255, 104, 189, 189)
        : Colors.green[700]!;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
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
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    DateFormat('dd/MM/yyyy').format(item.date),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item.status,
                    style: const TextStyle(
                      fontSize: 13,
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
                InkWell(
                  onTap: () {
                     updateTask(item);
                  },
                  child: const Icon(
                    Icons.edit_outlined,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
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
                  child: const Icon(
                    Icons.delete_forever_outlined,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
