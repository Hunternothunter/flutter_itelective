import 'package:flutter/material.dart';
import 'package:flutter_itelective/models/course.dart';
import 'package:flutter_itelective/pages/course_information.dart'; // Import CourseInformation page
import 'package:flutter_itelective/database/course_service.dart';

class CourseList extends StatefulWidget {
  const CourseList({super.key});

  @override
  State<CourseList> createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  List<Course> _courses = [];
  List<Course> _filteredCourses = [];
  bool _isLoading = true;
  String _searchQuery = "";

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
        _filteredCourses = courses; // Initially show all courses
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load courses.')),
      );
    }
  }

  void _filterCourses(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredCourses = _courses;
      } else {
        _filteredCourses = _courses.where((course) {
          final title = course.title.toLowerCase();
          final description = course.description.toLowerCase();
          final instructor = course.instructor
              .toLowerCase(); // Assuming you have an `instructor` property
          final searchQuery = query.toLowerCase();
          return title.contains(searchQuery) ||
              description.contains(searchQuery) ||
              instructor.contains(searchQuery);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              onChanged: _filterCourses,
              decoration: InputDecoration(
                hintText: 'Search courses...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(8.0),
              ),
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  const SizedBox(height: 16), // Gap between search and list
                  Expanded(
                    child: _filteredCourses.isEmpty
                        ? const Center(child: Text("No courses found."))
                        : ListView.builder(
                            itemCount: _filteredCourses.length,
                            itemBuilder: (context, index) {
                              final course = _filteredCourses[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: _buildCourseCard(course, context),
                              );
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildCourseCard(Course course, BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
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
            // Pass the courseId to CourseInformation screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CourseInformation(courseId: course.id),
              ),
            );
          },
        ),
      ),
    );
  }
}
