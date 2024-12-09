import 'package:flutter/material.dart';

class SnackBarHelper {
  // Function to show a SnackBar
  static void showSnackBar(BuildContext context, String message,
      {SnackBarBehavior behavior = SnackBarBehavior.fixed,
      Duration duration = const Duration(seconds: 1)}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: behavior,
        duration: duration,
      ),
    );
  }
}
