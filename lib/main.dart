import 'package:flutter/material.dart';

import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:test_project/Login/signin_screen.dart';
import 'package:test_project/Login/start_screen.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  KakaoSdk.init(nativeAppKey: 'eb740906eb300632214b70239c3013a7');

  runApp(const MyApp());
}

//root of the entire app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Pretendard',
      ),
      home: const StartScreen(), // 로그인 스크린
    );
  }
}

