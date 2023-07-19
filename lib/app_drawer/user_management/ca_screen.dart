import 'package:flutter/material.dart';

class CustomerApplicatorScreen extends StatefulWidget {
  @override
  _CustomerApplicatorScreenState createState() =>
      _CustomerApplicatorScreenState();
}

class _CustomerApplicatorScreenState extends State<CustomerApplicatorScreen> {
  List<Map<String, String>> applicators = [
    {
      'First Name': 'Hirak',
      'Last Name': 'Desai',
      'Email ID': 'hirak.d@henkel.com',
      'Customer Name': 'ABC Company',
      'Status': 'Active',
    },
    {
      'First Name': 'Yashvi',
      'Last Name': 'Agrawal',
      'Email ID': 'yashvi.a@henkel.com',
      'Customer Name': 'XYZ Corporation',
      'Status': 'Inactive',
    },
    // Add more applicator data as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Applicator'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Customer Applicator User List',
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
          _showAddApplicatorDialog();
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
      DataColumn(label: Text('Customer Name')),
      DataColumn(label: Text('Status')),
      DataColumn(label: Text('Action')),
    ];
  }

  List<DataRow> _buildTableRows() {
    return applicators.map((applicator) {
      return DataRow(
        cells: [
          DataCell(Text(applicator['First Name'] ?? '')),
          DataCell(Text(applicator['Last Name'] ?? '')),
          DataCell(Text(applicator['Email ID'] ?? '')),
          DataCell(Text(applicator['Customer Name'] ?? '')),
          DataCell(Text(applicator['Status'] ?? '')),
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

  void _showAddApplicatorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ApplicatorForm(),
          ),
        );
      },
    );
  }
}

class ApplicatorForm extends StatefulWidget {
  @override
  _ApplicatorFormState createState() => _ApplicatorFormState();
}

class _ApplicatorFormState extends State<ApplicatorForm> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _applicatorData = {
    'First Name': '',
    'Last Name': '',
    'Email ID': '',
    'Customer Name': '',
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
    return _applicatorData.keys.map((key) {
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
          _applicatorData[key] = value ?? '';
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

