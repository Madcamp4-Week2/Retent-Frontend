import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_project/Views/Home/home_screen.dart';
import 'package:test_project/Views/Login/signin_form_screen.dart';
import 'package:test_project/Views/Login/login_platform.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'dart:convert'; //Json
import 'dart:io';

import 'package:test_project/auth_provider.dart'; //HttpsHeader
import 'package:test_project/Services/api_user.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  LoginPlatform _loginPlatform = LoginPlatform.none;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loginPlatform = LoginPlatform.none;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: _loginPlatform != LoginPlatform.none
              ? StartButton()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _loginKakaoButton(),
                    const SizedBox(height: 16.0),
                    _loginGoogleButton(),
                    const SizedBox(height: 16.0),
                    _loginEmailButton(),
                  ],
                )),
    );
  }

  Widget _loginKakaoButton() {
    return ElevatedButton(
      onPressed: () {
        signInWithKakao();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Rounded border
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: 16.0, vertical: 12.0), // Button padding
        elevation: 2.0, // Shadow elevation
      ),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/image/kakao_logo.png', // Image path
              width: 24.0, // Image width
              height: 24.0, // Image height
            ),
            const SizedBox(width: 10.0), // Spacing between image and text
            const Text(
              '카카오 로그인', // Centered text
              style: TextStyle(
                  color: Colors.white, // Text color
                  fontSize: 16.0, // Text size
                  fontFamily: 'Pretendard', // Custom font family
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginGoogleButton() {
    return ElevatedButton(
      onPressed: () {
        signInWithGoogle();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Rounded border
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: 16.0, vertical: 12.0), // Button padding
        elevation: 2.0, // Shadow elevation
      ),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/image/kakao_logo.png', // Image path
              width: 24.0, // Image width
              height: 24.0, // Image height
            ),
            const SizedBox(width: 10.0), // Spacing between image and text
            const Text(
              '구글 로그인', // Centered text
              style: TextStyle(
                  color: Colors.white, // Text color
                  fontSize: 16.0, // Text size
                  fontFamily: 'Pretendard', // Custom font family
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginEmailButton() {
    return ElevatedButton(
      onPressed: () {
        signInWithEmail();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Rounded border
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: 16.0, vertical: 12.0), // Button padding
        elevation: 2.0, // Shadow elevation
      ),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/image/kakao_logo.png', // Image path
              width: 24.0, // Image width
              height: 24.0, // Image height
            ),
            const SizedBox(width: 10.0), // Spacing between image and text
            const Text(
              '이메일 로그인', // Centered text
              style: TextStyle(
                  color: Colors.white, // Text color
                  fontSize: 16.0, // Text size
                  fontFamily: 'Pretendard', // Custom font family
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  Widget StartButton() {
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.all(30),
      child: ElevatedButton(
        onPressed: () {
          moveToHomeScreen();
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
    );
  }

  void signInWithKakao() async {
    try {
      print("test1");
      final loginState = Provider.of<LoginState>(context, listen: false);
      print("test1");
      bool isInstalled = await isKakaoTalkInstalled();
      print("test1");
      OAuthToken token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk() // 설치되었으면 카카오톡으로 로그인
          : await UserApi.instance.loginWithKakaoAccount(); // 설치 안되었으면 계정으로 로그인

      final url = Uri.https('kapi.kakao.com', '/v2/user/me');

      final response = await http.get(
        // 토큰으로 response을 받음
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
        },
      );
      print("test2");
      final profileInfo =
          json.decode(response.body); // 로그인 후 프로필 정보를 response에서 받음

      loginState.updateEmail(profileInfo['kakao_account']['email']);
      print(loginState.email);

      setState(() {
        // 카카오톡으로 로그인했음으로 저장
        _loginPlatform = LoginPlatform.kakao;
      });
      print("test3");
      signKakao(token.accessToken);
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');
    }
  }

  void signInWithEmail() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignInFormScreen()),
    );
  }

  void signInWithGoogle() async {}

  void signOut() async {
    switch (_loginPlatform) {
      case LoginPlatform.google:
        break;
      case LoginPlatform.kakao:
        await UserApi.instance.logout();
        break;
      case LoginPlatform.email:
        break;
      case LoginPlatform.none:
        break;
    }

    setState(() {
      // 로그인 안했음으로 저장
      _loginPlatform = LoginPlatform.none;
    });
  }

  void moveToHomeScreen() async {
    print("move to home");

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }
}
