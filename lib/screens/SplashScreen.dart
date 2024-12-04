import 'package:flutter/material.dart'; // Adjust if needed
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
                'assets/images/bg2.png'), // Path to your background image
            fit: BoxFit.cover, // This will cover the entire screen
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Move the app name and slogan upward by reducing the bottom padding
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 10), // Reduced padding to move them upward
                child: Text(
                  '𝕱 𝖆 𝖈 𝖊 𝕲 𝖚 𝖆 𝖗 𝖉', // App name
                  style: TextStyle(
                    fontSize: 45, // Adjust the size
                    fontWeight: FontWeight.bold,
                    color:
                        const Color.fromARGB(255, 21, 21, 21), // Greenish color
                    shadows: [
                      Shadow(
                        color: const Color.fromARGB(255, 241, 240, 240)
                            .withOpacity(0.25),
                        blurRadius: 5,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
              // const SizedBox(height: 10), // Adjusted the height to move everything up
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 10), // Reduced padding to move it upward
                child: Text(
                  slogan,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color:
                        const Color.fromARGB(255, 11, 11, 11).withOpacity(0.9),
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
              ),
              const SizedBox(
                  height:
                      20), // Adjusted the height to move the next text down slightly
              // Adjust the text to move it a little lower
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 200), // Padding added to move this text down
                child: Text(
                  "Begin your FaceGuard experience today! \nExplore the power of AI to protect \nyour identity, enhance security, \nand unlock a seamless experience—\nall with just a glance.",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 5, 0, 0).withOpacity(0.9),
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
              ),
              const SizedBox(
                  height:
                      30), // Adjusted height for spacing between text and button
              // Move the "Get Started" button a little lower
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WelcomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
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
                    color: Color(0xFF0048BA),
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
