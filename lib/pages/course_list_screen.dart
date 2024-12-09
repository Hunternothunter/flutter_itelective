import 'package:flutter/material.dart';
import 'package:flutter_itelective/models/course.dart';
import 'package:flutter_itelective/database/course_service.dart';
import 'package:flutter_itelective/pages/course_detail.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  final CourseService _courseService = CourseService();

  @override
  void initState() {
    super.initState();
    // _insertSampleCourses(); // Call the method when the page loads
  }

  // Future<void> _insertSampleCourses() async {
  //   await _courseService.insertRealJavaCourses();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Course List"),
        backgroundColor: const Color.fromARGB(255, 36, 209, 42),
      ),
      body: _buildCourseList(),
    );
  }

  Widget _buildCourseList() {
    return FutureBuilder<List<Course>>(
      future: _courseService.fetchCourses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Failed to load courses."));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No courses available."));
        }

        final courses = snapshot.data!;

        return ListView.builder(
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return _buildCourseCard(course);
          },
        );
      },
    );
  }

  Widget _buildCourseCard(Course course) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(
          course.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(course.modules.length.toString()),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailPage(course: course),
            ),
          );
        },
      ),
    );
  }
}
