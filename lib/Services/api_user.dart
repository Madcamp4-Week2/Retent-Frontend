import 'package:flutter/material.dart';
import 'package:test_project/Services/base_client.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // for json
import 'package:test_project/auth_provider.dart';

void loginUser(String email, String password) async {
  const String baseUrl = 'your_base_url_here';

  final response = await BaseClient().post(
    "dj-rest-auth/login/",
    {
      'email': email,
      'password': password,
    },
  );

  if (response != null) {
    LoginState().updateToken(response);
    var userId = await BaseClient().get('/user/');
    LoginState().updateUserId(userId);
    print('=========userId $userId ========');
  } else {
    throw Exception('Failed to log in');
  }
}

void signinUserDB(
    String nickname, String email, String password1, String password2) async {
  var response = await BaseClient().post(
    '/dj-rest-auth/registration/',
    {
      "email": email,
      "password1": password1,
      "password2": password2,
      "nickname": nickname
    },
  );
  if (response == null) {
    debugPrint("failed post User");
    return;
  }
  throw Exception("successful post User");
}

void signKakao(String token) async {
  var response =
      await BaseClient().post('/kakao-login/', {"kakao_token": token});
  if (response != null) {
    LoginState().updateToken(response);
    var userId = await BaseClient().get('/user/');
    LoginState().updateUserId(userId);
    print('=========userId $userId ========');
  } else {
    throw Exception('Server login failed');
  }
}
