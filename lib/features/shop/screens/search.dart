import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lhstore/utils/constants/colors.dart';
import 'package:lhstore/utils/helpers/helpers_fuctions.dart';

class LHSearchScreen extends StatefulWidget {
  const LHSearchScreen({Key? key}) : super(key: key);

  @override
  _LHSearchScreenState createState() => _LHSearchScreenState();
}

class _LHSearchScreenState extends State<LHSearchScreen> {
  late FocusNode _focusNode;
  final TextEditingController _searchController = TextEditingController();
  final DatabaseReference productsRef =
      FirebaseDatabase.instance.ref('Products'); // Reference to Products collection

  List<Map<String, dynamic>> searchResults = []; // Store search results

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _searchController.addListener(_onSearchChanged); // Listen for search input changes
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    // Fetch and filter products based on the query
    productsRef.once().then((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        final filteredProducts = data.entries
            .where((entry) {
              final product = entry.value as Map<dynamic, dynamic>;
              final name = (product['name'] ?? '').toString().toLowerCase();
              final category = (product['category'] ?? '').toString().toLowerCase();

              return name.contains(query) || category.contains(query);
            })
            .map((entry) {
              final product = entry.value as Map<dynamic, dynamic>;
              return {
                'id': entry.key,
                'name': product['name'],
                'category': product['category'],
                'price': product['price'],
                'imageUrl': product['imageUrl'],
              };
            })
            .toList();

        setState(() {
          searchResults = filteredProducts;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = LHHelperFunction.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: dark ? LHColor.light : LHColor.dark),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: 'Search by brand, category, etc',
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(10.0),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: dark ? LHColor.light : LHColor.dark),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: searchResults.isEmpty
            ? Center(child: Text('No results found.'))
            : ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final product = searchResults[index];
                  return ListTile(
                    leading: product['imageUrl'] != null && product['imageUrl'].isNotEmpty
                        ? Image.network(
                            product['imageUrl'],
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          )
                        : Icon(Icons.image_not_supported),
                    title: Text(product['name'] ?? ''),
                    subtitle: Text('Category: ${product['category']}'),
                    trailing: Text('\$${product['price']}'),
                    onTap: () {
                      // Navigate to product details page
                      print('Selected Product ID: ${product['id']}');
                    },
                  );
                },
              ),
      ),
    );
  }
}
