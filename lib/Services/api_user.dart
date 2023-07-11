import 'package:flutter/material.dart';
import 'package:test_project/Services/base_client.dart';

void signinUserDB(String nickname, String email, String password1, String password2) async {
  var response = await BaseClient().post(
    '/dj-rest-auth/registration/', 
    {"email" : email, "password1" : password1, "password2" : password2, "nickname" : nickname},
  );
  if (response == null) {
    debugPrint("failed post User");
    return;
  }
  debugPrint("successful post User"); 
}

