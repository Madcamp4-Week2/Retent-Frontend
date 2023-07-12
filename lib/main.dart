import 'package:flutter/material.dart';

import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:provider/provider.dart';
import 'package:test_project/Views/Login/signin_screen.dart';
import 'package:test_project/Views/Login/start_screen.dart';
import 'package:test_project/auth_provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  KakaoSdk.init(nativeAppKey: 'eb740906eb300632214b70239c3013a7');

  initializeDateFormatting().then((_) {
    runApp(const MyApp());
  });
}

//root of the entire app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Pretendard',
        ),
        home: const StartScreen(), // 로그인 스크린
      ),
    );
  }
}
