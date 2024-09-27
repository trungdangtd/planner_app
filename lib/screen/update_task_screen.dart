import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planner_app/data/model/task_model.dart';
import 'package:planner_app/data/helper/db_helper.dart';

class UpdateTaskScreen extends StatefulWidget {
  final TaskModel task;

  const UpdateTaskScreen({super.key, required this.task});

  @override
  // ignore: library_private_types_in_public_api
  _UpdateTaskScreenState createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late String _name;
  late DateTime _date;
  late String _content;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late String _location;
  late String _leader;
  late String _notes;
  late String _status;

  @override
  void initState() {
    super.initState();
    _name = widget.task.name;
    _date = widget.task.date;
    _content = widget.task.content;
    _startTime = widget.task.startTime;
    _endTime = widget.task.endTime;
    _location = widget.task.location;
    _leader = widget.task.leader;
    _notes = widget.task.notes;
    _status = widget.task.status;
  }

  Future<void> _updateTask() async {
    final updatedTask = TaskModel(
      id: widget.task.id,
      name: _name,
      date: _date,
      content: _content,
      startTime: _startTime,
      endTime: _endTime,
      location: _location,
      leader: _leader,
      notes: _notes,
      status: _status,
      userId: widget.task.userId,
    );

    await _dbHelper.updateTask(updatedTask);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập nhật công việc'),
        
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _updateTask,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputCard('Tên công việc', _name, (value) => _name = value),
              const SizedBox(height: 10),
              _buildInputCard(
                  'Nội dung', _content, (value) => _content = value),
              const SizedBox(height: 10),
              _buildInputCard(
                  'Địa điểm', _location, (value) => _location = value),
              const SizedBox(height: 10),
              _buildInputCard('Lãnh đạo', _leader, (value) => _leader = value),
              const SizedBox(height: 10),
              _buildInputCard('Ghi chú', _notes, (value) => _notes = value),
              _buildDateRow('Ngày', _date, () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null && pickedDate != _date) {
                  setState(() {
                    _date = pickedDate;
                  });
                }
              }),
              _buildTimeRow('Thời gian bắt đầu', _startTime, () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: _startTime,
                );
                if (pickedTime != null) {
                  setState(() {
                    _startTime = pickedTime;
                  });
                }
              }),
              _buildTimeRow('Thời gian kết thúc', _endTime, () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: _endTime,
                );
                if (pickedTime != null) {
                  setState(() {
                    _endTime = pickedTime;
                  });
                }
              }),
              _buildStatusDropdown(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard(
      String label, String value, Function(String) onChanged) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          decoration: InputDecoration(labelText: label),
          onChanged: onChanged,
          controller: TextEditingController(text: value),
        ),
      ),
    );
  }

  Widget _buildDateRow(String label, DateTime date, VoidCallback onPressed) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$label: ${DateFormat('dd/MM/yyyy').format(date)}'),
            TextButton(
              onPressed: onPressed,
              child: const Text('Chọn Ngày'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRow(String label, TimeOfDay time, VoidCallback onPressed) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                '$label: ${time.hour}:${time.minute.toString().padLeft(2, '0')}'),
            TextButton(
              onPressed: onPressed,
              child: const Text('Chọn Thời gian'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DropdownButton<String>(
          isExpanded: true,
          value: _status,
          onChanged: (String? newValue) {
            setState(() {
              _status = newValue!;
            });
          },
          items: <String>['Đang thực hiện', 'Đã hoàn thành']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
