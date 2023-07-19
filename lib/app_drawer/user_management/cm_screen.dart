import 'package:flutter/material.dart';

class CustomerManagerScreen extends StatefulWidget {
  @override
  _CustomerManagerScreenState createState() => _CustomerManagerScreenState();
}

class _CustomerManagerScreenState extends State<CustomerManagerScreen> {
  List<String> entries = [
    'Customer 1',
    'Customer 2',
    'Customer 3',
    // Add more entries as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Manager'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Customer Manager Users',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: entries.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(entries[index]),
                  // Add any additional fields or widgets to display customer information
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle "Add Customer" button tap
          _showAddCustomerDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddCustomerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Customer'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Add customer form goes here...'),
                // Add form fields to capture customer details
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
                // Add logic to save the customer details to Firebase
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
