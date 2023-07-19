import 'package:flutter/material.dart';

class TscFormScreen extends StatefulWidget {
  @override
  _TscFormScreenState createState() => _TscFormScreenState();
}

class _TscFormScreenState extends State<TscFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _region;
  String? _reportingManagerEmail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TCS Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
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
                  labelText: 'Region (Optional)',
                ),
                onSaved: (value) {
                  _region = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Reporting Manager Email (Optional)',
                ),
                onSaved: (value) {
                  _reportingManagerEmail = value;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _submitForm();
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // TODO: Implement code to upload form data to Firebase

      // Reset the form
      _formKey.currentState?.reset();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Form submitted successfully')),
      );
    }
  }
}
