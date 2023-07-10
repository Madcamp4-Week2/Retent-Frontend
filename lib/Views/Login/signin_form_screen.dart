import 'package:flutter/material.dart';
import 'package:test_project/Models/user.dart';
import 'package:test_project/Services/base_client.dart';

class SignInFormScreen extends StatefulWidget {
  @override
  _SignInFormScreenState createState() => _SignInFormScreenState();
}

class _SignInFormScreenState extends State<SignInFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _nicknameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final nickname = _nicknameController.text;
      final password = _passwordController.text;

      User newUser  = User(
        emailAddress: email,
        nickname: nickname,
        password: password, 
      );

      // Perform your sign-in logic here
      addUserDB(newUser);

      // Clear the form
      _emailController.clear();
      _nicknameController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();

      // Show a success message or navigate to the next screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign-in successful!'),
        ),
      );
    }
  }

  void addUserDB(User user) async {
    var response = await BaseClient().post('users/', user);
    if (response == null) {
      debugPrint("failed post User");
      return;
    }
    debugPrint("successful post User"); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.0),
              TextFormField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  labelText: 'Nickname',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your nickname';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.0),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.0),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              Spacer(),
              Container(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.all(5),
                child: OutlinedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    elevation: 4.0,
                    backgroundColor: Colors.white,
                  ),
                  child: const Text(
                    '회원가입',
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
      ),
    );
  }
}