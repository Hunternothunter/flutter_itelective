// import 'dart:developer';
// import 'package:firebase_auth/firebase_auth.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<User?> createUserWithEmailAndPassword(String email, String password) async {
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

//   Future<User?> loginUserWithEmailAndPassword(String email, String password) async {
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

//   Future<void> logout() async {
//     try {
//       await _auth.signOut();
//     } catch (e) {
//       log("Error during logout: $e");
//     }
//   }
// }
