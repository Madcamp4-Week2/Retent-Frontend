
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
        color: Colors.grey,
        child: Column( //row crossaxisalignment depends on parent
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8),
              width: 100,
              height: 100,
              color: Colors.red,
              alignment: Alignment.center,
              child: Text(
                "First Box",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,),),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              width: 100,
              height: 100,
              color: Colors.green,
              alignment: Alignment.center,
              child: Text(
                "Second Box",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,),),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              width: 100,
              height: 100,
              color: Colors.blue,
              alignment: Alignment.center,
              child: Text(
                "Third Box",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,),),
            ),
          ],
        ),
      ),
    );
  }
}