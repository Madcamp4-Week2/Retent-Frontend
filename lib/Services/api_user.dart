import 'package:flutter/material.dart';
import 'package:test_project/Services/base_client.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // for json
import 'package:test_project/auth_provider.dart';
import 'dart:io';

void loginUser(String email, String password) async {
  print('================================');
  var response = await BaseClient().post(
    "/dj-rest-auth/login/",
    {"email": email, "password": password},
  );
  if (response != null) {
    Map<String, dynamic> responseData = jsonDecode(response);
    int pk = responseData['user']['pk'];
    String key = responseData['access'];
    LoginState().updateToken(key);

    LoginState().updateUserId(pk);
    print('=========userId $pk ========');
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
  print('========token======== $token');
  var response =
      await BaseClient().post('/kakao-login/', {"kakao_token": token});

  if (response != null) {
    Map<String, dynamic> responseData = jsonDecode(response);
    String key = responseData['access_token'];
    LoginState().updateToken(key);
    var userId = await BaseClient().get(
      '/dj-rest-auth/user/',
      headers: {
        'Authorization': 'Bearer $key',
      },
    );
    LoginState().updateUserId(userId);
    print('=========userId $userId ========');
  } else {
    throw Exception('Server login failed');
  }
}

Future<int> signinUser(
    String email, String password1, String password2, String nickname) async {
  print('=======$email $password1 $password2 $nickname ======');
  var response = await BaseClient().post(
    "/dj-rest-auth/registration/",
    {
      "email": email,
      "password1": password1,
      "password2": password2,
      "nickname": nickname
    },
  );
  print('================================');
  if (response != null) {
    Map<String, dynamic> responseData = jsonDecode(response);
    int pk = responseData['user']['pk'];
    String key = responseData['access'];
    LoginState().updateToken(key);

    LoginState().updateUserId(pk);
    print('=========userId $pk ========');

    return 200;
  } else {
    throw Exception('Failed to log in');
  }
}
