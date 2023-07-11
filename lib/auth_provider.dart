import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginState extends ChangeNotifier {
  String email = '';
  String password = '';
  int userId = 1;

  void updateEmail(String value) {
    email = value;
    notifyListeners();
  }

  void updatePassword(String value) {
    password = value;
    notifyListeners();
  }

  void updateUserId() {
    //api로 현재 email, password 정보 보내고 id 받아옴
  }

  Future<bool> login() async {
    // Perform login authentication using email and password
    // You can use async operations such as API calls or database queries here
    // Example code:
    // bool success = await AuthService.login(email, password);
    // if (success) {
    //   // Handle successful login
    // } else {
    //   // Handle login failure
    // }

    return true; //일단 무조건 로그인으로   
  }
}