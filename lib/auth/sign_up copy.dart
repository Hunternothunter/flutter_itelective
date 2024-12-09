// // ignore_for_file: use_build_context_synchronously
// import 'package:flutter/material.dart';
// import 'package:rafael_flutter/auth/login.dart';
// import 'package:rafael_flutter/pages/course_list.dart';
// import 'package:rafael_flutter/pages/auth_service.dart';
// import '../snackbar_helper.dart';

// class SignUp extends StatefulWidget {
//   const SignUp({super.key});

//   @override
//   State<SignUp> createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   final _auth = AuthService();

//   final TextEditingController _name = TextEditingController();
//   final TextEditingController _email = TextEditingController();
//   final TextEditingController _password = TextEditingController();

//   bool _isChecked = false;

//   @override
//   void dispose() {
//     super.dispose();
//     _name.dispose();
//     _email.dispose();
//     _password.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF134B70),
//       body: Center(
//         child: Container(
//           width: 550,
//           padding: const EdgeInsets.all(24),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 spreadRadius: 5,
//                 blurRadius: 10,
//                 offset: const Offset(0, 5),
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const Center(
//                 child: Text(
//                   'Sign Up',
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.green,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               TextField(
//                 controller: _name,
//                 decoration: InputDecoration(
//                   labelText: 'Full Name',
//                   hintText: 'Enter your full name',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   prefixIcon: const Icon(
//                     Icons.person,
//                     color: Colors.green,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: _email,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: InputDecoration(
//                   labelText: 'Email Address',
//                   hintText: 'Enter your email',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   prefixIcon: const Icon(
//                     Icons.email,
//                     color: Colors.green,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: _password,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   hintText: 'Enter your password',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   prefixIcon: const Icon(
//                     Icons.lock,
//                     color: Colors.green,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               Row(
//                 children: [
//                   Checkbox(
//                     value: _isChecked,
//                     onChanged: (bool? value) {
//                       setState(() {
//                         _isChecked = value ?? false;
//                       });
//                     },
//                   ),
//                   const Text(
//                     'I agree to the terms and conditions',
//                     style: TextStyle(fontSize: 14),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 30),
//               SizedBox(
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     if (!_isChecked) {
//                       SnackBarHelper.showSnackBar(
//                           context, "Please agree to the terms and conditions");
//                       return;
//                     }

//                     if (!_isChecked) {
//                       SnackBarHelper.showSnackBar(
//                           context, "Please agree to the terms and conditions");
//                       return;
//                     }

//                     final user = await _auth.createUserWithEmailAndPassword(
//                       _email.text,
//                       _password.text,
//                     );
//                     if (user != null) {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const CourseList()),
//                       );
//                     } else {
//                       SnackBarHelper.showSnackBar(
//                           context, "Sign up failed. Please try again.");
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: const Text(
//                     'Sign Up',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text("Already have an account? "),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const LoginPage()),
//                       );
//                     },
//                     child: const Text(
//                       'Login',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
