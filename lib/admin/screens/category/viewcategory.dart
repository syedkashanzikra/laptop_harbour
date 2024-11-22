import 'package:flutter/material.dart';
import 'package:lhstore/admin/responsive.dart';
import '../../constants.dart';
import 'package:lhstore/admin/screens/main/components/side_menu.dart';

class ViewCategoryScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Local ScaffoldKey for this screen
      drawer: SideMenu(), // Independent Drawer
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              // Add a button to open the drawer
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      // Open the drawer locally
                      if (!_scaffoldKey.currentState!.isDrawerOpen) {
                        _scaffoldKey.currentState!.openDrawer();
                      }
                    },
                  ),
                  Text(
                    "View Categories",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        CategoryCard(),
                        SizedBox(height: defaultPadding),
                        ElevatedButton.icon(
                          onPressed: () {
                            print("Add Category button clicked");
                          },
                          icon: Icon(Icons.add),
                          label: Text("Add Category"),
                        ),
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context)) ...[
                    SizedBox(width: defaultPadding),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Details Panel (Optional)",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ],
              )
            ],
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
