import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TcsScreen extends StatefulWidget {
  @override
  _TcsScreenState createState() => _TcsScreenState();
}

class _TcsScreenState extends State<TcsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TCS'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tcs_users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Map<String, dynamic>> users = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
            return Column(
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
                    rows: _buildTableRows(users),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
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
      DataColumn(label: Text('Email-Id')),
      DataColumn(label: Text('Status')),
      DataColumn(label: Text('Action')),
    ];
  }

  List<DataRow> _buildTableRows(List<Map<String, dynamic>> users) {
    return users.map((user) {
      return DataRow(
        cells: [
          DataCell(Text(user['first_name'] ?? '')),
          DataCell(Text(user['last_name'] ?? '')),
          DataCell(Text(user['email_id'] ?? '')),
          DataCell(Text(user['Status'] ?? '')),
          DataCell(
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // TODO: Implement edit action
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
}

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _userData = {
    'first_name': '',
    'last_name': '',
    'email_id': '',
    'region': '',
    'reporting_manager_email_id': '',
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
      if (key == 'region' || key == 'reporting_manager_email_id') {
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
          if (key == 'email_id' && !(value ?? '').endsWith('@henkel.com')) {
            return 'Please enter a valid email ID ending with @henkel.com';
          }
          if (key != 'region' && key != 'reporting_manager_email_id') {
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

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      try {
        // Create a new user in Firebase Authentication with the default password
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _userData['email_id'],
          password: '121212',
        );

        // Get the UID of the newly created user
        String uid = userCredential.user?.uid ?? '';

        // Remove the 'email_id' field from the data, as it's not needed in Firestore
        _userData.remove('email_id');

        // Store the user details in Firestore using the UID as the document ID
        await FirebaseFirestore.instance.collection('tcs_users').doc(uid).set(_userData);

        // Reset the form and show a success message
        _formKey.currentState?.reset();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User created successfully')),
        );
      } catch (e) {
        // Show an error message if user creation fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create user. Please try again later.')),
        );
      }
    }
  }
}
