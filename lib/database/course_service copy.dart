// import 'dart:developer';
// import '../models/course.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class CourseService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<List<Course>> fetchCourses() async {
//     List<Course> courses = [];
//     try {
//       QuerySnapshot snapshot = await _firestore.collection('courses').get();
//       for (var doc in snapshot.docs) {
//         Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

//         // Handle the modules field
//         List<Module> modules = [];
//         if (data['modules'] is List) {
//           modules = (data['modules'] as List<dynamic>).map((module) {
//             return Module.fromMap(module as Map<String, dynamic>);
//           }).toList();
//         }

//         log('Fetched Course: ${data['title']}');
//         log('Modules: ${modules.length}'); // Log the number of modules

//         courses.add(Course(
//           id: doc.id,
//           title: data['title'],
//           description: data['description'],
//           modules: modules,
//         ));
//       }
//     } catch (e) {
//       log("Error fetching courses: $e");
//     }
//     return courses;
//   }
//   // Method to fetch the enrolled courses for a user
//   Future<List<Course>> getEnrolledCourses(String userId) async {
//     // Assuming you are using an API or database query to fetch data
//     // Here we mock the return data for the sake of example
//     // Fetch the enrolled courses for the user from the database
//     List<Course> enrolledCourses = await Database.fetchEnrolledCourses(userId);
//     return enrolledCourses;
//   }

//   // Method to enroll a user in a course
//   Future<void> enrollInCourse(String userId, String courseId) async {
//     // Call an API or service to handle the enrollment in the database
//     // Here, we assume a function that adds an entry to the Enrollments table
//     await Database.enrollUserInCourse(userId, courseId);
//   }
// }
//   // Insert real Java programming courses with 10 modules
// //   Future<void> insertRealJavaCourses() async {
// //     List<Course> realCourses = [
// //       Course(
// //         id: "course1",
// //         title: "Introduction to Java Programming",
// //         description:
// //             "Learn the basics of Java programming, including variables, loops, control structures, and simple object-oriented principles.",
// //         modules: [
// //           Module(
// //             title: "Module 1: Introduction to Java",
// //             content:
// //                 "Learn about Java's history, installation process, and the basic syntax for writing Java programs.",
// //             codeExample: """
// // // Java HelloWorld program
// // public class HelloWorld {
// //     public static void main(String[] args) {
// //         System.out.println("Hello, World!");
// //     }
// // }
// //             """,
// //           ),
// //           Module(
// //             title: "Module 2: Variables and Data Types",
// //             content:
// //                 "Understand how to declare and use variables in Java. Learn about primitive data types and type conversions.",
// //             codeExample: """
// // // Java example of declaring variables
// // int age = 25;
// // double temperature = 22.5;
// // boolean isJavaFun = true;
// //             """,
// //           ),
// //           Module(
// //             title: "Module 3: Control Flow - If/Else",
// //             content:
// //                 "Learn how to use if-else statements to make decisions in your Java programs.",
// //             codeExample: """
// // // Java if-else statement
// // int num = 10;
// // if (num > 0) {
// //     System.out.println("Positive");
// // } else {
// //     System.out.println("Negative or Zero");
// // }
// //             """,
// //           ),
// //           Module(
// //             title: "Module 4: Loops - For, While, Do-While",
// //             content:
// //                 "Learn how to use different types of loops to repeat actions multiple times.",
// //             codeExample: """
// // // Java for loop
// // for (int i = 0; i < 5; i++) {
// //     System.out.println("i: " + i);
// // }

// // // Java while loop
// // int i = 0;
// // while (i < 5) {
// //     System.out.println("i: " + i);
// //     i++;
// // }
// //             """,
// //           ),
// //           Module(
// //             title: "Module 5: Functions and Methods",
// //             content:
// //                 "Learn how to define and call methods in Java, and how to pass arguments and return values.",
// //             codeExample: """
// // // Java method example
// // public class Main {
// //     public static void greet(String name) {
// //         System.out.println("Hello, " + name + "!");
// //     }

// //     public static void main(String[] args) {
// //         greet("Java");
// //     }
// // }
// //             """,
// //           ),
// //           Module(
// //             title: "Module 6: Arrays and Collections",
// //             content:
// //                 "Learn about arrays and how to store and manage groups of data in Java.",
// //             codeExample: """
// // // Java array example
// // int[] numbers = {1, 2, 3, 4, 5};
// // System.out.println(numbers[0]); // Output: 1

// // // Using an ArrayList
// // import java.util.ArrayList;
// // ArrayList<String> list = new ArrayList<>();
// // list.add("Java");
// // list.add("Python");
// // System.out.println(list.get(0)); // Output: Java
// //             """,
// //           ),
// //           Module(
// //             title: "Module 7: Object-Oriented Programming - Introduction",
// //             content:
// //                 "Learn the core principles of OOP: classes, objects, and methods.",
// //             codeExample: """
// // // Java class and object example
// // class Car {
// //     String make;
// //     String model;

// //     public void drive() {
// //         System.out.println("Driving " + make + " " + model);
// //     }
// // }

// // public class Main {
// //     public static void main(String[] args) {
// //         Car car = new Car();
// //         car.make = "Toyota";
// //         car.model = "Camry";
// //         car.drive();
// //     }
// // }
// //             """,
// //           ),
// //           Module(
// //             title: "Module 8: Inheritance",
// //             content:
// //                 "Learn how inheritance allows one class to inherit properties and methods from another.",
// //             codeExample: """
// // // Java inheritance example
// // class Animal {
// //     void sound() {
// //         System.out.println("Some sound");
// //     }
// // }

// // class Dog extends Animal {
// //     void sound() {
// //         System.out.println("Bark");
// //     }
// // }

// // public class Main {
// //     public static void main(String[] args) {
// //         Dog dog = new Dog();
// //         dog.sound(); // Output: Bark
// //     }
// // }
// //             """,
// //           ),
// //           Module(
// //             title: "Module 9: Polymorphism",
// //             content:
// //                 "Understand how polymorphism allows you to use objects of different classes in a unified way.",
// //             codeExample: """
// // // Java polymorphism example
// // class Animal {
// //     void sound() {
// //         System.out.println("Some sound");
// //     }
// // }

// // class Dog extends Animal {
// //     void sound() {
// //         System.out.println("Bark");
// //     }
// // }

// // public class Main {
// //     public static void main(String[] args) {
// //         Animal animal = new Dog();
// //         animal.sound(); // Output: Bark
// //     }
// // }
// //             """,
// //           ),
// //           Module(
// //             title: "Module 10: Exception Handling",
// //             content:
// //                 "Learn how to handle runtime errors using try-catch blocks in Java.",
// //             codeExample: """
// // // Java exception handling example
// // try {
// //     int result = 10 / 0;
// // } catch (ArithmeticException e) {
// //     System.out.println("Error: " + e.getMessage());
// // }
// //             """,
// //           ),
// //         ],
// //       ),
// //       Course(
// //         id: "course2",
// //         title: "Advanced Java Programming",
// //         description:
// //             "Master advanced Java concepts such as concurrency, streams, and networking. Explore libraries and frameworks used in professional development.",
// //         modules: [
// //           Module(
// //             title: "Module 1: Concurrency in Java",
// //             content:
// //                 "Learn how to work with threads and concurrency to build more efficient applications.",
// //             codeExample: """
// // // Java concurrency example using threads
// // class MyThread extends Thread {
// //     public void run() {
// //         System.out.println("Thread running");
// //     }
// // }

// // public class Main {
// //     public static void main(String[] args) {
// //         MyThread t = new MyThread();
// //         t.start();
// //     }
// // }
// //             """,
// //           ),
// //           Module(
// //             title: "Module 2: Java Streams",
// //             content:
// //                 "Learn how to use Java Streams for functional-style operations on collections.",
// //             codeExample: """
// // // Java streams example
// // import java.util.Arrays;
// // import java.util.List;

// // public class Main {
// //     public static void main(String[] args) {
// //         List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5);
// //         numbers.stream().filter(n -> n % 2 == 0).forEach(System.out::println); // Output: 2 4
// //     }
// // }
// //             """,
// //           ),
// //           // Additional modules go here...
// //         ],
// //       ),
// //     ];

// //     // Insert each course into Firestore
// //     try {
// //       for (var course in realCourses) {
// //         await _firestore.collection('courses').doc(course.id).set({
// //           'title': course.title,
// //           'description': course.description,
// //           'modules': course.modules.map((module) {
// //             return {
// //               'title': module.title,
// //               'content': module.content,
// //               'codeExample': module.codeExample,
// //             };
// //           }).toList(),
// //         });
// //         log("Inserted Course: ${course.title}");
// //       }
// //     } catch (e) {
// //       log("Error inserting real courses: $e");
// //     }
// //   }
// }
