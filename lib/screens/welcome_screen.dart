import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:login_signup/screens/signin_screen.dart';
import 'package:login_signup/screens/signup_screen.dart';
import 'package:login_signup/theme/theme.dart';
import 'package:login_signup/widgets/custom_scaffold.dart';
import 'package:login_signup/widgets/welcome_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String _connectionStatus =
      'Checking connection...'; // Connection status message

  @override
  void initState() {
    super.initState();
    checkConnection(); // Call the function to check connection
  }

  Future<void> checkConnection() async {
    try {
      // Attempt to fetch data from a Firestore collection (e.g., "users")
      await FirebaseFirestore.instance.collection('users').get();
      setState(() {
        _connectionStatus = 'Connected to the database!';
      });
    } catch (e) {
      setState(() {
        _connectionStatus =
            'Not connected to the database: $e'; // Display the error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          // Add image above the text
          Flexible(
            flex: 0, // Adjust flex value to allocate space for the image
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/face.png', // Replace with your image path
                    height: 300, // Adjust height
                    width: 300, // Adjust width
                    fit: BoxFit.cover, // Adjust fit
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 20, // Adjust vertical padding for spacing
                horizontal: 40.0,
              ),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Welcome Back!\n',
                        style: TextStyle(
                          fontSize: 45.0, // Large font size for heading
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 5, 0, 0)
                              .withOpacity(0.9),
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 5,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                      TextSpan(
                        text: '\nPlease provide your credentials to proceed.',
                        style: TextStyle(
                          fontSize: 16, // Smaller font size for body text
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 5, 0, 0)
                              .withOpacity(0.9),
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 5,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Display the connection status
          const SizedBox(height: 250), // Add spacing between elements
          Flexible(
            flex: 1,
            child: Center(
              child: Text(
                _connectionStatus,
                style: const TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 124, 231, 140)),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  const Expanded(
                    child: WelcomeButton(
                      buttonText: 'Sign in',
                      onTap: SignInScreen(),
                      color: Colors.transparent,
                      textColor: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: WelcomeButton(
                      buttonText: 'Sign up',
                      onTap: const SignUpScreen(),
                      color: Colors.white,
                      textColor: lightColorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
