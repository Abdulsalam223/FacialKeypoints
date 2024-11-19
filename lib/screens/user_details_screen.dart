import 'package:flutter/material.dart';
import 'package:login_signup/SecureStorage/secureStorage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_signup/screens/signin_screen.dart';
import 'package:login_signup/screens/welcome_screen.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  String? userEmail;
  Map<String, dynamic>? userDetails;

  @override
  void initState() {
    super.initState();
    _getUserEmail();
  }

  Future<void> _getUserEmail() async {
    userEmail = await SecureStorage().readSecureData('userEmail');
    if (userEmail != null) {
      await _fetchUserDetails(userEmail!);
    }
  }

  Future<void> _fetchUserDetails(String email) async {
    // Replace '@' and '.' with '_' to match Firestore document ID format
    String docId = email.replaceAll('@', '_').replaceAll('.', '_');

    print('Fetching user details for email: $email');

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(docId).get();

    print('User document in user details: ${userDoc.data()}');

    if (userDoc.exists) {
      setState(() {
        userDetails = userDoc.data() as Map<String, dynamic>;
      });
    } else {
      // Handle user not found
      setState(() {
        userDetails = null;
      });
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    await SecureStorage().deleteSecureData('userEmail');

    // Redirect to WelcomeScreen without allowing back navigation
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      (Route<dynamic> route) => false, // Removes all previous routes
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        backgroundColor: Colors.blueAccent,
      ),
      body: userDetails == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildUserDetailRow(
                          label: 'First Name',
                          value: userDetails!['firstName']),
                      _buildUserDetailRow(
                          label: 'Last Name', value: userDetails!['lastName']),
                      _buildUserDetailRow(
                          label: 'Email', value: userDetails!['email']),
                      _buildUserDetailRow(
                          label: 'Date of Birth', value: userDetails!['dob']),
                      const SizedBox(height: 20), // Spacing before the button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            iconColor: Colors.red, // Button color
                          ),
                          onPressed: _logout,
                          child: const Text('Logout'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildUserDetailRow({required String label, required String? value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value ?? 'N/A',
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
