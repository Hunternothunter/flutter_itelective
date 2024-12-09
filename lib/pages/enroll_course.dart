import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_itelective/database/course_service.dart';
import 'package:flutter_itelective/models/course.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnrollCourse extends StatefulWidget {
  const EnrollCourse({super.key});

  @override
  State<EnrollCourse> createState() => _EnrollCourseState();
}

class _EnrollCourseState extends State<EnrollCourse> {
  String? _selectedCourse;
  List<String> _courseTitles = [];
  List<Course> _courses = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    try {
      List<Course> courses = await CourseService().fetchCourses();
      setState(() {
        _courses = courses;
        _courseTitles = courses.map((course) => course.title).toList();
      });
    } catch (e) {
      log('Error fetching courses: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error fetching courses')),
        );
      }
    }
  }

  Future<void> _enrollInCourse() async {
    if (_selectedCourse != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        final prefs = await SharedPreferences.getInstance();
        String? userId = prefs.getString('userId');

        String courseId =
            _courses.firstWhere((course) => course.title == _selectedCourse).id;

        bool success =
            await CourseService().enrollInCourse(userId!, courseId, context);

        if (success) {
          setState(() {
            _selectedCourse = null;
          });
        }
      } catch (e) {
        log('Error enrolling in course: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error enrolling in course')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showConfirmationDialog() {
    if (_selectedCourse != null) {
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dismissing during loading
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: const Text('Confirm Enrollment'),
                content: _isLoading
                    ? const SizedBox(
                        height: 50,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : Text(
                        'Are you sure you want to enroll in $_selectedCourse?'),
                actions: _isLoading
                    ? []
                    : <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Yes'),
                          onPressed: () async {
                            setDialogState(() {
                              _isLoading = true;
                            });
                            await _enrollInCourse();
                            setDialogState(() {
                              _isLoading = false;
                            });
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
              );
            },
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a course first')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enroll in a Course'),
      content: _courseTitles.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : DropdownButton<String>(
              value: _selectedCourse,
              hint: const Text('Select a Course'),
              isExpanded: true,
              items: _courseTitles.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCourse = newValue;
                });
              },
            ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.grey[200], // Light gray background
            foregroundColor: Colors.red, // Text color
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Rounded corners
            ),
          ),
          child: const Text(
            'Cancel',
            style: TextStyle(fontWeight: FontWeight.bold), // Bold text
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: _showConfirmationDialog,
          child: const Text(
            'Enroll',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
