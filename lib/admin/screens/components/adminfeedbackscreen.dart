import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lhstore/utils/helpers/customSnakbar.dart';

class AdminViewFeedback extends StatefulWidget {
  @override
  _AdminViewFeedbackState createState() => _AdminViewFeedbackState();
}

class _AdminViewFeedbackState extends State<AdminViewFeedback> {
  final CollectionReference feedbackCollection = FirebaseFirestore.instance
      .collection('feedback'); // Firestore collection reference

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin View Feedback"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: feedbackCollection.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text("No feedback available."));
              }

              // Map Firestore data
              final feedbackList = snapshot.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return {
                  'id': doc.id,
                  'name': data['name'],
                  'email': data['email'],
                  'subject': data['subject'],
                  'message': data['message'],
                  'rating': data['rating'],
                  'timestamp': data['timestamp'],
                };
              }).toList();

              return SingleChildScrollView(
                scrollDirection:
                    Axis.horizontal, // Horizontal scrolling for responsiveness
                child: DataTable(
                  columns: [
                    DataColumn(label: Text("Name")),
                    DataColumn(label: Text("Email")),
                    DataColumn(label: Text("Actions")),
                  ],
                  rows: feedbackList.map((feedback) {
                    return DataRow(
                      cells: [
                        DataCell(Text(feedback['name'] ?? "")),
                        DataCell(Text(feedback['email'] ?? "")),
                        DataCell(
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'view') {
                                _showFeedbackDetails(context, feedback);
                              } else if (value == 'delete') {
                                _deleteFeedback(context, feedback['id']);
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
        ),
      ),
    );
  }

  void _showFeedbackDetails(
      BuildContext context, Map<String, dynamic> feedback) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Feedback Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Subject: ${feedback['subject']}"),
              SizedBox(height: 10),
              Text("Message: ${feedback['message']}"),
              SizedBox(height: 10),
              Text("Rating: ${feedback['rating']}"),
              SizedBox(height: 10),
              Text("Timestamp: ${feedback['timestamp']}"),
            ],
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

  void _deleteFeedback(BuildContext context, String feedbackId) {
    // Show a confirmation dialog before deleting
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Feedback"),
          content: Text("Are you sure you want to delete this feedback?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel deletion
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                feedbackCollection.doc(feedbackId).delete().then((_) {
                  LHLoader.successSnackBar(
                    title: "Success",
                    message: "Feedback deleted successfully!",
                    duration: 3,
                  );
                  Navigator.pop(context); // Close dialog
                }).catchError((error) {
                  LHLoader.ErrorSnackBar(
                    title: "Error",
                    message: "Failed to delete feedback: ${error.toString()}",
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
