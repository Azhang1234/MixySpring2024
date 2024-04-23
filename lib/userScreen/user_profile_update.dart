import 'package:flutter/material.dart';
// Import path provider and dart:io for file operations (if simulating file storage)
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class ProfileUpdatePage extends StatefulWidget {
  const ProfileUpdatePage({super.key});

  @override
  _ProfileUpdatePageState createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  // Variables to hold the input data
  String _bio = '';
  // Assuming a function to read the current bio from a file for simulation purposes
  // In a real app, this might come from a database or shared preferences

  @override
  void initState() {
    super.initState();
    readUserData().then((value) => {
          setState(() {
            _bio = json.decode(value)['bio'];
          })
        });
  }

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/mockUser.json');
  }

  Future<File> writeUserData(String bio) async {
    final file = await _localFile;
    // Simulate a user object update. In a real scenario, this would likely involve more complex data structures and error handling.
    Map<String, dynamic> user = {'bio': bio};
    return file.writeAsString(json.encode(user));
  }

  Future<String> readUserData() async {
    try {
      final file = await _localFile;
      // Simulating a read from a local file
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      return 'Error reading file: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: TextEditingController(
                  text: _bio), // Initialize the text field with current bio
              decoration: const InputDecoration(labelText: 'Bio'),
              onChanged: (value) {
                _bio = value;
              },
            ),
            const SizedBox(height: 20), // Add some space
            ElevatedButton(
              onPressed: () async {
                // Assuming we're writing the updated bio back to the mockUser.json file for simulation
                await writeUserData(_bio);
                Navigator.of(context).pop(); // Go back to the previous screen
              },
              child: const Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
