import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginState extends ChangeNotifier {
  static final LoginState _singleton = LoginState._internal();

  factory LoginState() {
    return _singleton;
  }

  LoginState._internal();

  String token = '';
  int userId = 1;

  void updateToken(String value) {
    token = value;
    notifyListeners();
  }

  void updateUserId(int value) {
    userId = value;
    notifyListeners();
  }
}
