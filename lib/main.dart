import 'package:flutter/material.dart';
import 'package:login_signup/screens/HomeScreen.dart';
import 'package:login_signup/screens/SplashScreen.dart';
import 'package:login_signup/screens/image_upload_screen.dart';
import 'package:login_signup/screens/welcome_screen.dart';
import 'package:login_signup/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './SecureStorage/secureStorage.dart'; // Import the SecureStorage class
import 'package:login_signup/screens/Firstsplash.dart'; // Import your Firstsplash screen
import 'package:login_signup/screens/SplashScreen.dart'; // Import your Secondspl

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase specifically for web
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAgS2_N-fUFTjscr0hdaOhRx_XJkp7QMNc",
      authDomain: "facepoints-2.firebaseapp.com",
      projectId: "facepoints-2",
      storageBucket: "facepoints-2.appspot.com",
      messagingSenderId: "780047286312",
      appId: "1:780047286312:web:51d8318c6a524edd08751d",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: lightMode,
      home: const AuthCheck(), // Show AuthCheck screen here
    );
  }
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool _isLoading = true; // To control the loading state

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
    //_showSplashScreen(); // Show splash screen first
  }

  Future<void> _showSplashScreen() async {
    // Show splash screen for 5 seconds
    await Future.delayed(const Duration(seconds: 5));
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    final SecureStorage _secureStorage = SecureStorage();
    String? userEmail = await _secureStorage.readSecureData('userEmail');

    if (userEmail != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .get();
      if (!userDoc.exists) {
        // User exists
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // User does not exist
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      }
    } else {
      // No email found, navigate
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const Firstsplash(
                  slogan: '',
                )),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Firstsplash(
            slogan:
                'Your Face, Your Key') // Use Firstsplash instead of SplashScreen
        : Container(); // Return empty container when loading is complete
  }
}
