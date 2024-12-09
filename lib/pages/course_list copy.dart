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
          final instructor = course.instructor.toLowerCase();
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
    return Scaffold(
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
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to add new course page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddCoursePage()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 16),
                Expanded(
                  child: _filteredCourses.isEmpty
                      ? const Center(child: Text("No courses found."))
                      : ListView.builder(
                          itemCount: _filteredCourses.length,
                          itemBuilder: (context, index) {
                            final course = _filteredCourses[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: _buildCourseCard(course, context),
                            );
                          },
                        ),
                ),
              ],
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
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Navigate to edit course page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditCoursePage(course: course),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  // Confirm deletion
                  bool? confirm = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete Course'),
                        content: const Text('Are you sure you want to delete this course?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                  if (confirm ?? false) {
                    // Call delete method from CourseService
                    // await CourseService().deleteCourse(course.id);
                    _fetchCourses(); // Refresh the course list
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Course deleted successfully.')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddCoursePage extends StatelessWidget {
  const AddCoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Course')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Add course logic here
          },
          child: const Text('Add New Course'),
        ),
      ),
    );
  }
}

class EditCoursePage extends StatelessWidget {
  final Course course;

  const EditCoursePage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Course')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Edit course logic here
          },
          child: const Text('Edit Course'),
        ),
      ),
    );
  }
}
