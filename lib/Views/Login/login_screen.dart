import 'package:flutter/material.dart';
import 'package:test_project/Views/Home/home_screen.dart';
import 'package:test_project/Views/Login/login_platform.dart';
import 'package:test_project/Services/api_user.dart';
import 'package:test_project/auth_provider.dart'; // for ApiUser

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginPlatform _loginPlatform = LoginPlatform.none;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: '이메일',
              ),
            ),
            const SizedBox(height: 24.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: '비밀번호',
              ),
              obscureText: true,
            ),
            Spacer(),
            Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.all(5),
              child: ElevatedButton(
                onPressed: () {
                  login();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  elevation: 4.0,
                ),
                child: const Text(
                  '로그인',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      print("=======email $email password $password ==========");
      //loginUser(email, password);
      LoginState().userId = 1;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("로그인 성공")));
      moveToHomeScreen();
    } catch (_) {
      LoginState().userId = 1;
      moveToHomeScreen();
    }
  }

  void moveToHomeScreen() async {
    print("move to home");

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }
}
