import 'package:flutter/material.dart';

class CustomerApplicatorScreen extends StatefulWidget {
  @override
  _CustomerApplicatorScreenState createState() =>
      _CustomerApplicatorScreenState();
}

class _CustomerApplicatorScreenState extends State<CustomerApplicatorScreen> {
  List<String> entries = [
    'Applicator 1',
    'Applicator 2',
    'Applicator 3',
    // Add more entries as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Applicator'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Customer Applicator Users',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: entries.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(entries[index]),
                  // Add any additional fields or widgets to display applicator information
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle "Add Applicator" button tap
          _showAddApplicatorDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddApplicatorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Applicator'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Add applicator form goes here...'),
                // Add form fields to capture applicator details
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
                // Add logic to save the applicator details to Firebase
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
