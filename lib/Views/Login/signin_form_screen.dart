// signin_form_screen.dart
import 'package:flutter/material.dart';
import 'package:test_project/Services/api_user.dart';
import 'package:test_project/Views/Home/home_screen.dart';

class SignInFormScreen extends StatefulWidget {
  const SignInFormScreen({Key? key}) : super(key: key);

  @override
  _SignInFormScreenState createState() => _SignInFormScreenState();
}

class _SignInFormScreenState extends State<SignInFormScreen> {
  final _emailController = TextEditingController();
  final _password1Controller = TextEditingController();
  final _password2Controller = TextEditingController();
  final _nicknameController = TextEditingController();

  void _signin() async {
    final email = _emailController.text;
    final password1 = _password1Controller.text;
    final password2 = _password2Controller.text;
    final nickname = _nicknameController.text;
    print(
        '======================================================================');
    if (email.isEmpty ||
        password1.isEmpty ||
        password2.isEmpty ||
        nickname.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please fill in all fields.'),
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
    } else {
      final result = await signinUser(
          email, password1, password2, nickname); // Call signinUser function
      if (result == 200) moveToHomeScreen();
    }
  }

  void moveToHomeScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: _password1Controller,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            TextField(
              controller: _password2Controller,
              decoration: InputDecoration(
                labelText: 'Password 확인',
              ),
              obscureText: true,
            ),
            TextField(
              controller: _nicknameController,
              decoration: InputDecoration(
                labelText: 'Nickname',
              ),
            ),
            ElevatedButton(
              child: Text('Sign In'),
              onPressed: _signin,
            ),
          ],
        ),
      ),
    );
  }
}
