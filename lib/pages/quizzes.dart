import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Quizzes extends StatefulWidget {
  const Quizzes({super.key});

  @override
  State<Quizzes> createState() => _QuizzesState();
}

class _QuizzesState extends State<Quizzes> {
  bool isAdmin = false; // Track if the user is an administrator
  final TextEditingController _quizTitleController = TextEditingController();
  final TextEditingController _quizQuestionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  final List<TextEditingController> _choiceControllers = [];
  String questionType =
      'Multiple Choice'; // Track question type (Multiple Choice / True/False)

  // List of quizzes fetched from Firestore
  List<DocumentSnapshot> quizzes = [];

  @override
  void initState() {
    super.initState();
    _checkUserRole();
    _fetchQuizzes();
  }

  // Function to check user role
  Future<void> _checkUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists && userDoc['role'] == 'administrator') {
      setState(() {
        isAdmin = true; // User is an administrator
      });
    }
  }

  // Fetch quizzes from Firestore
  Future<void> _fetchQuizzes() async {
    try {
      QuerySnapshot quizSnapshot =
          await FirebaseFirestore.instance.collection('quizzes').get();

      if (mounted) {
        setState(() {
          quizzes = quizSnapshot.docs;
        });
      }
    } catch (e) {
      // Handle any errors
      log('Error fetching quizzes: $e');
    }
  }

  // Function for 'Add' action
  void _addQuiz() async {
    if (_quizTitleController.text.isNotEmpty &&
        _quizQuestionController.text.isNotEmpty &&
        _answerController.text.isNotEmpty) {
      var choices = [];
      if (questionType == 'Multiple Choice') {
        choices =
            _choiceControllers.map((controller) => controller.text).toList();
      }

      await FirebaseFirestore.instance.collection('quizzes').add({
        'title': _quizTitleController.text,
        'question': _quizQuestionController.text,
        'questionType': questionType,
        'choices': choices,
        'answer': _answerController.text,
        'created_at': Timestamp.now(),
      });

      // Clear the input fields
      _quizTitleController.clear();
      _quizQuestionController.clear();
      _answerController.clear();
      _choiceControllers.forEach((controller) => controller.clear());
      _choiceControllers.clear();

      // Fetch updated quizzes
      _fetchQuizzes();
    } else {
      showDialog(
        context: context, 
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text("Error", style: TextStyle(color: Colors.red),),
            content: const Text("Please fill in all fields."),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                }, 
                child: Text("Okay")
              ),
            ],
          );
        } 
      );
    }
  }

  // Function for 'Delete' action with confirmation
  void _deleteQuiz(String quizId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Quiz"),
          content: const Text("Are you sure you want to delete this quiz?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without deleting
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () async {
                // Delete the quiz if confirmed
                await FirebaseFirestore.instance
                    .collection('quizzes')
                    .doc(quizId)
                    .delete();

                // Fetch updated quizzes
                _fetchQuizzes();
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  // Function for 'Edit' action with confirmation
  void _editQuiz(String quizId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Quiz"),
          content: const Text("Are you sure you want to edit this quiz?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without editing
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                // Implement the editing functionality here
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  // Pull-to-refresh functionality
  Future<void> _onRefresh() async {
    await _fetchQuizzes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quizzes Questions"),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                if (quizzes.isEmpty) const Text("No quizzes available."),
                for (var quiz in quizzes)
                  GestureDetector(
                    onTap: () {
                      // Add functionality to handle quiz item tap
                      // This can navigate to a quiz details page or show details in a dialog
                      log("Something here");
                    },
                    child: ListTile(
                      title: Text(quiz['title']),
                      subtitle: Text(quiz['question']),
                      trailing: isAdmin
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  tooltip: 'Edit',
                                  onPressed: () => _editQuiz(quiz.id),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  tooltip: 'Delete',
                                  onPressed: () => _deleteQuiz(quiz.id),
                                ),
                              ],
                            )
                          : null,
                    ),
                  ),
                if (quizzes.length >
                    5) // Make sure it's scrollable if enough quizzes exist
                  const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: _showAddQuizDialog,
              tooltip: 'Add Quiz',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  // Show dialog to add quiz
  void _showAddQuizDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Quiz"),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    children: [
                      TextField(
                        controller: _quizTitleController,
                        decoration:
                            const InputDecoration(labelText: 'Quiz Title'),
                      ),
                      TextField(
                        controller: _quizQuestionController,
                        decoration:
                            const InputDecoration(labelText: 'Quiz Question'),
                      ),
                      // Question Type (Multiple Choice / True/False)
                      DropdownButton<String>(
                        value: questionType,
                        items: <String>['Multiple Choice', 'True/False']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            questionType = newValue!;
                          });
                        },
                      ),
                      if (questionType == 'Multiple Choice') ...[
                        // Display multiple choice options
                        ...List.generate(4, (index) {
                          // Reset controllers if changing question type
                          if (_choiceControllers.length < 4) {
                            _choiceControllers.add(TextEditingController());
                          }
                          return TextField(
                            controller: _choiceControllers[index],
                            decoration: InputDecoration(
                                labelText: 'Choice ${index + 1}'),
                          );
                        }),
                      ],
                      TextField(
                        controller: _answerController,
                        decoration: const InputDecoration(labelText: 'Answer'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: _addQuiz,
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
