import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_project/Views/Home/home_screen.dart';
import 'package:test_project/Views/Login/login_platform.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'dart:convert'; //Json
import 'dart:io';

import 'package:test_project/auth_provider.dart'; //HttpsHeader

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
            Consumer<LoginState>(
              builder: (context, loginState, _) {
                return TextField(
                  controller: _emailController,
                  onChanged: loginState.updateEmail,
                  decoration: const InputDecoration(
                    labelText: '이메일',
                  ),
                );
              }
            ),
            const SizedBox(height: 24.0),
            Consumer<LoginState>(
              builder: (context, loginState, _) {
                return TextField(
                  controller: _passwordController,
                  onChanged: loginState.updatePassword,
                  decoration: const InputDecoration(
                    labelText: '비밀번호',
                  ),
                  obscureText: true,
                );
              }
            ),
            Spacer(),
            Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.all(5),
              child: ElevatedButton(
                onPressed: () {
                  Login();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
  void Login() async {
    final loginState = Provider.of<LoginState>(context, listen: false);

    final email = _emailController.text;
    final password = _passwordController.text;

    loginState.updateEmail(email);
    loginState.updatePassword(password);

    print("${loginState.email}");

    bool loginSuccess = await loginState.login();
    if(loginSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("로그인 성공"))); 
      moveToHomeScreen();
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Login Failed'),
          content: Text('Invalid email or password.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void moveToHomeScreen() async {
    print("move to home");

    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => HomeScreen()
      ),
    );
  }
}