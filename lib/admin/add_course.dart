import 'package:flutter/material.dart';
import 'dart:developer';
import '../models/course.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCourse extends StatefulWidget {
  const AddCourse({super.key});

  @override
  State<AddCourse> createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _instructorController = TextEditingController();

  List<Module> _modules = [];
  final _moduleTitleController = TextEditingController();
  final _moduleContentController = TextEditingController();
  final _moduleCodeExampleController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isModuleEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Course", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Course Title"),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Course Description"),
              maxLines: 3,
            ),
            TextField(
              controller: _instructorController,
              decoration: const InputDecoration(labelText: "Instructor"),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Checkbox(
                  value: _isModuleEnabled,
                  onChanged: (bool? value) {
                    setState(() {
                      _isModuleEnabled = value ?? false;
                    });
                  },
                ),
                const Text("Add Modules"),
              ],
            ),
            if (_isModuleEnabled) ...[
              const SizedBox(height: 16.0),
              const Text("Modules", style: TextStyle(fontSize: 18.0)),
              const SizedBox(height: 8.0),
              _buildModuleInputs(),
            ],
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addCourse,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0), backgroundColor: Colors.blue,
                textStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold), // Button color
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              ),
              child: const Text("Add Course", style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleInputs() {
    return Column(
      children: [
        TextField(
          controller: _moduleTitleController,
          decoration: const InputDecoration(labelText: "Module Title"),
        ),
        TextField(
          controller: _moduleContentController,
          decoration: const InputDecoration(labelText: "Module Content"),
          maxLines: 3,
        ),
        TextField(
          controller: _moduleCodeExampleController,
          decoration: const InputDecoration(labelText: "Code Example"),
        ),
        const SizedBox(height: 8.0),
        ElevatedButton(
          onPressed: _addModule,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0), backgroundColor: Colors.green,
            textStyle: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold), // Button color
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          child: const Text("Save Module", style: TextStyle(color: Colors.white),),
        ),
        const SizedBox(height: 16.0),
        // Display added modules with a separator
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _modules.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  title: Text(_modules[index].title),
                  subtitle: Text(_modules[index].content),
                ),
                const Divider(), // Adds a separator between modules
              ],
            );
          },
        ),
      ],
    );
  }

  void _addModule() {
    if (_moduleTitleController.text.isEmpty ||
        _moduleContentController.text.isEmpty ||
        _moduleCodeExampleController.text.isEmpty) {
      _showDialog("Please fill all module fields");
      return;
    }

    final module = Module(
      title: _moduleTitleController.text,
      content: _moduleContentController.text,
      codeExample: _moduleCodeExampleController.text,
    );

    setState(() {
      _modules.add(module);
    });

    // Clear input fields for the next module
    _moduleTitleController.clear();
    _moduleContentController.clear();
    _moduleCodeExampleController.clear();
  }

  Future<void> _addCourse() async {
    if (_titleController.text.isEmpty) {
      _showDialog("Course title is required");
      return;
    }

    if (_descriptionController.text.isEmpty) {
      _showDialog("Course description is required");
      return;
    }

    if (_instructorController.text.isEmpty) {
      _showDialog("Instructor is required");
      return;
    }

    if (_isModuleEnabled && _modules.isEmpty) {
      _showDialog("At least one module is required");
      return;
    }

    // Check if the course title and description already exist in the Firestore database
    final coursesSnapshot = await _firestore.collection('courses')
        .where('title', isEqualTo: _titleController.text)
        .where('description', isEqualTo: _descriptionController.text)
        .get();

    if (coursesSnapshot.docs.isNotEmpty) {
      _showDialog("A course with the same title and description already exists.");
      return;
    }

    final course = Course(
      id: DateTime.now().toString(),
      title: _titleController.text,
      description: _descriptionController.text,
      instructor: _instructorController.text,
      modules: _modules,
    );

    try {
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
      log("Course added successfully!");
      Navigator.pop(context);
      _showDialog("Course added successfully!", isSuccess: true);
    } catch (e) {
      log("Error adding course: $e");
      _showDialog("Error adding course");
    }
  }

  void _showDialog(String message, {bool isSuccess = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isSuccess ? "Success" : "Error"),
          content: Text(message, style: TextStyle(fontSize: 18.0),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
