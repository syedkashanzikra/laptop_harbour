import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lhstore/utils/helpers/customSnakbar.dart';

class EditCategoryDialog extends StatefulWidget {
  final String id; // Category ID (Firebase key)
  final String name;
  final String description;
  final int iconCodePoint;

  EditCategoryDialog({
    required this.id,
    required this.name,
    required this.description,
    required this.iconCodePoint,
  });

  @override
  _EditCategoryDialogState createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  IconData? selectedIcon;

  final DatabaseReference dbRef =
      FirebaseDatabase.instance.ref("Categories"); // Reference to Firebase DB

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current category data
    nameController = TextEditingController(text: widget.name);
    descriptionController = TextEditingController(text: widget.description);
    selectedIcon = IconData(widget.iconCodePoint, fontFamily: 'MaterialIcons');
  }

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

  void _updateCategory() async {
    // Ensure required fields are filled
    if (nameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        selectedIcon == null) {
      LHLoader.successSnackBar(
        title: "Error",
        message: "Please fill all fields and select an icon",
        duration: 3,
      );
      return;
    }

    try {
      // Update category in Firebase Realtime Database
      await dbRef.child(widget.id).update({
        "name": nameController.text,
        "description": descriptionController.text,
        "icon": selectedIcon!.codePoint, // Store icon's codePoint
      });

      // Show success snackbar
      LHLoader.successSnackBar(
        title: "Success",
        message: "Category updated successfully!",
        duration: 3,
      );

      Navigator.pop(context); // Close the dialog
    } catch (error) {
      // Show error snackbar
      LHLoader.successSnackBar(
        title: "Error",
        message: "Failed to update category: $error",
        duration: 3,
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
                "Edit Category",
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
                onPressed: _updateCategory, // Call _updateCategory on button press
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 30,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text("Update Category"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
