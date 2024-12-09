import 'package:flutter/material.dart';
import 'package:flutter_itelective/models/course.dart';
import 'package:flutter_itelective/database/course_service.dart';
import 'package:flutter_itelective/pages/course_detail.dart';
import 'package:flutter_itelective/pages/course_information.dart';
import 'package:flutter_itelective/pages/enroll_course.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnrolledCourses extends StatefulWidget {
  const EnrolledCourses({super.key});

  @override
  State<EnrolledCourses> createState() => _EnrolledCoursesState();
}

class _EnrolledCoursesState extends State<EnrolledCourses> {
  late Future<List<Course>> _enrolledCourses;
  String userId = ""; // Empty userId that will be populated

  @override
  void initState() {
    super.initState();
    _enrolledCourses = Future.value([]); // Initialize with an empty list
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loadedUserId = prefs.getString('userId');

    setState(() {
      userId = loadedUserId!;
      _enrolledCourses = CourseService().getEnrolledCourses(userId);
    });
    }

  Future<void> _refreshEnrolledCourses() async {
    setState(() {
      _enrolledCourses = CourseService().getEnrolledCourses(userId);
    });
  }

  void _showAddCourseDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const EnrollCourse();
      },
    ).then((_) => _refreshEnrolledCourses());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Enrolled Courses"),
        ),
        body: RefreshIndicator(
          onRefresh: _refreshEnrolledCourses,
          child: FutureBuilder<List<Course>>(
            future: _enrolledCourses,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(
                    child: Text("Failed to load enrolled courses."));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                    child: Text("No enrolled courses available."));
              }

              final enrolledCourses = snapshot.data!;

              return ListView.builder(
                itemCount: enrolledCourses.length,
                itemBuilder: (context, index) {
                  final course = enrolledCourses[index];
                  return _buildCourseCard(course, context);
                },
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddCourseDialog,
          backgroundColor: const Color.fromARGB(255, 36, 209, 42),
          tooltip: 'Enroll courses',
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildCourseCard(Course course, BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          title: Text(
            course.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            course.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            // _showConfirmationDialog(context, course);
            // Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseInformation(courseId: course.id),
                ));
          },
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, Course course) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Start this course"),
          content: const Text("Do you wish to start this course?"),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.redAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseDetailPage(course: course),
                  ),
                );
              },
              child: const Text(
                "Yes",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}
