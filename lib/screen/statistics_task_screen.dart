import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:planner_app/data/helper/db_helper.dart';
import 'package:planner_app/data/model/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StatisticScreenState createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  int totalTasks = 0;
  int inProgressTasks = 0;
  int completedTasks = 0;

  @override
  void initState() {
    super.initState();
    _loadTaskStatistics();
  }

  Future<void> _loadTaskStatistics() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentUserId = prefs.getInt('userId') ?? 0;

    if (currentUserId != 0) {
      List<TaskModel> tasks = await _dbHelper.getTasks(currentUserId);

      setState(() {
        totalTasks = tasks.length;
        inProgressTasks =
            tasks.where((task) => task.status == 'Đang thực hiện').length;
        completedTasks =
            tasks.where((task) => task.status == 'Đã hoàn thành').length;
      });
    } else {
      setState(() {
        totalTasks = 0;
        inProgressTasks = 0;
        completedTasks = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, double> dataMap = {
      "Đang thực hiện": inProgressTasks.toDouble(),
      "Đã hoàn thành": completedTasks.toDouble(),
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống Kê Công Việc'),
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: inProgressTasks > 0 || completedTasks > 0
                  ? PieChart(
                      dataMap: dataMap,
                      animationDuration: const Duration(milliseconds: 800),
                      chartLegendSpacing: 32,
                      chartRadius: MediaQuery.of(context).size.width /
                          2.5, // Tăng kích thước biểu đồ
                      colorList: const [Colors.blue, Colors.green],
                      initialAngleInDegree: 0,
                      chartType: ChartType.disc,
                      ringStrokeWidth: 32,
                      centerText: "Công việc",
                      centerTextStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      legendOptions: const LegendOptions(
                        showLegendsInRow: true,
                        legendPosition: LegendPosition.right,
                        showLegends: true,
                      ),
                    )
                  : const Center(
                      child: Text(
                        'Không có công việc nào để hiển thị',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            Text(
              'Tổng số công việc: $totalTasks',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildTaskSummary(), 
          ],
        ),
      ),
    );
  }

  // Phương thức để hiển thị tóm tắt công việc
  Widget _buildTaskSummary() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSummaryCard("Đang thực hiện", inProgressTasks, Colors.blue),
        _buildSummaryCard("Đã hoàn thành", completedTasks, Colors.green),
      ],
    );
  }

  // Phương thức để tạo thẻ tóm tắt
  Widget _buildSummaryCard(String title, int value, Color color) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: color.withOpacity(0.2), // Màu nền nhạt
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value.toString(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
