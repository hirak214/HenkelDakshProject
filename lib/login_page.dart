import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:henkel_daksh_project/admin_page.dart'; // Replace with the correct import path to your AdminPage

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.endsWith('@henkel.com')) {
                    return 'Email must end with @henkel.com';
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  _submitForm();
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onFieldSubmitted: (_){
                  _submitForm();
                },
              ),
              if (_errorMessage != null) ...[
                SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ],
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  _submitForm();
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Validation successful, proceed with login logic
      String email = _emailController.text;
      String password = _passwordController.text;

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Check if the user is an admin (exists in the admin_users collection)
        DocumentSnapshot adminSnapshot = await FirebaseFirestore.instance
            .collection('admin_users').doc(userCredential.user?.uid).get();
        bool isAdmin = adminSnapshot.exists;

        if (isAdmin) {
          // Login successful and user is an admin, navigate to the AdminPage
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AdminPage()),
          );
    } else {
          // User is not an admin, show error message
          setState(() {
            _errorMessage = "You do not have permission to access this page.";
          });
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          setState(() {
            _errorMessage = 'Email account does not exist.';
          });
        } else if (e.code == 'wrong-password') {
          setState(() {
            _errorMessage = 'Wrong password entered.';
          });
        } else {
          setState(() {
            _errorMessage = 'Wrong Credentials, please try again.';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'An error occurred. Please try again later.';
        });
      }
    }
  }
}
