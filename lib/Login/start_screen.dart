import 'package:flutter/material.dart';
import 'package:test_project/Login/signin_screen.dart';
import 'package:test_project/Login/login_screen.dart';

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            moveToSigninScreen(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey, // Button background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // Rounded border
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Button padding
            elevation: 2.0, // Shadow elevation
          ),
          child: const Text(
            '시작하기', // Button text
            style: TextStyle(
              color: Colors.white, // Text color
              fontSize: 16.0, // Text size
              fontWeight: FontWeight.bold, // Text weight
            ),
          ),
        ),
        const SizedBox(height: 16.0), // Spacing between buttons
        ElevatedButton(
          onPressed: () {
            moveToLoginScreen(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal, // Button background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // Rounded border
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Button padding
            elevation: 2.0, // Shadow elevation
          ),
          child: const Text(
            '로그인', // Button text
            style: TextStyle(
              color: Colors.white, // Text color
              fontSize: 16.0, // Text size
              fontWeight: FontWeight.bold, // Text weight
            ),
          ),
        ),
      ],
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