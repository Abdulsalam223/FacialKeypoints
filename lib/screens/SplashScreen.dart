import 'package:flutter/material.dart';
import 'package:login_signup/theme/theme.dart'; // Adjust if needed
import 'package:login_signup/screens/welcome_screen.dart';

class SplashScreen extends StatelessWidget {
  final String slogan;

  const SplashScreen({Key? key, required this.slogan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/bg1.png'), // Path to your background image
            fit: BoxFit.cover, // This will cover the entire screen
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App name text
              Text(
                '𝕱 𝖆 𝖈 𝖊 𝕲 𝖚 𝖆 𝖗 𝖉', // App name
                style: TextStyle(
                  fontSize: 45, // Adjust the size
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(
                      255, 255, 255, 255), // Greenish color
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 5,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Slogan text
              Text(
                slogan,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.9),
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 5,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              // "Get Started" button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WelcomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors
                      .white, // Updated from 'primary' to 'backgroundColor'
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shadowColor: Colors.black.withOpacity(0.2),
                  elevation: 8,
                ),
                child: const Text(
                  "Get Started",
                  style: TextStyle(
                    color: Color(0xFF0048BA), // Matching dark blue for text
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
