import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class CardCarousel extends StatefulWidget {
  @override
  _CardCarouselState createState() => _CardCarouselState();
}

class _CardCarouselState extends State<CardCarousel> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance
      .ref()
      .child('Products'); // Adjust this path as per your structure

  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _fetchProducts() {
    _databaseReference.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        final List<Map<String, dynamic>> loadedProducts = [];
        data.forEach((key, value) {
          loadedProducts.add({
            'id': key,
            'title': value['name'] ??
                'No Title', // Use 'name' field and provide a default value
            'description': value['description'] ?? 'No description available',
            'imageUrl': value['imageUrl'] ??
                'https://via.placeholder.com/150', // Fallback URL
            'price': value['price'] ?? 0.0, // Default price to 0.0
          });
        });
        setState(() {
          _products = loadedProducts;
        });
      } else {
        setState(() {
          _products = [];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products '),
        backgroundColor: Colors.black,
      ),
      body: _products.isEmpty
          ? Center(
              child: Text(
                'No products available.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            )
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return LaptopCard(
                  imageUrl: product['imageUrl'],
                  title: product['title'],
                  price: product['price'],
                  rating: 4.5, // Placeholder rating
                  specs: product['description'],
                );
              },
            ),
    );
  }
}

class LaptopCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double price;
  final double rating;
  final String specs;

  LaptopCard({
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.rating,
    required this.specs,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.black54,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Product Image
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 180,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.broken_image,
                size: 180,
                color: Colors.grey,
              ), // Fallback image in case of a network error
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.0),
                  // Specifications
                  Text(
                    specs,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 6.0),
                  // Rating
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.yellow[700],
                        size: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  // Price
                  Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  // Buttons Row with Spacing
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Add to Cart Button
                      ElevatedButton(
                        onPressed: () {
                          // Add to cart action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.blueAccent, // Background color
                          foregroundColor: Colors.white, // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: Size(120, 40),
                        ),
                        child: Text("Add to Cart"),
                      ),
                      SizedBox(width: 8.0), // Spacing between buttons
                      // Buy Now Button
                      OutlinedButton(
                        onPressed: () {
                          // Buy Now action
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.blueAccent,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: Size(120, 40),
                        ),
                        child: Text(
                          "Buy Now",
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
