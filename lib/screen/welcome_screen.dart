import 'package:flutter/material.dart';
import 'package:planner_app/screen/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(200, 230, 201, 1),
      appBar: AppBar(
          title: const Text('Daily Planner'),
          ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/daily-planner-high-resolution-logo-transparent.png',
              width: 250,
              height: 250,
            ),
            const SizedBox(height: 20),
            const Text(
              'Chào mừng đến với Daily Planner',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF398378),
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
              child: const Text(
                'Đăng nhập',
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
