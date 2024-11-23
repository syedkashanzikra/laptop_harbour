import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lhstore/admin/screens/category/edit_categorymodal.dart';
import 'package:lhstore/utils/helpers/customSnakbar.dart';
import '../../constants.dart';


class CategoryCard extends StatelessWidget {
  final String id; // Firebase key for the category
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const CategoryCard({
    Key? key,
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  }) : super(key: key);

  void _deleteCategory(BuildContext context) async {
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref("Categories/$id");

    try {
      // Delete category from Firebase
      await dbRef.remove();

      // Show success snackbar
      LHLoader.successSnackBar(
        title: "Success",
        message: "Category deleted successfully!",
        duration: 3,
      );
    } catch (error) {
      // Show error snackbar
      LHLoader.successSnackBar(
        title: "Error",
        message: "Failed to delete category: $error",
        duration: 3,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    icon,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(width: defaultPadding),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'Edit') {
                      showDialog(
    context: context,
    builder: (_) => EditCategoryDialog(
      id: id,
      name: title,
      description: description,
      iconCodePoint: icon.codePoint,
    ),
  );
                    } else if (value == 'Delete') {
                      _deleteCategory(context); // Call delete function
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      value: 'Edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.black54),
                          SizedBox(width: 10),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'Delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 10),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                  icon: Icon(Icons.more_vert, color: Colors.black87),
                ),
              ],
            ),
            Spacer(),
            Text(
              description.length > 50
                  ? "${description.substring(0, 47)}..." // Truncate description
                  : description,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
