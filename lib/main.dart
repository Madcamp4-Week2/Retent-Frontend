
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
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(8),
          width: 100,
          height: 100,
          clipBehavior: Clip.antiAlias,  //what happens if child clips with parent
          alignment: Alignment.center, //location of child
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 6,
              ),
            ]),
          child: Text(
            "I am a box",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}