import 'package:flutter/material.dart';

class TcsScreen extends StatefulWidget {
  @override
  _TcsScreenState createState() => _TcsScreenState();
}

class _TcsScreenState extends State<TcsScreen> {
  List<Map<String, dynamic>> users = [
    {
      'First Name': 'Hirak',
      'Last Name': 'Desai',
      'Email ID': 'hirak.d@henkel.com',
      'Status': 'Active',
    },
    {
      'First Name': 'Yashvi',
      'Last Name': 'Agrawal',
      'Email ID': 'yashvi.a@henkel.com',
      'Status': 'Inactive',
    },
    // Add more user data as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TCS'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'TCS User List',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: _buildTableColumns(),
              rows: _buildTableRows(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddUserDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  List<DataColumn> _buildTableColumns() {
    return [
      DataColumn(label: Text('First Name')),
      DataColumn(label: Text('Last Name')),
      DataColumn(label: Text('Email ID')),
      DataColumn(label: Text('Status')),
      DataColumn(label: Text('Action')),
    ];
  }

  List<DataRow> _buildTableRows() {
    return users.map((user) {
      return DataRow(
        cells: [
          DataCell(Text(user['First Name'] ?? '')),
          DataCell(Text(user['Last Name'] ?? '')),
          DataCell(Text(user['Email ID'] ?? '')),
          DataCell(Text(user['Status'] ?? '')),
          DataCell(IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // TODO: Implement edit action
            },
          )),
        ],
      );
    }).toList();
  }

  void _showAddUserDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: UserForm(),
          ),
        );
      },
    );
  }
}

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _userData = {
    'First Name': '',
    'Last Name': '',
    'Email ID': '',
    'Region': '',
    'Reporting Manager Email ID': '',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        Form(
          key: _formKey,
          child: Column(
            children: _buildFormFields(),
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            _submitForm();
          },
          child: Text('Submit'),
        ),
      ],
    );
  }

  List<Widget> _buildFormFields() {
    return _userData.keys.map((key) {
      if (key == 'Region' || key == 'Reporting Manager Email ID') {
        return TextFormField(
          decoration: InputDecoration(
            labelText: key,
          ),
          onSaved: (value) {
            _userData[key] = value ?? '';
          },
        );
      }
      return TextFormField(
        decoration: InputDecoration(
          labelText: key,
        ),
        validator: (value) {
          if (key == 'Email ID' && !(value ?? '').endsWith('@henkel.com')) {
            return 'Please enter a valid email ID ending with @henkel.com';
          }
          if (key != 'Region' && key != 'Reporting Manager Email ID') {
            if (value == null || value.isEmpty) {
              return 'Please enter the $key';
            }
          }
          return null;
        },
        onSaved: (value) {
          _userData[key] = value ?? '';
        },
      );
    }).toList();
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

