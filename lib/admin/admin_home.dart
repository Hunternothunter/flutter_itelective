import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_itelective/admin/dashboard.dart';
import 'package:flutter_itelective/auth/login.dart';
import 'package:flutter_itelective/auth/auth_service.dart';
import 'package:flutter_itelective/pages/course_list.dart';
import 'package:flutter_itelective/pages/profile.dart';
import 'package:flutter_itelective/pages/quizzes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final AuthService _auth = AuthService();
  String? _userName;
  String? _userEmail;
  String? _profilePicUrl;
  int _currentIndex = 0;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

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

  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context); // Close the dialog
                try {
                  await _auth.logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                } catch (e) {
                  log("Logout failed: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Failed to log out. Please try again.")),
                  );
                }
              },
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: _buildSelectedPage(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    String appBarTitle = '';
    switch (_currentIndex) {
      case 0:
        appBarTitle = 'Dashboard';
        break;
      case 1:
        appBarTitle = 'Courses';
        break;
      case 2:
        appBarTitle = 'Quizzes';
        break;
      case 3:
        appBarTitle = 'Profile';
        break;
      default:
        appBarTitle = 'Dashboard';
    }

    return AppBar(
      title: Text(
        appBarTitle,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: const Color.fromARGB(255, 36, 209, 42),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          tooltip: 'Log Out',
          onPressed: _logout,
        ),
      ],
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(_userName ?? 'User Name'),
            accountEmail: Text(_userEmail ?? 'Email'),
            currentAccountPicture: CircleAvatar(
              backgroundImage:
                  _profilePicUrl != null ? NetworkImage(_profilePicUrl!) : null,
              child: _profilePicUrl == null
                  ? const Icon(Icons.person, size: 40)
                  : null,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Dashboard'),
            onTap: () {
              setState(() {
                _currentIndex = 0;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Courses'),
            onTap: () {
              setState(() {
                _currentIndex = 1;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.quiz),
            title: const Text('Quizzes'),
            onTap: () {
              setState(() {
                _currentIndex = 2;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              setState(() {
                _currentIndex = 3;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      selectedItemColor: const Color.fromARGB(255, 36, 209, 42),
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Courses',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.quiz),
          label: 'Quizzes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  Widget _buildSelectedPage() {
    switch (_currentIndex) {
      case 0:
        return const Dashboard();
      case 1:
        return const CourseList();
      case 2:
        return const Quizzes();
      case 3:
        return const ProfilePage();
      default:
        return const Center(child: Text('Page not found'));
    }
  }
}
