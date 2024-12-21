import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:html' as html; // For Web support
import 'dart:typed_data'; // For handling image as bytes
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:login_signup/theme/theme.dart';
import 'Retrieve_Screen.dart'; // Import the RetrieveUserDataScreen
import 'package:login_signup/widgets/custom_scaffold.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();

  Uint8List? _imageBytes; // For Web support
  bool _isImageUploaded = false;

  // Function to handle image selection for Web
  Future<void> _pickImage() async {
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement();
    uploadInput.accept = 'image/*'; // Accept image files only
    uploadInput.click();

    // When a file is selected
    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files!.isEmpty) return;

      final reader = html.FileReader();
      reader.readAsArrayBuffer(files[0]!);

      reader.onLoadEnd.listen((e) async {
        setState(() {
          _imageBytes = reader.result as Uint8List?;
          _isImageUploaded = false;
        });
        print("Image picked successfully!");

        // Optionally, upload to Firebase Storage after selecting the image
        await _uploadImageToFirebase(files[0]!);
      });
    });
  }

  // Function to upload the image to Firebase Storage
  Future<void> _uploadImageToFirebase(html.File file) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef =
          FirebaseStorage.instance.ref().child('profile_images/$fileName');
      final uploadTask = storageRef.putBlob(file);

      // Listen to the upload progress
      uploadTask.snapshotEvents.listen((taskSnapshot) {
        if (taskSnapshot.state == TaskState.running) {
          print(
              'Uploading: ${taskSnapshot.bytesTransferred}/${taskSnapshot.totalBytes}');
        }
      });

      final taskSnapshot = await uploadTask;
      final imageUrl = await taskSnapshot.ref.getDownloadURL();

      setState(() {
        _isImageUploaded = true;
      });

      print("Image uploaded successfully! URL: $imageUrl");
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  // Function to save user data to Firestore
  Future<void> _registerUser() async {
    String name = nameController.text;
    String department = departmentController.text;
    String contactNumber = contactNumberController.text;

    if (name.isEmpty || department.isEmpty || contactNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields!')),
      );
      return;
    }

    String imageUrl = '';
    if (_isImageUploaded) {
      // If image is uploaded successfully, save its URL to Firestore
      imageUrl = 'uploaded_image_url_here'; // Replace with the actual URL
    }

    try {
      await FirebaseFirestore.instance.collection('users').add({
        'name': name,
        'department': department,
        'contactNumber': contactNumber,
        'imageUrl': imageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User registered successfully!')),
      );

      // Clear the text fields and reset the image
      nameController.clear();
      departmentController.clear();
      contactNumberController.clear();
      setState(() {
        _imageBytes = null;
        _isImageUploaded = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error registering user: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(height: 10),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Update text to "Register Person"
                    Text(
                      'Register Person',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w900,
                        color: lightColorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 24),
                    // Image selection display
                    Center(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Column(
                          children: [
                            // If the image is picked, display it
                            if (_imageBytes != null)
                              Image.memory(
                                _imageBytes!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            else
                              Text(
                                'Choose Image',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.blue),
                              ),
                            SizedBox(height: 16),
                            // Show image upload success message
                            if (_isImageUploaded)
                              Text(
                                'Image Uploaded',
                                style: TextStyle(
                                    color: Colors.green, fontSize: 16),
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: departmentController,
                      decoration: InputDecoration(
                        labelText: 'Department',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: contactNumberController,
                      decoration: InputDecoration(
                        labelText: 'Contact Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        _registerUser(); // Call the register function
                      },
                      child: Text('Register'),
                    ),
                    SizedBox(height: 24),
                    // Button to navigate to RetrieveUserDataScreen
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  RetrieveUserDataScreen()), // Navigate to the screen that retrieves user data
                        );
                      },
                      child: Text('Retrieve User Data'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Ensure Firebase is initialized
  runApp(MaterialApp(
    home: RegisterScreen(),
  ));
}
