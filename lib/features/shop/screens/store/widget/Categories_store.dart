import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lhstore/utils/constants/colors.dart';

class CategoriesStore extends StatefulWidget {
  const CategoriesStore({Key? key}) : super(key: key);

  @override
  _CategoriesStoreState createState() => _CategoriesStoreState();
}

class _CategoriesStoreState extends State<CategoriesStore> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('Categories');

  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  void _fetchCategories() {
    _databaseReference.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        final List<Map<String, dynamic>> loadedCategories = [];
        data.forEach((key, value) {
          loadedCategories.add({
            'id': key,
            'name': value['name'] ?? 'No Name',
            'description': value['description'] ?? 'No Description',
            'icon': value['icon'] ?? 0xE0B0, // Default icon code
          });
        });
        setState(() {
          _categories = loadedCategories;
        });
      } else {
        setState(() {
          _categories = [];
        });
      }
    });
  }

  Widget buildCategoryCard(BuildContext context, String name, String description, int iconCode) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: LHColor.grey,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            IconData(iconCode, fontFamily: 'MaterialIcons'),
            size: 50,
            color: LHColor.darkGrey,
          ),
          const SizedBox(height: 8.0),
          Text(
            name,
            style: Theme.of(context).textTheme.titleMedium!.apply(color: LHColor.darkGrey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4.0),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall!.apply(color: LHColor.darkGrey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _categories.isEmpty
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : GridView.builder(
            shrinkWrap: true, // Ensures the GridView takes only the necessary space
            physics: const NeverScrollableScrollPhysics(), // Prevents scrolling conflicts
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return buildCategoryCard(
                context,
                category['name'],
                category['description'],
                category['icon'],
              );
            },
          );
  }
}
