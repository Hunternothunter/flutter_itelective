// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:rafael_flutter/pages/course_intro.dart';
// import 'package:rafael_flutter/pages/home.dart';
// import 'package:rafael_flutter/auth/login.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_core/firebase_core.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   try {
//     await Firebase.initializeApp(
//         options: const FirebaseOptions(
//             apiKey: "AIzaSyD3fWZp9HOcmCtweUsd1Kz4yAeJlMucul0",
//             authDomain: "java-course-931bd.firebaseapp.com",
//             projectId: "java-course-931bd",
//             storageBucket: "java-course-931bd.firebasestorage.app",
//             messagingSenderId: "373588985186",
//             appId: "1:373588985186:web:05cf362e78b901539d583b",
//             measurementId: "G-YK7WRK97CV"));
//   } catch (e) {
//     log(e.toString());
//   }

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         primarySwatch: Colors.green,
//       ),
//       home: const SplashScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _navigateToNextScreen();
//   }

//   Future<void> _navigateToNextScreen() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool isFirstTime = prefs.getBool('isFirstTime') ?? true; // Default to true

//     if (isFirstTime) {
//       // Set the flag to false so it doesn't show again
//       await prefs.setBool('isFirstTime', false);
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const CourseIntroSlider()),
//       );
//     } else {
//       // Check if user is logged in using Firestore logic
//       // Assume we have a method isLoggedIn() for this
//       bool isLoggedIn = await _checkUserLoggedIn();
//       if (isLoggedIn) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const Home()),
//         );
//       } else {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const LoginPage()),
//         );
//       }
//     }
//   }

//   Future<bool> _checkUserLoggedIn() async {
//     try {
//       // Assuming you have a SharedPreferences key to store the current user ID
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? userId = prefs.getString('userId');

//       // If no user ID is stored, user is not logged in
//       if (userId == null) {
//         return false;
//       }

//       // // Query Firestore to check if the user exists and is active
//       // DocumentSnapshot userDoc = await FirebaseFirestore.instance
//       //     .collection('users')
//       //     .doc(userId)
//       //     .get();

//       // if (userDoc.exists) {
//       //   // Check specific fields for login status (e.g., `isLoggedIn`)
//       //   return userDoc.get('isLoggedIn') ?? false;
//       // }

//       return false;
//     } catch (e) {
//       // Log the error for debugging
//       log("Error checking user login status: $e");
//       return false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }
