import 'package:flutter/material.dart';
import 'package:planner_app/data/helper/db_helper.dart';
import 'package:planner_app/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final DatabaseHelper _databaseService = DatabaseHelper();
  @override
  void initState() {
    super.initState();
    // _insertSampleUser();
  }

  // ignore: unused_element
  void _insertSampleUser() async {
    await _databaseService.insertUser('trungdang1301@gmail.com', 'Abc13012003');
  }

  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Kiểm tra thông tin đăng nhập
    final user = await _databaseService.getUser(email, password);

    if (user != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', user.id!);
      // Đăng nhập thành công, điều hướng đến màn hình khác (ví dụ Task List)
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const MainScreen()));
    } else {
      // Đăng nhập thất bại, hiển thị thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email hoặc mật khẩu không chính xác!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
          title: const Text('Đăng nhập'),
          backgroundColor: const Color(0xFF398378)),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Đăng Nhập',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF398378),
                    textBaseline: TextBaseline.alphabetic),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFF398378),
              ),
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFF398378),
              ),
              child: TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu',
                  labelStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                ),
                style: const TextStyle(color: Colors.white),
                obscureText: true,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF398378),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text(
                'Đăng Nhập',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
