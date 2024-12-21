import 'dart:io'; // Import for File (Mobile only)
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_signup/widgets/custom_scaffold.dart';

class RetrieveUserDataScreen extends StatefulWidget {
  @override
  _RetrieveUserDataScreenState createState() => _RetrieveUserDataScreenState();
}

class _RetrieveUserDataScreenState extends State<RetrieveUserDataScreen> {
  String _retrievedImagePath = '';
  String _retrievedName = '';
  String _retrievedDepartment = '';
  String _retrievedContactNumber = '';
  bool _isLoading = true; // Variable to show loading indicator

  // Function to retrieve user data from Firestore
  Future<void> _retrieveUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch data from Firestore based on the user's UID
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            _retrievedName = userDoc['name'] ?? 'No name found';
            _retrievedDepartment =
                userDoc['department'] ?? 'No department found';
            _retrievedContactNumber =
                userDoc['contactNumber'] ?? 'No contact number found';
            _retrievedImagePath = userDoc['imageUrl'] ?? '';
          });
        } else {
          setState(() {
            _retrievedName = 'No data found';
            _retrievedDepartment = 'No data found';
            _retrievedContactNumber = 'No data found';
            _retrievedImagePath = '';
          });
        }
      } catch (e) {
        setState(() {
          _retrievedName = 'Error retrieving data';
          _retrievedDepartment = 'Error retrieving data';
          _retrievedContactNumber = 'Error retrieving data';
          _retrievedImagePath = '';
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error retrieving data: $e')));
      }
    } else {
      setState(() {
        _retrievedName = 'User not logged in';
        _retrievedDepartment = '';
        _retrievedContactNumber = '';
        _retrievedImagePath = '';
      });
    }

    setState(() {
      _isLoading = false; // Hide the loading indicator after data is retrieved
    });
  }

  @override
  void initState() {
    super.initState();
    _retrieveUserData();
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
                child: _isLoading
                    ? Center(
                        child:
                            CircularProgressIndicator()) // Show loading spinner while data is loading
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'User Data',
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w900,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(height: 40.0),

                          // Display the image if available
                          if (_retrievedImagePath.isNotEmpty)
                            Image.network(
                              _retrievedImagePath,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          else
                            Icon(Icons.account_circle,
                                size: 100), // Default icon if no image

                          const SizedBox(height: 16),

                          // Section: User Data
                          buildSectionTitle('User Information'),
                          buildListTile(Icons.person, 'Name',
                              value: _retrievedName),
                          buildListTile(Icons.work, 'Department',
                              value: _retrievedDepartment),
                          buildListTile(Icons.phone, 'Contact Number',
                              value: _retrievedContactNumber),

                          const SizedBox(height: 25.0),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey[600],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildListTile(IconData icon, String title, {required String value}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.grey[800],
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          color: Colors.grey[700],
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[600]),
      onTap: () {
        // Add functionality if needed
      },
    );
  }
}
