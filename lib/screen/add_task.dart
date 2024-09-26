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
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();

  // Dropdown values
  String _selectedLeader = 'Thanh Ngân'; // Default value
  final List<String> _leaders = ['Thanh Ngân', 'Hữu Nghĩa'];

  String _selectedStatus = 'Đang thực hiện'; // Default value
  final List<String> _status = ['Đang thực hiện', 'Đã hoàn thành'];

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

  Future<void> _addTask() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int userId = prefs.getInt('userId') ?? 0;

      final newTask = TaskModel(
        name: _nameController.text,
        date: _selectedDate,
        content: _contentController.text,
        startTime: _startTime,
        endTime: _endTime,
        location: _locationController.text,
        leader: _selectedLeader,
        notes: _notesController.text,
        status: _selectedStatus,
        userId: userId,
      );

      await _dbHelper.insertTask(newTask);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        title: const Text('Thêm Công Việc'),
        backgroundColor: const Color(0xFF398378),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextFormField(_nameController, 'Tên Công Việc'),
                const SizedBox(height: 16),
                _buildTextFormField(_contentController, 'Nội Dung'),
                const SizedBox(height: 16),
                _buildTextFormField(_locationController, 'Địa Điểm'),
                const SizedBox(height: 16),
                _buildDropdownFormField<String>(
                  _selectedLeader,
                  'Người Quản Lý',
                  _leaders,
                  (String? newValue) {
                    setState(() {
                      _selectedLeader = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildDropdownFormField<String>(
                  _selectedStatus,
                  'Trạng Thái',
                  _status,
                  (String? newValue) {
                    setState(() {
                      _selectedStatus = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildTextFormField(_notesController, 'Ghi Chú'),
                const SizedBox(height: 16),
                _buildDateTimeSelector(
                    'Ngày',
                    DateFormat('yyyy-MM-dd').format(_selectedDate),
                    () => _selectDate(context)),
                const SizedBox(height: 16),
                _buildDateTimeSelector(
                    'Thời Gian Bắt Đầu',
                    '${_startTime.hour}:${_startTime.minute} giờ',
                    () => _selectStartTime(context)),
                const SizedBox(height: 16),
                _buildDateTimeSelector(
                    'Thời Gian Kết Thúc',
                    '${_endTime.hour}:${_endTime.minute} giờ',
                    () => _selectEndTime(context)),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _addTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF398378),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                    ),
                    child: const Text(
                      'Thêm Công Việc',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập $label';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownFormField<T>(
    T value,
    String label,
    List<T> items,
    ValueChanged<T?> onChanged,
  ) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(item.toString()),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Vui lòng chọn $label';
        }
        return null;
      },
    );
  }

  Widget _buildDateTimeSelector(
      String label, String value, VoidCallback onPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$label: $value', style: const TextStyle(fontSize: 16)),
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF398378)),
          child: const Text('Chọn', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
