import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course.dart';

class AddModules extends StatefulWidget {
  final String courseId;

  const AddModules(this.courseId, {Key? key}) : super(key: key);

  @override
  State<AddModules> createState() => _AddModulesState();
}

class _AddModulesState extends State<AddModules> {
  final TextEditingController _moduleTitleController = TextEditingController();
  final TextEditingController _moduleContentController = TextEditingController();
  final TextEditingController _moduleCodeExampleController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Module> _modules = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Modules",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add New Module",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            _buildModuleInputs(),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addModule,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              ),
              child: const Text("Add Module", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 16.0),
            const Divider(thickness: 1.5),
            const Text(
              "Modules List",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            _buildModulesList(),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveModulesToDatabase,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              ),
              child: const Text("Save All to Database", style: TextStyle(color: Colors.white)),
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
          decoration: const InputDecoration(
            labelText: "Module Title",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8.0),
        TextField(
          controller: _moduleContentController,
          decoration: const InputDecoration(
            labelText: "Module Content",
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 8.0),
        TextField(
          controller: _moduleCodeExampleController,
          decoration: const InputDecoration(
            labelText: "Code Example",
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildModulesList() {
    if (_modules.isEmpty) {
      return const Center(
        child: Text(
          "No modules added yet.",
          style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _modules.length,
      itemBuilder: (context, index) {
        final module = _modules[index];
        return Column(
          children: [
            ListTile(
              title: Text(module.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                module.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteModule(index),
              ),
            ),
            const Divider(),
          ],
        );
      },
    );
  }

  void _addModule() {
    if (_moduleTitleController.text.isEmpty ||
        _moduleContentController.text.isEmpty ||
        _moduleCodeExampleController.text.isEmpty) {
      _showDialog("All fields are required to save a module.");
      return;
    }

    setState(() {
      _modules.add(
        Module(
          title: _moduleTitleController.text.trim(),
          content: _moduleContentController.text.trim(),
          codeExample: _moduleCodeExampleController.text.trim(),
        ),
      );
    });

    _moduleTitleController.clear();
    _moduleContentController.clear();
    _moduleCodeExampleController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Module added successfully!")),
    );
  }

  void _deleteModule(int index) {
    setState(() {
      _modules.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Module deleted successfully!")),
    );
  }

  Future<void> _saveModulesToDatabase() async {
    if (_modules.isEmpty) {
      _showDialog("No modules to save.");
      return;
    }

    try {
      final courseRef = _firestore.collection('courses').doc(widget.courseId);
      await courseRef.update({
        'modules': FieldValue.arrayUnion(
          _modules.map((module) {
            return {
              'title': module.title,
              'content': module.content,
              'codeExample': module.codeExample,
            };
          }).toList(),
        ),
      });

      log("Modules saved to Firestore!");
      _showDialog("Modules saved successfully!", isSuccess: true);
    } catch (e) {
      log("Error saving modules: $e");
      _showDialog("Failed to save modules.");
    }
  }

  void _showDialog(String message, {bool isSuccess = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isSuccess ? "Success" : "Error"),
          content: Text(message, style: const TextStyle(fontSize: 18.0)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
