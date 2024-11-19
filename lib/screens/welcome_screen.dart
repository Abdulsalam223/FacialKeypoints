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
          Flexible(
            flex: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 40.0,
              ),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                          text: 'Welcome Back!\n',
                          style: TextStyle(
                            fontSize: 45.0,
                            fontWeight: FontWeight.w600,
                          )),
                      TextSpan(
                          text: '\nEnter your personal details',
                          style: TextStyle(
                            fontSize: 20,
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Display the connection status
          Flexible(
            flex: 1,
            child: Center(
              child: Text(
                _connectionStatus,
                style: const TextStyle(fontSize: 18, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          ),
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
