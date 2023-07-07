
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
          height: 100,
          width: 100,
          color: Colors.amber
        ),
      ),
      drawer: Drawer(
        child: ListView( //list of views inside the drawer
          padding: const EdgeInsets.all(0),
          children: <Widget>[ //widgets are listed in an array
            UserAccountsDrawerHeader(
              accountName: Text("Jack"),
              accountEmail: Text("Jack@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
"https://images.unsplash.com/photo-1682686581854-5e71f58e7e3f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxfHx8ZW58MHx8fHx8&auto=format&fit=crop&w=1000&q=60"              ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Random Profile"),
              subtitle: Text("a person"),
              trailing: Icon(Icons.edit),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text("Email"),
              subtitle: Text("email address"),
              trailing: Icon(Icons.edit),
            )

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.edit),
        ),
    );
  }
}