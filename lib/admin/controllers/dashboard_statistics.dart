import 'package:firebase_database/firebase_database.dart';

class DashboardStatistics {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  /// Fetch total number of users
  Future<int> getTotalUsers() async {
    try {
      final DataSnapshot snapshot = await _dbRef.child("Users").get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>?;
        return data?.length ?? 0; // Return total users count
      }
      return 0; // No users
    } catch (error) {
      print("Error fetching total users: $error");
      return 0;
    }
  }

  /// Fetch total number of categories
  Future<int> getTotalCategories() async {
    try {
      final DataSnapshot snapshot = await _dbRef.child("Categories").get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>?;
        return data?.length ?? 0; // Return total categories count
      }
      return 0; // No categories
    } catch (error) {
      print("Error fetching total categories: $error");
      return 0;
    }
  }
}
