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
        title: Text('Customer Manager'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
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
          _showAddCustomerDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddCustomerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Customer'),
          content: SingleChildScrollView(
            child: CustomerForm(),
          ),
        );
      },
    );
  }
}

class CustomerForm extends StatefulWidget {
  @override
  _CustomerFormState createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  final _formKey = GlobalKey<FormState>();
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _customerId;
  String? _customerDepartment;
  String? _customerAddress;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'First Name',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your first name';
              }
              return null;
            },
            onSaved: (value) {
              _firstName = value;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Last Name',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your last name';
              }
              return null;
            },
            onSaved: (value) {
              _lastName = value;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Email ID',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email ID';
              }
              if (!value.endsWith('@henkel.com')) {
                return 'Email ID must end with @henkel.com';
              }
              return null;
            },
            onSaved: (value) {
              _email = value;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Customer ID',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the customer ID';
              }
              return null;
            },
            onSaved: (value) {
              _customerId = value;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Customer Department',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the customer department';
              }
              return null;
            },
            onSaved: (value) {
              _customerDepartment = value;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Customer Address',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the customer address';
              }
              return null;
            },
            onSaved: (value) {
              _customerAddress = value;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  _submitForm();
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // TODO: Implement code to upload form data to Firebase

      _formKey.currentState?.reset();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Form submitted successfully')),
      );
    }
  }
}
