import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_itelective/auth/auth_service.dart';
import 'package:flutter_itelective/auth/login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _auth = AuthService();
  String? _userName;
  String? _userEmail;
  String? _profilePicUrl;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Load user info when the page loads
  Future<void> _loadUserInfo() async {
    try {
      Map<String, String?> userInfo = await _auth.getCurrentUserProfile();
      setState(() {
        _userName = userInfo['name'];
        _userEmail = userInfo['email'];
        _profilePicUrl = userInfo['profilePicUrl'];
      });
    } catch (e) {
      log('Error loading user info: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserInfo(); // Load the user data when the page is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Profile Picture
                CircleAvatar(
                  radius: 60,
                  backgroundImage: _profilePicUrl != null
                      ? NetworkImage(_profilePicUrl!) as ImageProvider
                      : const AssetImage('assets/default_profile_pic.png'),
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(height: 16),
                // User's Name
                Text(
                  _userName ?? 'Loading...',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // User's Email
                Text(
                  _userEmail ?? 'Loading...',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await _auth.logout();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      } catch (e) {
                        log('Error logging out: $e');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.red, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.exit_to_app,
                          color: Colors.red,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
