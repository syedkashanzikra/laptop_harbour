import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:firebase_database/firebase_database.dart'; // Import Firebase Realtime Database

class AddCategoryDialog extends StatefulWidget {
  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  IconData? selectedIcon; // Stores the selected icon
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final DatabaseReference dbRef =
      FirebaseDatabase.instance.ref("Categories"); // Reference to Firebase DB

  void _pickIcon() async {
    IconPickerIcon? icon = await showIconPicker(
      context,
      configuration: SinglePickerConfiguration(
        iconPackModes: [IconPack.material],
      ),
    );

    if (icon != null) {
      setState(() {
        selectedIcon = icon.data; // Use the selected icon
      });
    }
  }

  void _addCategory() async {
    // Ensure required fields are filled
    if (nameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        selectedIcon == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all fields and select an icon"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Add category to Firebase Realtime Database
    try {
      await dbRef.push().set({
        "name": nameController.text,
        "description": descriptionController.text,
        "icon": selectedIcon!.codePoint, // Store icon's codePoint
      });

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Category added successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      // Clear fields and close dialog
      nameController.clear();
      descriptionController.clear();
      setState(() {
        selectedIcon = null;
      });

      Navigator.pop(context);
    } catch (error) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to add category: $error"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Add Category",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: _pickIcon,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue.shade50,
                  child: Icon(
                    selectedIcon ?? Icons.add,
                    size: 50,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(height: 20),
              FormBuilderTextField(
                name: "categoryName",
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Category Name",
                  floatingLabelStyle: TextStyle(
                    color: Colors.black, // Keep label black when focused
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
              ),
              SizedBox(height: 16),
              FormBuilderTextField(
                name: "categoryDescription",
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Category Description",
                  floatingLabelStyle: TextStyle(
                    color: Colors.black, // Keep label black when focused
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addCategory, // Call _addCategory on button press
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 30,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text("Add Category"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
