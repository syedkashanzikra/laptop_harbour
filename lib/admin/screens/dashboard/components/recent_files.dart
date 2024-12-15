import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecentFiles extends StatefulWidget {
  const RecentFiles({Key? key}) : super(key: key);

  @override
  _RecentFilesState createState() => _RecentFilesState();
}

class _RecentFilesState extends State<RecentFiles> {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Latest users list
  List<Map<String, dynamic>> latestUsers = [];

  @override
  void initState() {
    super.initState();
    fetchLatestUsers();
  }

  @override
  void dispose() {
    // Always call super.dispose
    super.dispose();
  }

  // Fetch latest 6 users from Firestore
  Future<void> fetchLatestUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('Users') // Firestore collection name
          .limit(6) // Fetch latest 6 users
          .get();

      if (mounted) {
        setState(() {
          latestUsers = querySnapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
        });
      }
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Recent Users",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ), // Old theme (Material 2)
                ),
                SizedBox(height: 16.0),
                latestUsers.isEmpty
                    ? Center(
                        child: Text(
                          "No users found",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: constraints.maxWidth,
                          ),
                          child: DataTable(
                            columnSpacing: 16.0,
                            dataRowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.black54),
                            headingRowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.black87),
                            headingTextStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            columns: [
                              DataColumn(
                                  label: Text("Email",
                                      style: TextStyle(color: Colors.white))),
                              DataColumn(
                                  label: Text("First Name",
                                      style: TextStyle(color: Colors.white))),
                              DataColumn(
                                  label: Text("Last Name",
                                      style: TextStyle(color: Colors.white))),
                              DataColumn(
                                  label: Text("Admin",
                                      style: TextStyle(color: Colors.white))),
                            ],
                            rows: latestUsers.map((user) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(user['Email'] ?? 'N/A',
                                      style: TextStyle(color: Colors.white))),
                                  DataCell(Text(user['FirstName'] ?? 'N/A',
                                      style: TextStyle(color: Colors.white))),
                                  DataCell(Text(user['LastName'] ?? 'N/A',
                                      style: TextStyle(color: Colors.white))),
                                  DataCell(Text(
                                      user['_isAdmin'] == true
                                          ? "Yes"
                                          : "No",
                                      style: TextStyle(color: Colors.white))),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
