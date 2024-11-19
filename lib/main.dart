import 'package:flutter/material.dart';
import 'package:login_signup/screens/image_upload_screen.dart';
import 'package:login_signup/screens/welcome_screen.dart';
import 'package:login_signup/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './SecureStorage/secureStorage.dart'; // Import the SecureStorage class
import 'package:login_signup/screens/SplashScreen.dart';

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
      home: const AuthCheck(),
    );
  }
}

// class AuthCheck extends StatefulWidget {
//   const AuthCheck({super.key});

//   @override
//   _AuthCheckState createState() => _AuthCheckState();
// }

// class _AuthCheckState extends State<AuthCheck> {
//   bool _isLoading = true; // To control the loading state

//   @override
//   void initState() {
//     super.initState();
//     _checkUserStatus();
//   }

//   Future<void> _checkUserStatus() async {
//     print('checking user');
//     final SecureStorage _secureStorage = SecureStorage();

//     // Read email from shared preferences
//     String? userEmail = await _secureStorage.readSecureData('userEmail');
//     print('user mail $userEmail');
//     if (userEmail != null) {
//       // Check if the user exists in the Firestore database
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userEmail)
//           .get();
//       print('user exists ${userDoc.exists}');
//       if (!userDoc.exists) {
//         // User exists, navigate to ImageUploadScreen
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const ImageUploadScreen()),
//         );
//       } else {
//         // User does not exist, navigate to WelcomeScreen
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const WelcomeScreen()),
//         );
//       }
//     } else {
//       // No email found, navigate to WelcomeScreen
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const WelcomeScreen()),
//       );
//     }

//     // Set loading to false after the checks
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _isLoading
//           ? Center(
//               child: CircularProgressIndicator(
//                 valueColor:
//                     AlwaysStoppedAnimation<Color>(lightColorScheme.primary),
//               ),
//             )
//           : Container(), // You can also add a fallback UI if needed
//     );
//   }
// }

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _showSplashScreen(); // Show splash screen first
  }

  Future<void> _showSplashScreen() async {
    // Show splash screen for 10 seconds
    await Future.delayed(const Duration(seconds: 10));
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ImageUploadScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const SplashScreen(slogan: 'Your Face, Your Key') // Pass your slogan
        : Container();
  }
}
