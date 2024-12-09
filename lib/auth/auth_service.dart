import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Hash password using SHA256 for storage and comparison
  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  // Create user and save additional details to Firestore
  Future<bool> createUserWithEmailAndPassword(String email, String password,
      String username, String firstname, String lastname) async {
    try {
      // Check if the email or username already exists in Firestore
      var emailSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      if (emailSnapshot.docs.isNotEmpty) {
        throw Exception("Email already in use.");
      }

      var usernameSnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();
      if (usernameSnapshot.docs.isNotEmpty) {
        throw Exception("Username already in use.");
      }

      // Hash the password before saving
      String hashedPassword = _hashPassword(password);
      String role = "User";
      // Save user details to Firestore
      await _firestore.collection('users').add({
        'email': email,
        'username': username,
        'firstname': firstname,
        'lastname': lastname,
        'password': hashedPassword,
        'role': role,
      });

      return true;
    } catch (e) {
      log("Error creating user: $e");
      return false;
    }
  }

  // Login user with email or username and password
  Future<Map<String, dynamic>?> loginUserWithEmailOrUsername(
      String identifier, String password) async {
    try {
      // Hash the entered password for comparison
      String hashedPassword = _hashPassword(password);

      // If identifier is an email
      if (identifier.contains('@')) {
        // Query Firestore for the user by email
        var userSnapshot = await _firestore
            .collection('users')
            .where('email', isEqualTo: identifier)
            .get();

        if (userSnapshot.docs.isEmpty) {
          throw Exception('User not found');
        }

        var userDoc = userSnapshot.docs.first;
        if (userDoc['password'] == hashedPassword) {
          // Store the userId in SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('userId', userDoc.id); // Storing userId
          return {
            'userId': userDoc.id,
            'firstname': userDoc['firstname'],
            'lastname': userDoc['lastname'],
            'username': userDoc['username'],
            'email': userDoc['email'],
            'role': userDoc['role']
          };
        } else {
          throw Exception('Incorrect password');
        }
      } else {
        // If identifier is a username, query Firestore to find the corresponding email
        var userSnapshot = await _firestore
            .collection('users')
            .where('username', isEqualTo: identifier)
            .get();

        if (userSnapshot.docs.isEmpty) {
          throw Exception('User not found');
        }

        var userDoc = userSnapshot.docs.first;

        if (userDoc['password'] == hashedPassword) {
          // Store the userId in SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('userId', userDoc.id);
          await prefs.setBool('isFirstTime', false);
          await prefs.setString('role', userDoc['role']);

          return {
            'userId': userDoc.id,
            'firstname': userDoc['firstname'],
            'lastname': userDoc['lastname'],
            'username': userDoc['username'],
            'email': userDoc['email'],
            'role': userDoc['role']
          };
        } else {
          throw Exception('Incorrect password');
        }
      }
    } catch (e) {
      log("Error logging in: $e");
      return null;
    }
  }

  // Get user profile information from Firestore
  Future<Map<String, String?>> getUserProfileInfo(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        return {
          'name': '${userDoc['firstname']} ${userDoc['lastname']}',
          'email': userDoc['email'],
          'username': userDoc['username'],
          'role': userDoc['role']
        };
      } else {
        return {
          'name': 'Guest',
          'email': 'No Email',
          'username': 'No Username',
          'role': 'User'
        };
      }
    } catch (e) {
      log("Error fetching user profile: $e");
      return {
        'name': 'Guest',
        'email': 'No Email',
        'username': 'No Username',
        'role': 'User'
      };
    }
  }

  Future<Map<String, String?>> getCurrentUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    // Retrieve user information from Firestore using the userId
    return await getUserProfileInfo(userId!);
  }

  void displayUserInfo() async {
    Map<String, String?> userInfo = await getCurrentUserProfile();

    log('Name: ${userInfo['name']}');
    log('Email: ${userInfo['email']}');
    log('Username: ${userInfo['username']}');
    log('Role: ${userInfo['role']}');
  }

  // Logout user
  Future<void> logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('userId');
      log("User successfully logged out.");
    } catch (e) {
      // Log the error to assist debugging
      log("Error during logout: $e");
    }
  }
}
