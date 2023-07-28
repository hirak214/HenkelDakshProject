import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:henkel_daksh_project/authenticate.dart';

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
            List<Map<String, dynamic>> users = snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              data['uid'] = doc.id; // Add the 'uid' field to the user data
              return data;
            }).toList();
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
          DataCell(Text(user['status'] ?? '')),
          DataCell(
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showEditUserDialog(user['uid'], user); // Pass the uid and userData
                  },
                ),
                IconButton(
                  icon: Icon(Icons.cancel_rounded),
                  onPressed: () {
                    _showAuthenticateDialog(); // Call the authentication dialog
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

  // Function to show the authentication dialog
  void _showAuthenticateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AuthenticateDialog();
      },
    );
  }

  void _showEditUserDialog(String? uid, Map<String, dynamic> userData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: UserForm(uid: uid, userData: userData), // Pass the uid and userData
          ),
        );
      },
    );
  }
}


class UserForm extends StatefulWidget {
  final String? uid; // Add the uid parameter
  final Map<String, dynamic>? userData;

  UserForm({this.uid, this.userData});

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _userData = {};

  @override
  void initState() {
    super.initState();
    // Initialize _userData with the provided user data or create an empty map
    _userData = widget.userData ?? {};
  }

  @override
  Widget build(BuildContext context) {
    // Remove the UID field from the form
    _userData.remove('uid');

    // Check if we are in "edit" mode (updating an existing user) or "create" mode (adding a new user)
    bool isEditMode = widget.uid != null && widget.uid!.isNotEmpty;

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
              if (!isEditMode) // Show the email ID field only in "create" mode
                TextFormField(
                  initialValue: _userData['email_id'] ?? '',
                  decoration: InputDecoration(
                    labelText: 'Email-Id',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the Email-Id';
                    }
                    if (!value.endsWith('@henkel.com')) {
                      return 'Please enter a valid Email-Id ending with @henkel.com';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userData['email_id'] = value ?? '';
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


  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Check if the user data contains a valid 'uid' (indicating an existing user)
      String uid = widget.uid ?? '';
      _userData['uid'] = uid; // Make sure the uid is set in the _userData map

      if (uid.isNotEmpty) {
        // Update the user details in Firestore using the UID as the document ID
        await FirebaseFirestore.instance.collection('tcs_users')
            .doc(uid)
            .update(_userData);

        //  Reset the form and show a success message
        _formKey.currentState?.reset();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User details updated succesfully')),
        );
        Navigator.of(context)
            .pop(); // Close the dialog after saving the changes
      } else {
        // If the 'uid' field is empty, it means we are adding a new user.
        // We should remove the 'uid' field from the user data before adding it to Firestore.
        _userData.remove('uid');

        // Create a new user in Firebase Authentication with the default password '121212'
        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
            email: _userData['email_id'] ?? '', // Use the email_id as the email
            password: '121212',
          );

          // Use the generated UID to store the rest of the data in the 'tcs_users' collection
          uid = userCredential.user?.uid ?? '';
          _userData.remove('email_id');

          // trying to set stauts
          // _userData['status'] = 'Active' ?? '';

          // Add the user data to Firestore
          await FirebaseFirestore.instance.collection('tcs_users').doc(uid).set(
              _userData);

          // Reset the form and show a success message
          _formKey.currentState?.reset();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('New user created successfully')),
          );
          Navigator.of(context)
              .pop(); // Close the dialog after saving the changes
        } on FirebaseAuthException catch (e) {
          // Handle errors related to Firebase Authentication
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error creating a new user: ${e.message}')),
          );
        } catch (e) {
          // Handle other errors
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error creating a new user: $e')),
          );
        }
      }
    }
  }
}

