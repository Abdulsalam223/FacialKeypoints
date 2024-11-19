import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import './user_details_screen.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key});

  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image; // Variable to hold the selected image
  CameraController? _cameraController; // Camera controller
  List<CameraDescription>? cameras; // List of available cameras
  Uint8List? _imageData; // Variable to hold image data

  @override
  void initState() {
    super.initState();
    // Initialize the camera
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      if (cameras!.isNotEmpty) {
        _initializeCamera(cameras![0]);
      }
    });
  }

  Future<void> _initializeCamera(CameraDescription cameraDescription) async {
    _cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
    );
    await _cameraController!.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        final XFile file = await _cameraController!.takePicture();
        final Uint8List imageData = await file.readAsBytes(); // Read image data
        setState(() {
          _image = file;
          _imageData = imageData; // Set the image data
          // Reset camera controller for next capture
          _cameraController?.dispose(); // Stop camera preview
          _cameraController = null; // Release camera controller
        });
      } catch (e) {
        // Handle error
        print('Error taking picture: $e');
      }
    }
  }

  Future<void> _showPicker(BuildContext context) async {
    // Show the image picker options to select from the gallery
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final pickedFile =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    final Uint8List imageData = await pickedFile.readAsBytes();
                    setState(() {
                      _image = pickedFile;
                      _imageData = imageData; // Set the image data
                      // Reset camera controller for next capture
                      _cameraController?.dispose(); // Stop camera preview
                      _cameraController = null; // Release camera controller
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _resetCamera() {
    setState(() {
      _imageData = null; // Reset image data to show camera preview
      _image = null; // Reset selected image
      // Re-initialize camera
      if (cameras != null && cameras!.isNotEmpty) {
        _initializeCamera(cameras![0]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Upload'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Navigate to UserDetailsScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserDetailsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        //setting background color to the image upload screen only
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color.fromARGB(255, 124, 191, 247), Colors.grey],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display the camera preview if initialized, else show a placeholder
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                  maxHeight:
                      MediaQuery.of(context).size.height * 0.6, // Limit height
                ),
                child: _imageData != null
                    ? Image.memory(_imageData!) // Show the selected image
                    : (_cameraController != null &&
                            _cameraController!.value.isInitialized)
                        ? AspectRatio(
                            aspectRatio: _cameraController!.value.aspectRatio,
                            child: CameraPreview(_cameraController!),
                          )
                        : const Center(child: Text('Loading camera...')),
              ),
              const SizedBox(height: 20),
              // Responsive buttons using Flex
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //  Expanded(
                  //     child: ElevatedButton(
                  //       onPressed: () {
                  //         _showPicker(context); // Show the image picker for gallery
                  //       },
                  //       child: const Text('Select from Gallery'),
                  //     ),
                  //   ),

                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _showPicker(
                            context); // Show the image picker for gallery
                      },
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.photo_library, size: 30), // Gallery icon
                          SizedBox(height: 4), // Space between icon and text
                          Text('Gallery',
                              style: TextStyle(fontSize: 14)), // Text label
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10), // Spacing
                  // Expanded(
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       _takePicture(); // Take a picture with the camera
                  //     },
                  //     child: const Text('Take Picture'),
                  //   ),
                  // ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _takePicture(); // Take a picture with the camera
                      },
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 30), // Camera icon
                          SizedBox(height: 4), // Space between icon and text
                          Text('Capture',
                              style: TextStyle(fontSize: 14)), // Text label
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20), // Spacing

              // ElevatedButton(
              //   onPressed: _resetCamera, // Reset camera and preview
              //   child: const Text('Retake Picture'),
              // ),

              GestureDetector(
                onTap: () {
                  _resetCamera(); // Reset camera and preview
                },
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.refresh, size: 30),
                    // Camera icon for retake image
                    SizedBox(height: 4), // Space between icon and text
                    Text('Retake Image',
                        style: TextStyle(fontSize: 14)), // Text label
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
