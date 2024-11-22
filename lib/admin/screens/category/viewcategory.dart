import 'package:flutter/material.dart';
import 'package:lhstore/admin/responsive.dart';
import 'package:lhstore/admin/screens/category/categorycard.dart';
import 'package:lhstore/admin/screens/category/categorymodal.dart';
import '../../constants.dart';
import 'package:lhstore/admin/screens/main/components/side_menu.dart';

class ViewCategoryScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Column(
          children: [
            // Enhanced Add Button Section
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding,
                vertical: defaultPadding / 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Category Page",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showAddCategoryDialog(context); // Opens modal dialog
                    },
                    icon: Icon(Icons.add),
                    label: Text("Add Category"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(defaultPadding),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: Responsive.isMobile(context) ? 1 : 3,
                  crossAxisSpacing: defaultPadding,
                  mainAxisSpacing: defaultPadding,
                  childAspectRatio: 3 / 2,
                ),
                itemCount: 6, // Replace with your dynamic list count
                itemBuilder: (context, index) {
                  return CategoryCard(
                    icon: Icons.category, // Example icon
                    title: "Category $index",
                    description: "Description for category $index.",
                    color: Colors.blue.shade100, // Example color
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Modal Dialog for Adding a Category
  void _showAddCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AddCategoryDialog();
      },
    );
  }
}
