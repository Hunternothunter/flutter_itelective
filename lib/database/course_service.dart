import 'dart:developer';
import 'package:flutter/material.dart';
import '../models/course.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch all available courses
  Future<List<Course>> fetchCourses() async {
    List<Course> courses = [];
    try {
      QuerySnapshot snapshot = await _firestore.collection('courses').get();
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Handle the modules field
        List<Module> modules = [];
        if (data['modules'] is List) {
          modules = (data['modules'] as List<dynamic>).map((module) {
            return Module.fromMap(module as Map<String, dynamic>);
          }).toList();
        }

        courses.add(Course(
          id: doc.id,
          title: data['title'],
          description: data['description'],
          instructor: data['instructor'],
          modules: modules,
        ));
      }
    } catch (e) {
      log("Error fetching courses: $e");
    }
    return courses;
  }

    // Fetch a single course by its ID
  Future<Course> fetchCourseById(String courseId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('courses').doc(courseId).get();

      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

        // Handle the modules field
        List<Module> modules = [];
        if (data['modules'] is List) {
          modules = (data['modules'] as List<dynamic>).map((module) {
            return Module.fromMap(module as Map<String, dynamic>);
          }).toList();
        }

        return Course(
          id: docSnapshot.id,
          title: data['title'],
          description: data['description'],
          instructor: data['instructor'],
          modules: modules,
        );
      } else {
        throw Exception("Course not found");
      }
    } catch (e) {
      log("Error fetching course: $e");
      rethrow;
    }
  }

  /// Fetch enrolled courses for a user
  Future<List<Course>> getEnrolledCourses(String userId) async {
    List<Course> enrolledCourses = [];
    try {
      DocumentSnapshot userSnapshot =
          await _firestore.collection('enrollments').doc(userId).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        List<dynamic> coursesData = userData['courses'] ?? [];

        for (var courseMap in coursesData) {
          String courseId = courseMap['course_id'];
          DocumentSnapshot courseSnapshot =
              await _firestore.collection('courses').doc(courseId).get();

          if (courseSnapshot.exists) {
            Map<String, dynamic> courseData =
                courseSnapshot.data() as Map<String, dynamic>;

            List<Module> modules = [];
            if (courseData['modules'] is List) {
              modules = (courseData['modules'] as List<dynamic>).map((module) {
                return Module.fromMap(module as Map<String, dynamic>);
              }).toList();
            }

            enrolledCourses.add(Course(
              id: courseSnapshot.id,
              title: courseData['title'],
              description: courseData['description'],
              instructor: courseData['instructor'],
              modules: modules,
            ));
          }
        }
      }
    } catch (e) {
      log("Error fetching enrolled courses: $e");
    }
    return enrolledCourses;
  }

  /// Enroll a user in a course
  Future<bool> enrollInCourse(
      String userId, String courseId, BuildContext context) async {
    try {
      DocumentReference enrollmentRef =
          _firestore.collection('enrollments').doc(userId);
      DocumentSnapshot enrollmentSnapshot = await enrollmentRef.get();

      if (enrollmentSnapshot.exists) {
        Map<String, dynamic> enrollmentData =
            enrollmentSnapshot.data() as Map<String, dynamic>;
        List<dynamic> courses = enrollmentData['courses'] ?? [];

        bool alreadyEnrolled =
            courses.any((course) => course['course_id'] == courseId);

        if (alreadyEnrolled) {
          _showMessage("You are already enrolled in this course", context);
          return false;
        }

        courses.add({
          'course_id': courseId,
          'enrolled_date': Timestamp.fromDate(DateTime.now()),
        });

        await enrollmentRef.update({'courses': courses});
      } else {
        await enrollmentRef.set({
          'user_id': userId,
          'courses': [
            {
              'course_id': courseId,
              'enrolled_date': Timestamp.fromDate(DateTime.now()),
            }
          ],
        });
      }

      _showMessage("Successfully enrolled in course", context);
      log('User $userId enrolled in course $courseId');
      return true;
    } catch (e) {
      log("Error enrolling in course: $e");
      _showMessage("Error enrolling in course: $e", context);
      return false;
    }
  }

  /// Display a message
  void _showMessage(String message, BuildContext context) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
    }
  }
}
