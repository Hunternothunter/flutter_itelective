// import 'dart:developer';
// import 'package:firebase_auth/firebase_auth.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   // Create user with email and password
//   Future<User?> createUserWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       final userAuth = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return userAuth.user;
//     } on FirebaseAuthException catch (e) {
//       log("Error creating user: ${e.message}");
//       return null;
//     } catch (e) {
//       log("An unexpected error occurred: $e");
//       return null;
//     }
//   }

//   // Login user with email and password
//   Future<User?> loginUserWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       final userAuth = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return userAuth.user;
//     } on FirebaseAuthException catch (e) {
//       log("Error logging in: ${e.message}");
//       return null;
//     } catch (e) {
//       log("An unexpected error occurred: $e");
//       return null;
//     }
//   }

//   // Logout user
//   Future<void> logout() async {
//     try {
//       await _auth.signOut();
//     } catch (e) {
//       log("Error during logout: $e");
//     }
//   }

//   // Get the current logged-in user
//   User? getCurrentUser() {
//     return _auth.currentUser;
//   }

//   // Get user profile info (name, email, photo URL)
//   Future<Map<String, String?>> getUserProfileInfo() async {
//     final User? user = _auth.currentUser;
//     if (user != null) {
//       return {
//         'name': user.displayName ?? 'No Name',
//         'email': user.email ?? 'No Email',
//         'photoURL': user.photoURL,
//       };
//     } else {
//       return {
//         'name': 'Guest',
//         'email': 'No Email',
//         'photoURL': null,
//       };
//     }
//   }

//   // Future<List<Map<String, dynamic>>> getAllUsers() async {
//   //   try {
//   //     QuerySnapshot snapshot = await _firestore.collection('users').get();
//   //     List<Map<String, dynamic>> usersList = snapshot.docs.map((doc) {
//   //       return {
//   //         'uid': doc.id,
//   //         'email': doc['email'],
//   //         'displayName': doc['displayName'],
//   //         'photoURL': doc['photoURL'],
//   //       };
//   //     }).toList();

//   //     return usersList;
//   //   } catch (e) {
//   //     log("Error fetching users: $e");
//   //     return [];
//   //   }
//   // }
// }
