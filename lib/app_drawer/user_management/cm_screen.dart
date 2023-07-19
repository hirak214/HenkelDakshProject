import 'package:flutter/material.dart';

class CustomerManagerScreen extends StatefulWidget {
  @override
  _CustomerManagerScreenState createState() => _CustomerManagerScreenState();
}

class _CustomerManagerScreenState extends State<CustomerManagerScreen> {
  List<Map<String, String>> customers = [
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
    // Add more customer data as needed
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
              'Customer Manager User List',
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
      DataColumn(label: Text('Email ID')),
      DataColumn(label: Text('Status')),
      DataColumn(label: Text('Action')),
    ];
  }

  List<DataRow> _buildTableRows() {
    return customers.map((customer) {
      return DataRow(
        cells: [
          DataCell(Text(customer['First Name'] ?? '')),
          DataCell(Text(customer['Last Name'] ?? '')),
          DataCell(Text(customer['Email ID'] ?? '')),
          DataCell(Text(customer['Status'] ?? '')),
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
}

class CustomerForm extends StatefulWidget {
  @override
  _CustomerFormState createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _customerData = {
    'First Name': '',
    'Last Name': '',
    'Email ID': '',
    'Customer ID': '',
    'Customer Address': '',
    'Department': '',
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
    return _customerData.keys.map((key) {
      return TextFormField(
        decoration: InputDecoration(
          labelText: key,
        ),
        validator: (value) {
          if (key == 'Email ID' && !(value ?? '').endsWith('@henkel.com')) {
            return 'Please enter a valid email ID ending with @henkel.com';
          }
          if (value == null || value.isEmpty) {
            return 'Please enter the $key';
          }
          return null;
        },
        onSaved: (value) {
          _customerData[key] = value ?? '';
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

