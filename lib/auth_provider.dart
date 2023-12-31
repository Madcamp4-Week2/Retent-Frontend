import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_project/Models/deck.dart';
import 'package:test_project/Services/api_deck.dart';

class LoginState extends ChangeNotifier {
  static final LoginState _singleton = LoginState._internal();

  List<Deck> myDeckList = [];
  String email = '';
  String token = '';
  int userId = 1;

  factory LoginState() {
    return _singleton;
  }

  LoginState._internal();

  void updateEmail(String value) {
    email = value;
    notifyListeners();
  }

  void updateDeckList() async {
    myDeckList = await getMyDecksDB(userId);
    print("--------myDeck provider updated---------");
    print(myDeckList);
    notifyListeners();
  }

  void updateToken(String value) {
    token = value;
    notifyListeners();
  }

  void updateUserId(int value) {
    userId = value;
    notifyListeners();
  }
}
