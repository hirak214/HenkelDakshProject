import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerManagerScreen extends StatefulWidget {
  @override
  _CustomerManagerScreenState createState() => _CustomerManagerScreenState();
}

class _CustomerManagerScreenState extends State<CustomerManagerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Manager'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('cm_users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Map<String, dynamic>> customers = snapshot.data!.docs.map((doc) {
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
                      'Customer Manager User List',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: _buildTableColumns(),
                    rows: _buildTableRows(customers),
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
          _showAddCustomerDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  List<DataColumn> _buildTableColumns() {
    return [
      DataColumn(label: Text('First Name')),
      DataColumn(label: Text('Last Name')),
      DataColumn(label: Text('Department')),
      DataColumn(label: Text('Status')),
      DataColumn(label: Text('Action')),
    ];
  }

  List<DataRow> _buildTableRows(List<Map<String, dynamic>> customers) {
    return customers.map((customer) {
      return DataRow(
        cells: [
          DataCell(Text(customer['first_name'] ?? '')),
          DataCell(Text(customer['last_name'] ?? '')),
          DataCell(Text(customer['department'] ?? '')),
          DataCell(Text(customer['status'] ?? '')),
          DataCell(
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showEditUserDialog(
                        customer['uid'], customer); // Pass the uid and userData

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

  void _showAddCustomerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomerForm(),
          ),
        );
      },
    );
  }


  void _showEditUserDialog(String? uid, Map<String, dynamic> customerData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomerForm(uid: uid, customerData: customerData), // Pass the uid and userData
          ),
        );
      },
    );
  }
}
class CustomerForm extends StatefulWidget {
  final String? uid; // Add the uid parameter
  final Map<String, dynamic>? customerData;

  CustomerForm({this.uid, this.customerData});

  @override
  _CustomerFormState createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _customerData = {};

  // Map<String, dynamic> _customerData = {
  //   'First Name': '',
  //   'Last Name': '',
  //   'Email ID': '',
  //   'Customer ID': '',
  //   'Customer Address': '',
  //   'Department': '',
  // };

  @override
  void initState() {
    super.initState();
    // Initialise _customerData with the provided user data or create an empty map
    _customerData = widget.customerData ?? {};
  }

  @override
  Widget build(BuildContext context) {
    // Remove the UID field from the form
    _customerData.remove('uid');

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
            children:[
              TextFormField(
                initialValue: _customerData['first_name'] ?? '',
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
                  _customerData['first_name'] = value ?? '';
                },
              ),
              TextFormField(
                initialValue: _customerData['last_name'] ?? '',
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
                  _customerData['last_name'] = value ?? '';
                },
              ),
              if (!isEditMode) // show the email ID field only in "create" mode
                TextFormField(
                  initialValue: _customerData['email_id'] ?? '',
                  decoration: InputDecoration(
                    labelText: 'Email-Id',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid Email-Id';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _customerData['email_id'] = value ?? '';
                  },
                ),
              TextFormField(
                initialValue: _customerData['address'] ?? '',
                decoration: InputDecoration(
                  labelText: 'Address',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Address';
                  }
                  return null;
                },
                onSaved: (value) {
                  _customerData['address'] = value ?? '';
                },
              ),
              TextFormField(
                initialValue: _customerData['department'] ?? '',
                decoration: InputDecoration(
                  labelText: 'Department',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Department';
                  }
                  return null;
                },
                onSaved: (value) {
                  _customerData['department'] = value ?? '';
                },
              ),
            ]
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

      // Check if the user data contains a valid 'uid' (indicationg an existing customer)
      String uid = widget.uid ?? '';
      _customerData['uid'] = uid; // Make sure the uid is set in the _customerData map

      if (uid.isNotEmpty) {
        // Update the user details in Firestore using the UID as the document ID
        await FirebaseFirestore.instance.collection('cm_users').doc(uid).update(_customerData);

        // Reset the form and show a success message
        _formKey.currentState?.reset();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User details updated succesfully')),);
        Navigator.of(context).pop();
      } else {
        // If the 'uid' field is empty, it means we are adding a new customer.
        // We should remove the 'uid' field from the customer data before adding it to FireStore.
        _customerData.remove('uid');

        // Create a new user in Firebase Authentication with the default password '121212'
        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
            email: _customerData['email_id'] ?? '', // Use the email_id as the email
            password: '121212',
          );

          // Use the generated UID to store the rest of the data in the 'cm_users' collection
          uid = userCredential.user?.uid ?? '';
          _customerData.remove('email_id');

          // trying to set stauts
          // _userData['status'] = 'Active' ?? '';

          // Add the user data to Firestore
          await FirebaseFirestore.instance.collection('cm_users').doc(uid).set(
              _customerData);

          // Reset the form and show a success message
          _formKey.currentState?.reset();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('New customer created successfully')),
          );
          Navigator.of(context)
              .pop(); // Close the dialog after saving the changes
        } on FirebaseAuthException catch (e) {
          // Handle errors related to Firebase Authentication
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error creating a new customer: ${e.message}')),
          );
        } catch (e) {
          // Handle other errors
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error creating a new customer: $e')),
          );
        }
      }
    }
  }
}

