import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lhstore/admin/responsive.dart';
import 'package:lhstore/admin/screens/category/categorycard.dart';
import 'package:lhstore/admin/screens/category/categorymodal.dart';
import '../../constants.dart';
import 'package:lhstore/admin/screens/main/components/side_menu.dart';

class ViewCategoryScreen extends StatefulWidget {
  @override
  _ViewCategoryScreenState createState() => _ViewCategoryScreenState();
}

class _ViewCategoryScreenState extends State<ViewCategoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DatabaseReference dbRef =
      FirebaseDatabase.instance.ref("Categories"); // Firebase reference

  List<Map<String, dynamic>> categories = []; // Stores fetched categories

  @override
  void initState() {
    super.initState();
    _fetchCategories(); // Fetch categories on initialization
  }

  void _fetchCategories() {
    dbRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        final List<Map<String, dynamic>> fetchedCategories = [];
        data.forEach((key, value) {
          fetchedCategories.add({
            "id": key,
            "name": value["name"],
            "description": value["description"],
            "icon": value["icon"],
          });
        });

        setState(() {
          categories = fetchedCategories;
        });
      }
    });
  }

  void _showAddCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AddCategoryDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Column(
          children: [
            // Add Button Section
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
                      _showAddCategoryDialog(context);
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
                itemCount: categories.length, // Dynamically set item count
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return CategoryCard(
                    icon: IconData(
                      category["icon"],
                      fontFamily: 'MaterialIcons',
                    ), // Use fetched icon
                    title: category["name"],
                    description: category["description"],
                    color: Colors.blue.shade100, // Set card background color
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
