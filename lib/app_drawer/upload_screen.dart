import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';



class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  PlatformFile? _selectedFile; // Store the selected file


  void _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // Limit file selection to PDF files
    );

    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }


  void _uploadFile() {
    if (_selectedFile != null) {
      // Implement the file upload logic here
      // This could involve sending the file to a server or storing it in a cloud storage service
      // You can use packages like `http` or Firebase Storage for this task

      // Display a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File uploaded successfully.'),
        ),
      );
    } else {
      // Display an error message if no file is selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a file to upload.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Study Material'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _selectFile,
              child: const Text('Select File'),
            ),
            const SizedBox(height: 16),
            Text(
              _selectedFile != null ? _selectedFile!.name : 'No file selected',
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _uploadFile,
              child: const Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }
}
