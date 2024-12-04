import 'package:flutter/material.dart';
import 'package:login_signup/SecureStorage/secureStorage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_signup/screens/welcome_screen.dart';
import '../widgets/custom_scaffold.dart';

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
    String docId = email.replaceAll('@', '_').replaceAll('.', '_');
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(docId).get();

    if (userDoc.exists) {
      setState(() {
        userDetails = userDoc.data() as Map<String, dynamic>;
      });
    } else {
      setState(() {
        userDetails = null;
      });
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    await SecureStorage().deleteSecureData('userEmail');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      (Route<dynamic> route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out successfully')),
    );
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
              child: userDetails == null
                  // ignore: prefer_const_constructors
                  ? Center(
                      // ignore: prefer_const_constructors
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(width: 10),
                          Text('Loading user details...'),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'User Details',
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w900,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(height: 40.0),
                          _buildUserDetailRow(
                            label: 'First Name',
                            value: userDetails!['firstName'],
                            icon: Icons.person,
                          ),
                          _buildUserDetailRow(
                            label: 'Last Name',
                            value: userDetails!['lastName'],
                            icon: Icons.person_outline,
                          ),
                          _buildUserDetailRow(
                            label: 'Email',
                            value: userDetails!['email'],
                            icon: Icons.email,
                          ),
                          _buildUserDetailRow(
                            label: 'Date of Birth',
                            value: userDetails!['dob'],
                            icon: Icons.calendar_today,
                          ),
                          const SizedBox(
                              height: 20), // Spacing before the button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _logout,
                              child: const Text('Logout'),
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

  Widget _buildUserDetailRow({
    required String label,
    required String? value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 24),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
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
