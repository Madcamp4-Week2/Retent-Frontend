import 'package:flutter/material.dart';
import 'package:test_project/Home/home_screen.dart';
import 'package:test_project/Login/login_platform.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'dart:convert'; //Json
import 'dart:io'; //HttpsHeader

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginPlatform _loginPlatform = LoginPlatform.none;

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loginButton(context),
          ]
        ),
      ),
    );
  }

  Widget loginButton(BuildContext context) {
    return ElevatedButton(
            onPressed: () {
              moveToHomePage(context);
            }, 
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Rounded border
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Button padding
              elevation: 2.0, // Shadow elevation
            ),
            child: const Text(
              '로그인', // Centered text
              style: TextStyle(
                color: Colors.white, // Text color
                fontSize: 16.0, // Text size
                fontFamily: 'Pretendard', // Custom font family
                fontWeight: FontWeight.bold)
            )
          );
  }

  void moveToHomePage(BuildContext context) async {
    print("move to home");

    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => HomeScreen()
      ),
    );
  }
}