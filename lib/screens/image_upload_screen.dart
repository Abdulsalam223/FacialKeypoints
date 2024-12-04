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
  XFile? _image;
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  Uint8List? _imageData;

  @override
  void initState() {
    super.initState();
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
        final Uint8List imageData = await file.readAsBytes();
        setState(() {
          _image = file;
          _imageData = imageData;
          _cameraController?.dispose();
          _cameraController = null;
        });
      } catch (e) {
        print('Error taking picture: $e');
      }
    }
  }

  Future<void> _showPicker(BuildContext context) async {
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
                      _imageData = imageData;
                      _cameraController?.dispose();
                      _cameraController = null;
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
      _imageData = null;
      _image = null;
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 124, 191, 247), Colors.grey],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Camera preview container with fixed height
            Container(
              height: MediaQuery.of(context).size.height * 0.6, // Fixed height
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  _imageData != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.memory(_imageData!),
                        )
                      : (_cameraController != null &&
                              _cameraController!.value.isInitialized)
                          ? AspectRatio(
                              aspectRatio: 5 / 7, // Set the aspect ratio to 4:5
                              child: CameraPreview(_cameraController!),
                            )

                          // (_cameraController != null &&
                          //         _cameraController!.value.isInitialized)
                          //     ? AspectRatio(
                          //         aspectRatio: _cameraController!.value.aspectRatio,
                          //         child: CameraPreview(_cameraController!),
                          //       )
                          : const Center(
                              child:
                                  CircularProgressIndicator()), // Show progress indicator during camera load
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () {
                    _showPicker(context);
                  },
                ),
                _buildButton(
                  icon: Icons.camera_alt,
                  label: 'Capture',
                  onTap: () {
                    _takePicture();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                _resetCamera();
              },
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.refresh, size: 30),
                  SizedBox(height: 4),
                  Text('Retake Image', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build buttons
  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
