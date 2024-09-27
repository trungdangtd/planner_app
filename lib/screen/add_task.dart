import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planner_app/data/helper/db_helper.dart';
import 'package:planner_app/data/model/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Form field variables
  String _name = '';
  String _content = '';
  String _location = '';
  String _notes = '';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  String _selectedLeader = 'Thanh Ngân'; // Default value
  String _selectedStatus = 'Đang thực hiện'; // Default value

  Future<void> _addTask() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;

    final newTask = TaskModel(
      name: _name,
      date: _selectedDate,
      content: _content,
      startTime: _startTime,
      endTime: _endTime,
      location: _location,
      leader: _selectedLeader,
      notes: _notes,
      status: _selectedStatus,
      userId: userId,
    );

    await _dbHelper.insertTask(newTask);
    Navigator.pop(context);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (picked != null) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Công Việc'),
       
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
              _buildInputCard('Ghi chú', _notes, (value) => _notes = value),
              const SizedBox(height: 10),
              _buildDateRow('Ngày', _selectedDate, () => _selectDate(context)),
              _buildTimeRow('Thời gian bắt đầu', _startTime,
                  () => _selectStartTime(context)),
              _buildTimeRow('Thời gian kết thúc', _endTime,
                  () => _selectEndTime(context)),
              const SizedBox(height: 10),
              _buildDropdown(
                  'Người lãnh đạo',
                  _selectedLeader,
                  ['Thanh Ngân', 'Hữu Nghĩa'],
                  (value) => _selectedLeader = value!),
              const SizedBox(height: 10),
              _buildDropdown(
                  'Trạng thái',
                  _selectedStatus,
                  ['Đang thực hiện', 'Đã hoàn thành'],
                  (value) => _selectedStatus = value!),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _addTask,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 15.0),
                    backgroundColor:
                        const Color(0xFF398378), // Màu nền cho button
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Thêm nhiệm vụ'),
                ),
              ),
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

  Widget _buildDropdown(String label, String value, List<String> items,
      ValueChanged<String?> onChanged) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          onChanged: (String? newValue) {
            setState(() {
              onChanged(newValue!);
            });
          },
          items: items.map<DropdownMenuItem<String>>((String value) {
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
