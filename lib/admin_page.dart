import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:henkel_daksh_project/app_drawer/upload_screen.dart';
import 'package:henkel_daksh_project/app_drawer/user_managment/tsc_screen.dart';

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
      // Add code for Customer Manager screen
    } else if (_selectedOption == 'Applicatior') {
      // Add code for Applicatior screen
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daksh Admin Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Handle settings button tap
            },
          ),
          const CircleAvatar(
            backgroundImage: AssetImage('assets/profile_picture.png'),
            radius: 20,
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
                  'Applicatior',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.pageview),
              title: const Text('User List'),
              onTap: () {
                // Handle User List tap
              },
            ),
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