import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lhstore/admin/responsive.dart';
import 'package:lhstore/admin/screens/admin_product/admin_addproduct.dart';
import 'package:lhstore/admin/screens/admin_product/admin_product_card.dart';
import '../../constants.dart';
import 'package:lhstore/admin/screens/main/components/side_menu.dart';

class ProductAdminView extends StatefulWidget {
  @override
  _ProductAdminViewState createState() => _ProductAdminViewState();
}

class _ProductAdminViewState extends State<ProductAdminView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("Products"); // Firebase DB Reference

  List<Map<String, dynamic>> _products = []; // List of products
  bool _isLoading = true; // Show loading indicator while fetching data

  @override
  void initState() {
    super.initState();
    _fetchProducts(); // Fetch products on screen load
  }

  // Fetch products from Firebase Realtime Database
  Future<void> _fetchProducts() async {
    try {
      final snapshot = await _dbRef.get(); // Get data from Firebase
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        final List<Map<String, dynamic>> products = data.entries.map((entry) {
          final value = entry.value as Map<dynamic, dynamic>;
          return {
            "id": entry.key,
            "title": value["name"],
            "description": value["description"],
            "imageUrl": value["imageUrl"],
            "price": value["price"],
          };
        }).toList();

        setState(() {
          _products = products;
          _isLoading = false; // Data loaded
        });
      } else {
        setState(() {
          _products = []; // No products found
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Stop loading if an error occurs
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load products: $e")),
      );
    }
  }

  // Delete a product and update the list
  void _deleteProduct(String productId) {
    setState(() {
      _products.removeWhere((product) => product["id"] == productId); // Remove from list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding,
                vertical: defaultPadding / 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!Responsive.isDesktop(context)) // Show menu icon on small screens
                    IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                    ),
                  Text(
                    "Product Management",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to AddProductAdmin screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddProductAdmin()),
                      ).then((_) => _fetchProducts()); // Refresh product list after adding
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      shadowColor: Colors.blueAccent.withOpacity(0.5),
                      elevation: 8,
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.add, size: 22),
                        SizedBox(width: 8),
                        Text('Add Product'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator()) // Show loading indicator
                  : _products.isEmpty
                      ? Center(child: Text("No products available"))
                      : GridView.builder(
                          padding: EdgeInsets.all(defaultPadding),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: Responsive.isMobile(context) ? 1 : 2,
                            crossAxisSpacing: defaultPadding,
                            mainAxisSpacing: defaultPadding,
                            childAspectRatio: 3 / 2,
                          ),
                          itemCount: _products.length,
                          itemBuilder: (context, index) {
                            final product = _products[index];
                            return ProductAdminCard(
                              id: product["id"],
                              title: product["title"],
                              description: product["description"],
                              imageUrl: product["imageUrl"],
                              price: product["price"],
                              onDelete: () => _deleteProduct(product["id"]), // Pass delete callback
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
