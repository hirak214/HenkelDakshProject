import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:henkel_daksh_project/admin_page.dart';
import 'dart:typed_data';
import 'package:mime/mime.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Uint8List? _imageData;


  void _selectImage() async {
    final pickedFile = await FilePicker.platform.pickFiles(type: FileType.image);
    if (pickedFile != null) {
      setState(() {
        _imageData = pickedFile.files.first.bytes;
      });
      await _uploadImageToFirebase();
    }
  }


  // Function to check if the file has an allowed extension (png, jpg, jpeg)
  bool _isAllowedImage(Uint8List data) {
    final mimeType = lookupMimeType('file.jpg', headerBytes: data);
    if (mimeType != null &&
        (mimeType.startsWith('image/jpeg') ||
            mimeType.startsWith('image/png'))) {
      return true;
    }
    return false;
  }

  // Display the image in the CircleAvatar if it's allowed
  Widget _buildProfileImage() {
    if (_imageData != null && _isAllowedImage(_imageData!)) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: MemoryImage(_imageData!),
      );
    } else {
      return StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('admin_users').doc(_uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile_picture_placeholder.png'),
            );
          }

          Map<String, dynamic>? userData = snapshot.data?.data() as Map<String, dynamic>?;

          if (userData == null || !userData.containsKey('profile_image_url')) {
            return CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile_picture_placeholder.png'),
            );
          }

          String? downloadURL = userData['profile_image_url'];
          if (downloadURL != null && downloadURL.isNotEmpty) {
            return CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(downloadURL),
            );
          } else {
            return CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile_picture_placeholder.png'),
            );
          }
        },
      );
    }
  }



  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  String? _uid;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _uid = user.uid;
      });
      await _getUserData();
    }
  }

  Future<void> _getUserData() async {
    if (_uid != null) {
      final userData = await _firestore.collection('admin_users').doc(_uid).get();
      if (userData.exists) {
        setState(() {
          _firstNameController.text = userData.get('first_name') ?? '';
          _lastNameController.text = userData.get('last_name') ?? '';
          _regionController.text = userData.get('region') ?? '';
          _phoneNumberController.text = userData.get('phone_number') ?? '';
        });
      }
    }
  }

  Future<void> _uploadImageToFirebase() async {
    if (_imageData != null) {
      try {
        String uid = _auth.currentUser?.uid ?? '';
        String fileName = 'profile_images/$uid.jpg'; // You can change the file name or path as per your requirement

        // Create metadata for the image file to set the content type
        firebase_storage.SettableMetadata metadata = firebase_storage.SettableMetadata(
          contentType: 'image/jpeg', // Change 'image/jpeg' to the appropriate MIME type of your image
        );

        // Upload the image to Firebase Storage with the specified metadata
        await firebase_storage.FirebaseStorage.instance
            .ref(fileName)
            .putData(_imageData!, metadata);

        // Get the download URL of the uploaded image
        String downloadURL = await firebase_storage.FirebaseStorage.instance
            .ref(fileName)
            .getDownloadURL();

        // Save the download URL in Firestore
        if (_uid != null) {
          final userData = {
            'profile_image_url': downloadURL,
            'first_name': _firstNameController.text.trim(),
            'last_name': _lastNameController.text.trim(),
            'region': _regionController.text.trim(),
            'phone_number': _phoneNumberController.text.trim(),
          };
          await _firestore.collection('admin_users').doc(_uid).set(userData);
          // Show a SnackBar to notify the user that the profile picture is uploaded
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile picture uploaded successfully')),
          );
        }
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }


  Future<void> _updateUserData() async {
    if (_uid != null) {
      final userData = {
        'first_name': _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'region': _regionController.text.trim(),
        'phone_number': _phoneNumberController.text.trim(),
      };

      await _firestore.collection('admin_users').doc(_uid).set(userData);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Clear image cache before running the app
    PaintingBinding.instance?.imageCache?.clear();

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AdminPage()),
            );
          },
        ),
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                _buildProfileImage(),
                Positioned(
                  child: IconButton(
                    onPressed: _selectImage,
                    icon: Icon(Icons.add_a_photo),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _firstNameController,
                      decoration: InputDecoration(labelText: 'First Name'),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _lastNameController,
                      decoration: InputDecoration(labelText: 'Last Name'),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _regionController,
                decoration: InputDecoration(labelText: 'Region'),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
            ),
            SizedBox(height: 16, width: 30),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                await _updateUserData();
                setState(() {
                  _isLoading = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Profile updated successfully')),
                );
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
