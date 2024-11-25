import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lhstore/utils/helpers/customSnakbar.dart';

class ProductAdminCard extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final String imageUrl; // Image URL for the product
  final double price;
  final VoidCallback onDelete; // Callback for delete action

  const ProductAdminCard({
    Key? key,
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.onDelete,
  }) : super(key: key);

  // Method to delete product from Firebase
  Future<void> _deleteProduct(BuildContext context) async {
    try {
      final dbRef = FirebaseDatabase.instance.ref("Products").child(id); // Reference to the product
      await dbRef.remove(); // Delete the product from Firebase
      LHLoader.successSnackBar(title: "Success", message: "Product deleted successfully");
      onDelete(); // Notify parent widget
    } catch (e) {
      LHLoader.ErrorSnackBar(title: "Error", message: "Failed to delete product: $e");
    }
  }

  // Method to show delete confirmation dialog
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Product"),
          content: Text("Are you sure you want to delete this product?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close dialog
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _deleteProduct(context); // Perform delete
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      "\$${price.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 8,
            right: 8,
            child: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: Colors.black87),
              onSelected: (value) {
                if (value == "delete") {
                  _showDeleteConfirmationDialog(context); // Show confirmation dialog
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  value: "delete",
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text("Delete"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
