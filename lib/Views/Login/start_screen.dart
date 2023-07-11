import 'package:flutter/material.dart';
import 'package:test_project/Views/Login/signin_screen.dart';
import 'package:test_project/Views/Login/login_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StartButtons(),
      ),
    );
  }
}

class StartButtons extends StatelessWidget {
  const StartButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10), 
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: double.infinity,
            height: 50,
            margin: const EdgeInsets.all(5),
            child: ElevatedButton(
              onPressed: () {
                moveToSigninScreen(context);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                elevation: 4.0,
              ),
              child: const Text(
                '시작하기',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0), // Spacing between buttons
          Container(
            width: double.infinity,
            height: 50,
            margin: const EdgeInsets.all(5),
            child: OutlinedButton(
              onPressed: () {
                moveToLoginScreen(context);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                elevation: 4.0,
                backgroundColor: Colors.white,
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
    );
  }

  void moveToSigninScreen(BuildContext context) async {
    print("move to signin");

    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => SignInScreen()
      ),
    );
  }

  void moveToLoginScreen(BuildContext context) async {
    print("move to login");

    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => LoginScreen()
      ),
    );
  }
}