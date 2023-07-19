import 'package:flutter/material.dart';

class TcsScreen extends StatefulWidget {
  @override
  _TcsScreenState createState() => _TcsScreenState();
}

class _TcsScreenState extends State<TcsScreen> {
  List<String> entries = [
    'Entry 1',
    'Entry 2',
    'Entry 3',
    // Add more entries as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TCS'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'TCS Users',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: entries.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(entries[index]),
                  // Add any additional fields or widgets to display user information
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle "Add User" button tap
          _showAddUserDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddUserDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add User'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Add user form goes here...'),
                // Add form fields to capture user details
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Handle "Cancel" button tap
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle "Save" button tap
                // Add logic to save the user details to Firebase
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
