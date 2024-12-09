import 'dart:developer';
import '../models/course.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

        log('Fetched Course: ${data['title']}');
        log('Modules: ${modules.length}'); // Log the number of modules

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

  // Add a new course
  Future<void> addCourse(Course course) async {
    try {
      await _firestore.collection('courses').doc(course.id).set({
        'title': course.title,
        'description': course.description,
        'modules': course.modules.map((module) {
          return {
            'title': module.title,
            'content': module.content,
            'codeExample': module.codeExample,
          };
        }).toList(),
      });
      log("Course added successfully!");
    } catch (e) {
      log("Error adding course: $e");
    }
  }

  // Update an existing course
  Future<void> updateCourse(String courseId, Course updatedCourse) async {
    try {
      await _firestore.collection('courses').doc(courseId).update({
        'title': updatedCourse.title,
        'description': updatedCourse.description,
        'modules': updatedCourse.modules.map((module) {
          return {
            'title': module.title,
            'content': module.content,
            'codeExample': module.codeExample,
          };
        }).toList(),
      });
      log("Course updated successfully!");
    } catch (e) {
      log("Error updating course: $e");
    }
  }

  // Delete a course
  Future<void> deleteCourse(String courseId) async {
    try {
      await _firestore.collection('courses').doc(courseId).delete();
      log("Course deleted successfully!");
    } catch (e) {
      log("Error deleting course: $e");
    }
  }

  // Insert real Java programming courses with 10 modules
  Future<void> insertRealJavaCourses() async {
    List<Course> realCourses = [
      Course(
        id: "course1",
        title: "Introduction to Java Programming",
        description:
            "Learn the basics of Java programming, including variables, loops, and control structures.",
        instructor: "Jonhny Sins",
        modules: [
          Module(
            title: "Module 1: Introduction to Java",
            content: "Overview of Java, installation, and basic syntax.",
            codeExample: "// Java HelloWorld program",
          ),
          Module(
            title: "Module 2: Variables and Data Types",
            content:
                "Learn about variables, data types, and operators in Java.",
            codeExample: "// Example of variable declaration in Java",
          ),
          Module(
            title: "Module 3: Control Flow - If/Else",
            content:
                "Understand decision-making structures like if-else statements.",
            codeExample: "// Java if-else example",
          ),
          Module(
            title: "Module 4: Loops - For, While, Do-While",
            content: "Learn how to use loops to repeat actions.",
            codeExample: "// Java for loop example",
          ),
          Module(
            title: "Module 5: Functions and Methods",
            content: "Understand how to define and use functions and methods.",
            codeExample: "// Java method example",
          ),
          Module(
            title: "Module 6: Arrays and Collections",
            content: "Learn how to work with arrays and collections.",
            codeExample: "// Java array example",
          ),
          Module(
            title: "Module 7: Object-Oriented Programming - Introduction",
            content: "Introduction to classes, objects, and methods in Java.",
            codeExample: "// Java class and object example",
          ),
          Module(
            title: "Module 8: Inheritance",
            content: "Learn how inheritance works in Java.",
            codeExample: "// Java inheritance example",
          ),
          Module(
            title: "Module 9: Polymorphism",
            content: "Understand the concept of polymorphism in Java.",
            codeExample: "// Java polymorphism example",
          ),
          Module(
            title: "Module 10: Exception Handling",
            content:
                "Learn how to handle exceptions in Java using try-catch blocks.",
            codeExample: "// Java exception handling example",
          ),
        ],
      ),
      Course(
        id: "course2",
        title: "Object-Oriented Programming in Java",
        description:
            "Dive deep into OOP concepts like classes, objects, inheritance, polymorphism, and encapsulation.",
        instructor: "Jonhny Sins",
        modules: [
          Module(
            title: "Module 1: OOP Basics",
            content:
                "Introduction to Object-Oriented Programming and its principles.",
            codeExample: "// Java OOP basics example",
          ),
          Module(
            title: "Module 2: Classes and Objects",
            content: "Understanding classes and creating objects in Java.",
            codeExample: "// Java class and object example",
          ),
          Module(
            title: "Module 3: Constructors",
            content: "Learn how constructors are used to initialize objects.",
            codeExample: "// Java constructor example",
          ),
          Module(
            title: "Module 4: Encapsulation",
            content: "How to implement encapsulation in Java.",
            codeExample: "// Java encapsulation example",
          ),
          Module(
            title: "Module 5: Inheritance in Detail",
            content: "A deeper dive into inheritance and overriding methods.",
            codeExample: "// Java inheritance and method overriding example",
          ),
          Module(
            title: "Module 6: Polymorphism in Detail",
            content:
                "Learn about method overloading and dynamic method dispatch.",
            codeExample: "// Java polymorphism example",
          ),
          Module(
            title: "Module 7: Abstraction",
            content: "Learn about abstract classes and interfaces.",
            codeExample: "// Java abstraction example",
          ),
          Module(
            title: "Module 8: Design Patterns",
            content: "Explore common design patterns used in Java programming.",
            codeExample: "// Java design pattern example",
          ),
          Module(
            title: "Module 9: Java Collections Framework",
            content: "Understand how to use collections in Java.",
            codeExample: "// Java collections example",
          ),
          Module(
            title: "Module 10: Best Practices",
            content: "Best practices and coding standards for Java developers.",
            codeExample: "// Java best practices example",
          ),
        ],
      ),
    ];

    // Insert each course into Firestore
    try {
      for (var course in realCourses) {
        await _firestore.collection('courses').doc(course.id).set({
          'title': course.title,
          'description': course.description,
          'instructor': course.instructor,
          'modules': course.modules.map((module) {
            return {
              'title': module.title,
              'content': module.content,
              'codeExample': module.codeExample,
            };
          }).toList(),
        });
        log("Inserted Course: ${course.title}");
      }
    } catch (e) {
      log("Error inserting real courses: $e");
    }
  }
}
