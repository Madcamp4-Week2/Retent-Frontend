
import 'package:flutter/material.dart';

void main() {
  runApp( MaterialApp(
    home: HomePage(),
    theme: ThemeData(
      primarySwatch: Colors.green
    ),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test App"),
        ),
      body: Container(
        child: Text("Hi Flutter"),
      ),
    );
  }
}