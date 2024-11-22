import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lhstore/admin/responsive.dart';
import 'package:lhstore/admin/screens/dashboard/components/header.dart';
import '../../constants.dart';
import '../../controllers/menu_app_controller.dart';

class ViewCategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MenuAppController(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            primary: false,
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                Header(),
                SizedBox(height: defaultPadding),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          // Add the category card layout
                          CategoryCard(),
                          SizedBox(height: defaultPadding),
                          // Add the "Add Category" button
                          ElevatedButton.icon(
                            onPressed: () {
                              // Add the functionality for adding categories
                              print("Add Category button clicked");
                            },
                            icon: Icon(Icons.add),
                            label: Text("Add Category"),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!Responsive.isMobile(context))
                      SizedBox(width: defaultPadding),
                    if (!Responsive.isMobile(context))
                      Expanded(
                        flex: 2,
                        child: Container(
                          // Optionally add additional content for larger screens
                          child: Text(
                            "Details Panel (Optional)",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Category Name",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Description of the category or additional details can go here.",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
