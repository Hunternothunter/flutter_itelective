// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:rafael_flutter/auth/sign_up.dart';
// import 'package:rafael_flutter/pages/auth_service.dart';
// import 'package:rafael_flutter/pages/home.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _auth = AuthService();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF134B70),
//       body: Center(
//         child: Container(
//           width: 550,
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.2),
//                 spreadRadius: 5,
//                 blurRadius: 7,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const Center(
//                 child: Text(
//                   'Login',
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.green,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               _buildTextField(
//                 controller: _emailController,
//                 label: 'Email',
//                 hint: 'Enter your email',
//                 icon: Icons.email,
//                 isPassword: false,
//               ),
//               const SizedBox(height: 20),
//               _buildTextField(
//                 controller: _passwordController,
//                 label: 'Password',
//                 hint: 'Enter your password',
//                 icon: Icons.lock,
//                 isPassword: true,
//               ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: _login,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 20),
//                 ),
//                 child: const Text(
//                   'Login',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     "Don't have an account?",
//                     style: TextStyle(fontSize: 14),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(builder: (context) => const SignUp()),
//                       );
//                     },
//                     child: const Text(
//                       'Sign Up',
//                       style: TextStyle(
//                         fontSize: 14,
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

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required String hint,
//     required IconData icon,
//     required bool isPassword,
//   }) {
//     return TextField(
//       controller: controller,
//       obscureText: isPassword,
//       keyboardType:
//           isPassword ? TextInputType.text : TextInputType.emailAddress,
//       decoration: InputDecoration(
//         labelText: label,
//         hintText: hint,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         prefixIcon: Icon(
//           icon,
//           color: Colors.green,
//         ),
//       ),
//     );
//   }

//   Future<void> _login() async {
//     if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Please fill out all fields."),
//           duration: Duration(milliseconds: 1000),
//         ),
//       );
//       return;
//     }

//     final user = await _auth.loginUserWithEmailAndPassword(
//       _emailController.text,
//       _passwordController.text,
//     );

//     if (user != null) {
//       log("Successfully logged in.");
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const Home()),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Invalid email or password. Please try again."),
//           duration: Duration(milliseconds: 1000),
//         ),
//       );
//     }
//   }
// }
