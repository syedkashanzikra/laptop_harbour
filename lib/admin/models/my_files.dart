import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart'; // Import for Realtime Database
import 'package:lhstore/admin/constants.dart';
import 'package:flutter/material.dart';

class CloudStorageInfo {
  final String? svgSrc, title, totalStorage;
  final int? numOfFiles, percentage;
  final Color? color;

  CloudStorageInfo({
    this.svgSrc,
    this.title,
    this.totalStorage,
    this.numOfFiles,
    this.percentage,
    this.color,
  });
}

// Function to fetch Firestore collection count in real-time
Stream<int> fetchFirestoreCollectionCount(String collectionName) {
  return FirebaseFirestore.instance.collection(collectionName).snapshots().map(
        (snapshot) => snapshot.size,
      );
}

// Function to fetch Realtime Database count in real-time
Stream<int> fetchRealtimeDatabaseCount(String nodeName) {
  return FirebaseDatabase.instance
      .ref(nodeName)
      .onValue
      .map((event) => (event.snapshot.value as Map?)?.length ?? 0);
}

// Function to populate the list dynamically in real-time
Stream<List<CloudStorageInfo>> fetchDemoMyFilesStream() async* {
  final usersStream = fetchFirestoreCollectionCount('Users'); // Firestore
  final feedbackStream = fetchFirestoreCollectionCount('feedback'); // Firestore
  final productsStream = fetchRealtimeDatabaseCount('Products'); // Realtime DB
  final categoriesStream = fetchRealtimeDatabaseCount('Categories'); // Realtime DB

  // Combine all streams to emit updates as a single list
  await for (var users in usersStream) {
    await for (var products in productsStream) {
      await for (var categories in categoriesStream) {
        await for (var feedback in feedbackStream) {
          yield [
            CloudStorageInfo(
              title: "Users",
              numOfFiles: users,
              svgSrc: "assets/icons/Documents.svg",
              totalStorage: "$users Users",
              color: primaryColor,
              percentage: 35,
            ),
            CloudStorageInfo(
              title: "Products",
              numOfFiles: products,
              svgSrc: "assets/icons/google_drive.svg",
              totalStorage: "$products Products",
              color: Color(0xFFFFA113),
              percentage: 50,
            ),
            CloudStorageInfo(
              title: "Categories",
              numOfFiles: categories,
              svgSrc: "assets/icons/one_drive.svg",
              totalStorage: "$categories Categories",
              color: Color(0xFFA4CDFF),
              percentage: 25,
            ),
            CloudStorageInfo(
              title: "Feedback",
              numOfFiles: feedback,
              svgSrc: "assets/icons/drop_box.svg",
              totalStorage: "$feedback Feedback",
              color: Color(0xFF007EE5),
              percentage: 15,
            ),
          ];
        }
      }
    }
  }
}
