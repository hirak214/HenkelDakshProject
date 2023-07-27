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
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'TCS User List',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
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
          DataCell(
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showEditUserDialog(user);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.cancel_rounded),
                  onPressed: () {
                    // TODO: Implement delete action
                  },
                ),
              ],
            ),
          ),

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

  void _showEditUserDialog(Map<String, dynamic> userData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: UserForm(userData: userData),
          ),
        );
      },
    );
  }
}

class UserForm extends StatefulWidget {
  final Map<String, dynamic>? userData;

  UserForm({this.userData});

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
    // Remove the UID field from the form
    _userData.remove('uid');

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
            children: [
              TextFormField(
                initialValue: _userData['first_name'] ?? '',
                decoration: InputDecoration(
                  labelText: 'First Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the First Name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _userData['first_name'] = value ?? '';
                },
              ),
              TextFormField(
                initialValue: _userData['last_name'] ?? '',
                decoration: InputDecoration(
                  labelText: 'Last Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Last Name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _userData['last_name'] = value ?? '';
                },
              ),
              TextFormField(
                initialValue: _userData['region'] ?? '',
                decoration: InputDecoration(
                  labelText: 'Region',
                ),
                onSaved: (value) {
                  _userData['region'] = value ?? '';
                },
              ),
              TextFormField(
                initialValue: _userData['reporting_manager_email_id'] ?? '',
                decoration: InputDecoration(
                  labelText: 'Reporting Manager Email ID',
                ),
                onSaved: (value) {
                  _userData['reporting_manager_email_id'] = value ?? '';
                },
              ),
            ],
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
          initialValue: _userData[key] ?? '',
          decoration: InputDecoration(
            labelText: key,
          ),
          onSaved: (value) {
            _userData[key] = value ?? '';
          },
        );
      }
      return TextFormField(
        initialValue: _userData[key] ?? '',
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

