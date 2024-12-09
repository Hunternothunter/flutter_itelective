import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentLists extends StatefulWidget {
  const StudentLists({Key? key}) : super(key: key);

  @override
  State<StudentLists> createState() => _StudentListsState();
}

class _StudentListsState extends State<StudentLists> {
  late Future<List<Map<String, dynamic>>> _userListFuture;
  List<Map<String, dynamic>> _allUsers = [];
  List<Map<String, dynamic>> _filteredUsers = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _userListFuture = fetchUsers();
  }

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    try {
      // Fetch users with the role of 'User' from Firestore
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'User')
          .get();

      return snapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
    } catch (e) {
      debugPrint('Error fetching users: $e');
      return [];
    }
  }

  Future<void> onRefresh() async {
    setState(() {
      _userListFuture = fetchUsers();
    });
  }

  void _filterUsers(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredUsers = _allUsers.where((user) {
        final firstname = user['firstname']?.toLowerCase() ?? '';
        final lastname = user['lastname']?.toLowerCase() ?? '';
        final email = user['email']?.toLowerCase() ?? '';
        final username = user['username']?.toLowerCase() ?? '';
        return firstname.contains(_searchQuery) ||
            lastname.contains(_searchQuery) ||
            email.contains(_searchQuery) ||
            username.contains(_searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Lists',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _userListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No students found.'));
          } else {
            _allUsers = snapshot.data!;
            _filteredUsers = _searchQuery.isEmpty ? _allUsers : _filteredUsers;

            return RefreshIndicator(
              onRefresh: onRefresh,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Search',
                        hintText: 'Search by name, email, or username',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 12.0),
                      ),
                      onChanged: _filterUsers,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = _filteredUsers[index];
                        // Wrap the ListTile and Divider inside a Column to show the divider after each item.
                        return Column(
                          children: [
                            ListTile(
                              title: Text(
                                  '${user['firstname']} ${user['lastname']}'),
                              subtitle: Text(user['email'] ?? 'No Email'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UserDetailsPage(user: user),
                                  ),
                                );
                              },
                            ),
                            // Divider after each ListTile except the last one
                            if (index < _filteredUsers.length - 1)
                              const Divider(),
                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class UserDetailsPage extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserDetailsPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Personal Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name field
            const SizedBox(height: 10),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Name:',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Expanded(
                  child: Text(
                    '${user['firstname']} ${user['lastname'] ?? ''}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
              ],
            ),
            const Divider(), // Line after Name field
            const SizedBox(height: 10),
            // Username field
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Username:',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Expanded(
                  child: Text(
                    user['username'] ?? 'No Username',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
              ],
            ),
            const Divider(), // Line after Username field
            const SizedBox(height: 10),
            // Email field
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Adds space between the label and the email
              children: [
                Container(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    'Email: ',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.start,
                  ),
                ),
                Expanded(
                  child: Text(
                    user['email'] ?? 'No Email',
                    style: const TextStyle(fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 10),
            // Role field
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Role:',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Expanded(
                  child: Text(
                    user['role'] ?? 'No Role',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
              ],
            ),
            const Divider(), // Line after Role field
          ],
        ),
      ),
    );
  }
}
