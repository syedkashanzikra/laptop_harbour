import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:lhstore/admin/responsive.dart';
import 'package:lhstore/utils/helpers/customSnakbar.dart';

class AdminViewUsers extends StatefulWidget {
  @override
  _AdminViewUsersState createState() => _AdminViewUsersState();
}

class _AdminViewUsersState extends State<AdminViewUsers> {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users'); // Firestore reference

  final FirebaseAuth _auth = FirebaseAuth.instance; // FirebaseAuth instance

  String? currentAdminEmail;

  @override
  void initState() {
    super.initState();
    // Get the logged-in admin's email
    currentAdminEmail = _auth.currentUser?.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin View Users"),
      ),
      body: SafeArea(
        child: Responsive(
          mobile: _buildUsersTable(context, isDesktop: false),
          tablet: _buildUsersTable(context, isDesktop: false),
          desktop: _buildUsersTable(context, isDesktop: true),
        ),
      ),
    );
  }

  Widget _buildUsersTable(BuildContext context, {required bool isDesktop}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: usersCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No users available."));
          }

          // Map Firestore data, excluding the current admin
          final userList = snapshot.data!.docs
              .map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return {
                  'id': doc.id,
                  'firstName': data['FirstName'],
                  'lastName': data['LastName'],
                  'email': data['Email'],
                  'userName': data['UserName'],
                  'phoneNumber': data['PhoneNumber'],
                  'address': data['Address'],
                  'profilePicture': data['ProfilePicture'],
                  '_isAdmin': data['_isAdmin'],
                };
              })
              .where((user) => user['email'] != currentAdminEmail) // Exclude logged-in admin
              .toList();

          return SingleChildScrollView(
            scrollDirection: isDesktop ? Axis.vertical : Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text("First Name")),
                DataColumn(label: Text("Email")),
                DataColumn(label: Text("Actions")),
              ],
              rows: userList.map((user) {
                return DataRow(
                  cells: [
                    DataCell(Text(user['firstName'] ?? "")),
                    DataCell(Text(user['email'] ?? "")),
                    DataCell(
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'view') {
                            _showUserDetails(context, user);
                          } else if (value == 'delete') {
                            _deleteUser(context, user['id']);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'view',
                            child: Text("View"),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Text("Delete"),
                          ),
                        ],
                        child: Icon(Icons.more_vert), // Kebab menu icon
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  void _showUserDetails(BuildContext context, Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("User Details"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("First Name: ${user['firstName']}"),
                SizedBox(height: 10),
                Text("Last Name: ${user['lastName']}"),
                SizedBox(height: 10),
                Text("Email: ${user['email']}"),
                SizedBox(height: 10),
                Text("User Name: ${user['userName']}"),
                SizedBox(height: 10),
                Text("Phone Number: ${user['phoneNumber']}"),
                SizedBox(height: 10),
                Text("Address: ${user['address']}"),
                SizedBox(height: 10),
                Text("Is Admin: ${user['_isAdmin'] ? "Yes" : "No"}"),
                SizedBox(height: 10),
                user['profilePicture'] != null &&
                        user['profilePicture'].isNotEmpty
                    ? Image.network(user['profilePicture'],
                        height: 100, width: 100)
                    : Text("No Profile Picture"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(BuildContext context, String userId) {
    // Show a confirmation dialog before deleting
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete User"),
          content: Text("Are you sure you want to delete this user?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel deletion
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                usersCollection.doc(userId).delete().then((_) {
                  LHLoader.successSnackBar(
                    title: "Success",
                    message: "User deleted successfully!",
                    duration: 3,
                  );
                  Navigator.pop(context); // Close dialog
                }).catchError((error) {
                  LHLoader.ErrorSnackBar(
                    title: "Error",
                    message: "Failed to delete user: ${error.toString()}",
                    duration: 3,
                  );
                  Navigator.pop(context); // Close dialog
                });
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
