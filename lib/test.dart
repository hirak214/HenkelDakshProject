import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  String _selectedGender = 'tc';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daksh'),
        // Remove the navigation menu button from the app bar
      ),
      body: Row(
        children: [
          // Drawer
          Drawer(
            child: Container(
              color: Colors.blue,
              child: ListView(
                padding: EdgeInsets.only(top: 25.0),
                children: [
                  ListTile(
                    leading: Icon(Icons.folder),
                    title: Text('Study Material'),
                    onTap: () {
                      // Handle Study Material tile tap
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: DropdownButton<String>(
                      value: _selectedGender,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedGender = newValue!;
                        });
                      },
                      items: <String>['tc', 'man', 'fem'].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Main Content
          // Expanded(
          //   child: Center(
          //     child: Text('Test Page Content'),
          //   ),
          // ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TestPage(),
  ));
}
