import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Add this import
import 'package:henkel_daksh_project/admin_page.dart'; // Replace with the correct import path to your AdminPage
import 'package:henkel_daksh_project/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:henkel_daksh_project/login_page.dart';
import 'package:henkel_daksh_project/profile_page.dart';
import 'package:henkel_daksh_project/app_drawer/user_management/tsc_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      home: LoginPage(), // Set the AdminPage as the initial page
    );
  }
}
