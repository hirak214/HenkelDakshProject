import 'dart:js';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:henkel_daksh_project/app_drawer/upload_screen.dart';
import 'package:henkel_daksh_project/app_drawer/user_management/tsc_screen.dart';
import 'package:henkel_daksh_project/app_drawer/user_management/cm_screen.dart';
import 'package:henkel_daksh_project/app_drawer/user_management/ca_screen.dart';
import 'package:henkel_daksh_project/login_page.dart';
import 'package:henkel_daksh_project/profile_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String? _selectedOption;
  String? _filePath;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget view = Container();

    if (_selectedOption == 'TCS') {
      view = TcsScreen();
    } else if (_selectedOption == 'Customer Manager') {
      view = CustomerManagerScreen();
    } else if (_selectedOption == 'Applicator') {
      view = CustomerApplicatorScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Daksh Admin Panel'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onSelected: (String result) {
              if (result == 'Logout') {
                // Handle logout here
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              } else if (result == 'View Profile') {
                // Handle view profile here
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'View Profile',
                child: Row(
                  children: [
                    Icon(
                      Icons.account_circle,
                      color: Colors.black,
                    ),
                    SizedBox(width: 8),
                    Text('View Profile'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'Logout',
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.black,
                    ),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'App Drawer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.pageview),
              title: DropdownButton<String>(
                value: _selectedOption,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedOption = newValue;
                  });
                },
                hint: const Text('User Management'),
                items: const <String>[
                  'TCS',
                  'Customer Manager',
                  'Applicator',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            // ListTile(
            //   leading: const Icon(Icons.pageview),
            //   title: const Text('User List'),
            //   onTap: () {
            //     // Handle User List tap
            //   },
            // ),
            ListTile(
              leading: const Icon(Icons.pageview),
              title: const Text('Upload Study Material'),
              onTap: () {
                // Handle Upload Study Material tap
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: view,
    );
  }
}
