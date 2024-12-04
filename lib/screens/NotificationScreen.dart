import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/custom_scaffold.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NotificationsPage(),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  // Get the current date
  String getCurrentDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter =
        DateFormat('dd MMM, yyyy'); // Customize date format
    return formatter.format(now);
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
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    // Text(
                    //   getCurrentDate(), // Display the current date
                    //   style: const TextStyle(
                    //     fontSize: 16.0,
                    //     color: Colors.black54,
                    //   ),
                    // ),
                    const SizedBox(height: 40.0),

                    // Notification Image
                    // Image from assets
                    Image.asset(
                      'assets/images/pbox.png',
                      //'assets/images/postbox.png', // Update with your asset path
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'No notifications yet',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your notifications will appear here once you’ve received them.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
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
