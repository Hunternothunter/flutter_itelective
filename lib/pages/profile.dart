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
  String? _userUserName;
  String? _userRole;
  String? _profilePicUrl;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Load user info when the page loads
  Future<void> _loadUserInfo() async {
    try {
      Map<String, String?> userInfo = await _auth.getCurrentUserProfile();
      setState(() {
        _userName = userInfo['name'];
        _userEmail = userInfo['email'];
        _userRole = userInfo['role'];
        _userUserName = userInfo['username'];
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
                // Profile Picture and Edit Profile Button
                Column(
                  children: [
                    // Profile picture container
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color.fromARGB(255, 164, 165, 165),
                          width: 1,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: _profilePicUrl != null
                            ? NetworkImage(_profilePicUrl!)
                            : const NetworkImage(
                                'https://toppng.com/public/uploads/preview/instagram-default-profile-picture-11562973083brycehrmyv.png'),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    const SizedBox(height: 10), // Space between image and button
                    
                    // Edit profile button (smaller width)
                    SizedBox(
                      width: 150, // Adjust width for smaller button
                      child: ElevatedButton(
                        onPressed: () {
                          // Add action for editing the profile
                          log('Edit Profile pressed');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 206, 206, 206),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.edit, // The icon for editing the profile
                              color: Color.fromARGB(255, 44, 44, 44),
                            ),
                            SizedBox(width: 8), // Space between icon and text
                            Text(
                              'Edit Profile',
                              style: TextStyle(
                                color: Color.fromARGB(255, 44, 44, 44),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),

                // User's Name (TextField with label aligned left and data aligned right)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Name',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(text: _userName),
                        readOnly: true,
                        textAlign: TextAlign.right,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // User's Email (Container with space-between alignment)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Email',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          _userEmail ?? 'Loading...',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // User's Username (TextField with label aligned left and data aligned right)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Username',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(text: _userUserName),
                        readOnly: true,
                        textAlign: TextAlign.right,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // User's Role (TextField with label aligned left and data aligned right)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Role',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(text: _userRole),
                        readOnly: true,
                        textAlign: TextAlign.right,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Log Out button (increased height)
                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
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
                      backgroundColor: const Color.fromARGB(255, 255, 78, 78),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.exit_to_app, // The icon for logging out
                          color: Color.fromARGB(255, 255, 255, 255),
                          size: 26,
                        ),
                        SizedBox(width: 12), // Space between icon and text
                        Text(
                          'Log Out',
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
