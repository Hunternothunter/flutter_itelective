import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RecordList extends StatefulWidget {
  const RecordList({super.key});

  @override
  State<RecordList> createState() => _RecordListState();
}

class _RecordListState extends State<RecordList> {
  // List to store records fetched from Firebase
  List<Map<dynamic, dynamic>> _records = [];

  @override
  void initState() {
    super.initState();
    _fetchRecordsFromFirebase();
  }

  // Fetch records from Firebase Realtime Database
  Future<void> _fetchRecordsFromFirebase() async {
    // Reference to the "users" node in Firebase
    DatabaseReference recordRef = FirebaseDatabase.instance.ref('users');
    final snapshot = await recordRef.get();

    if (snapshot.exists) {
      final recordsData = snapshot.value as Map<dynamic, dynamic>;
      List<Map<dynamic, dynamic>> fetchedRecords = [];

      // Loop through each user in the database and fetch their details
      recordsData.forEach((key, value) {
        fetchedRecords
            .add(value); // Add each user record (with name, email, password)
      });

      // Update the UI with the fetched data
      setState(() {
        _records = fetchedRecords;
      });
    } else {
      log('No records found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "User Records",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        backgroundColor: const Color.fromARGB(255, 36, 209, 42),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: _records.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              ) // Show loading while data is fetched
            : ListView.builder(
                itemCount: _records.length,
                itemBuilder: (context, index) {
                  final record = _records[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: ListTile(
                      title: Text(
                        record['name'] ?? 'No Name', // Display record's name
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email: ${record['email'] ?? 'No Email'}'),
                          Text(
                              'Password: ${record['password'] ?? 'No Password'}'),
                        ],
                      ),
                      onTap: () {
                        // You can add an action on tap, such as navigating to a detail screen
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
