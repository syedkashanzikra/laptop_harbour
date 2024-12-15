import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lhstore/admin/constants.dart';
import 'package:lhstore/admin/responsive.dart';
import 'package:lhstore/admin/screens/main/components/side_menu.dart';

class AdminProfileScreen extends StatefulWidget {
  @override
  _AdminProfileScreenState createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Map<String, dynamic> userDetails = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAdminDetails();
  }

  // Fetch admin user details from Firestore
  void _fetchAdminDetails() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        String userId = currentUser.uid;

        // Fetch data from Firestore "Users" collection
        DocumentSnapshot snapshot =
            await FirebaseFirestore.instance.collection("Users").doc(userId).get();

        if (snapshot.exists) {
          setState(() {
            userDetails = snapshot.data() as Map<String, dynamic>;
            isLoading = false;
          });
        } else {
          print("User details not found in Firestore!");
          setState(() => isLoading = false);
        }
      }
    } catch (e) {
      print("Error fetching user details: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding,
                vertical: defaultPadding / 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!Responsive.isDesktop(context)) // Show menu icon on small screens
                    IconButton(
                      icon: Icon(Icons.menu, color: Colors.black),
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                    ),
                  Text(
                    "Admin Profile",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                  ),
                ],
              ),
            ),
            isLoading
                ? Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(defaultPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: Icon(Icons.person, size: 40, color: Colors.blue),
                                title: Text(
                                  userDetails["FirstName"] ?? "N/A",
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  userDetails["Email"] ?? "N/A",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Profile Details",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Divider(),
                              _buildDetailRow("Full Name",
                                  "${userDetails["FirstName"] ?? ""} ${userDetails["LastName"] ?? ""}"),
                              _buildDetailRow("Email", userDetails["Email"]),
                              _buildDetailRow("Phone", userDetails["PhoneNumber"]),
                              _buildDetailRow("User Name", userDetails["UserName"]),
                              _buildDetailRow(
                                  "Admin Status",
                                  userDetails["_isAdmin"] == true
                                      ? "Yes"
                                      : "No"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            value ?? "N/A",
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
