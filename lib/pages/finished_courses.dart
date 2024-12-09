import 'package:flutter/material.dart';

class FinishedCourses extends StatefulWidget {
  const FinishedCourses({super.key});

  @override
  State<FinishedCourses> createState() => _FinishedCoursesState();
}

class _FinishedCoursesState extends State<FinishedCourses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Text("You haven't finised any courses yet."),
        ),
      ),
    );
  }
}
