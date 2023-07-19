import 'package:flutter/material.dart';
import 'package:henkel_daksh_project/admin_page.dart'; // Replace with the correct import path to your AdminPage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Henkel Daksh Admin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AdminPage(), // Set the AdminPage as the initial page
    );
  }
}
