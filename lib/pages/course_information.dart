import 'package:flutter/material.dart';
import 'package:flutter_itelective/pages/course_detail.dart';
import '../models/course.dart';
import '../database/course_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseInformation extends StatefulWidget {
  final String courseId;

  const CourseInformation({super.key, required this.courseId});

  @override
  State<CourseInformation> createState() => _CourseInformationState();
}

class _CourseInformationState extends State<CourseInformation> {
  late CourseService _courseService;
  Course? _course;
  bool _isEnrolled = false; // Track if the user is enrolled

  @override
  void initState() {
    super.initState();
    _courseService = CourseService();
    _fetchCourseDetails();
  }

  // Fetch course details based on courseId
  Future<void> _fetchCourseDetails() async {
    Course course = await _courseService.fetchCourseById(widget.courseId);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId != null) {
      List<Course> enrolledCourses =
          await _courseService.getEnrolledCourses(userId);
      setState(() {
        _course = course;
        _isEnrolled = enrolledCourses
            .any((c) => c.id == course.id); // Check if user is enrolled
      });
    }
  }

  // Enroll the user in the course
  Future<void> _enrollInCourse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId != null && _course != null) {
      bool success =
          await _courseService.enrollInCourse(userId, _course!.id, context);
      if (success) {
        setState(() {
          _isEnrolled = true; // Update enrollment status
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to enroll in the course. Please try again.')),
      );
    }
  }

  // Show confirmation dialog before enrolling
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Enrollment'),
          content:
              const Text('Are you sure you want to enroll in this course?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _enrollInCourse();
              },
              child: const Text('Enroll'),
            ),
          ],
        );
      },
    );
  }

  // Show confirmation dialog before navigating to course
  void _showNavigationConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Start'),
          content: const Text('Do you want to start this course?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CourseDetailPage(course: _course!)),
                );
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  // Refresh course details when pulling down
  Future<void> _onRefresh() async {
    await _fetchCourseDetails();
  }

  @override
  Widget build(BuildContext context) {
    if (_course == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Course Details",
              style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 36, 209, 42),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor: Colors.white,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Course Details", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 36, 209, 42),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _onRefresh, // Trigger refresh on scroll or pull
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Course Title
                      Text(
                        _course!.title,
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      // Course Description
                      Text(
                        _course!.description,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      // Instructor Name
                      Text(
                        'Instructor: ${_course!.instructor}',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      // Modules Section
                      const Text(
                        'Modules:',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      // List of Modules
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _course!.modules.length,
                        itemBuilder: (context, index) {
                          final module = _course!.modules[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            elevation: 5.0,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    module.title,
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    module.content,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        // height: MediaQuery.of(context).size.width * 0.20,
        height: 80,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _isEnrolled
                ? _showNavigationConfirmationDialog // Navigate to course after confirmation
                : _showConfirmationDialog, // Show dialog to enroll
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 36, 209, 42),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    8.0), // Adjust border radius to your preference
              ),
            ),
            child: Text(
              _isEnrolled ? 'Start this course' : 'Click to Enroll',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
