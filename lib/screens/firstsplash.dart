import 'package:flutter/material.dart';
import 'SplashScreen.dart';

class Firstsplash extends StatefulWidget {
  final String slogan;

  const Firstsplash({Key? key, required this.slogan}) : super(key: key);

  @override
  _FirstsplashState createState() => _FirstsplashState();
}

class _FirstsplashState extends State<Firstsplash> {
  @override
  void initState() {
    super.initState();
    // Navigate to SplashScreen after 5 seconds
    _navigateToSplashScreen();
  }

  // Function to navigate to SplashScreen after a delay
  Future<void> _navigateToSplashScreen() async {
    await Future.delayed(const Duration(seconds: 5));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SplashScreen(
          slogan: 'Your Face, Your Key', // Pass the slogan to SplashScreen
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/a1.png'), // Path to your background image
            fit: BoxFit.cover, // This will cover the entire screen
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 90), // Added top padding for upward position
                child: Center(
                  child: Text(
                    '𝕱 𝖆 𝖈 𝖊 𝕲 𝖚 𝖆 𝖗 𝖑 𝖑 𝖑', // App name
                    style: TextStyle(
                      fontSize: 45, // Adjust the size
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(
                          255, 21, 21, 21), // Greenish color
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
              ),
            ),
            // Add space between the text and the button
            Spacer(),
            // "Get Started" button moved down and aligned to the right
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 40), // Padding to bring the button lower
              child: Align(
                alignment: Alignment.bottomRight, // Align to the right side
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 30), // Add right padding to space from edge
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SplashScreen(
                            slogan: 'Your Face, Your Key',
                          ),
                        ),
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
