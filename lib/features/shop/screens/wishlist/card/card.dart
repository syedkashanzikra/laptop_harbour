import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class Wishlistscreen extends StatefulWidget {
  @override
  _WishlistscreenState createState() => _WishlistscreenState();
}

class _WishlistscreenState extends State<Wishlistscreen> {
  late Future<List<Map<String, dynamic>>> wishlistFuture;

  @override
  void initState() {
    super.initState();
    wishlistFuture = fetchUserWishlist();
  }

  Future<List<Map<String, dynamic>>> fetchUserWishlist() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final DatabaseReference wishlistRef =
        FirebaseDatabase.instance.ref().child('Wishlist');
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    User? currentUser = auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not logged in');
    }
    final String currentUserId = currentUser.uid;

    String firstName = "Unknown";
    String lastName = "User";

    try {
      DocumentSnapshot userDoc =
          await firestore.collection('Users').doc(currentUserId).get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        firstName = userData['FirstName'] ?? "Unknown";
        lastName = userData['LastName'] ?? "User";
      }
    } catch (e) {
      throw Exception('Failed to fetch user details');
    }

    final snapshot =
        await wishlistRef.orderByChild('userId').equalTo(currentUserId).get();

    if (!snapshot.exists) return [];

    final List<Map<String, dynamic>> wishlist = [];
    final data = snapshot.value as Map<dynamic, dynamic>;

    data.forEach((key, value) {
      wishlist.add({
        'productId': key,
        'imageUrl': value['imageUrl'],
        'productName': value['productName'],
        'price': value['price'],
        'userName': "$firstName $lastName",
      });
    });

    return wishlist;
  }

  Future<void> removeFromWishlist(String productId) async {
    final DatabaseReference wishlistRef =
        FirebaseDatabase.instance.ref().child('Wishlist');

    await wishlistRef.child(productId).remove();
    setState(() {
      wishlistFuture = fetchUserWishlist();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Item removed from wishlist'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wishlist"),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: wishlistFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 288,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 4,
              itemBuilder: (_, __) => Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(height: 288, color: Colors.white),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(
              child: Lottie.asset(
                'assets/json/empty.json',
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
            );
          } else {
            final wishlistItems = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 320,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: wishlistItems.length,
              padding: EdgeInsets.all(12),
              itemBuilder: (_, index) {
                final item = wishlistItems[index];
                return WishlistItemCard(
                  image: item['imageUrl'],
                  title: item['productName'],
                  price: item['price'],
                  userName: item['userName'],
                  onRemove: () => removeFromWishlist(item['productId']),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class WishlistItemCard extends StatelessWidget {
  final String image;
  final String title;
  final dynamic price;
  final String userName;
  final VoidCallback onRemove;

  const WishlistItemCard({
    Key? key,
    required this.image,
    required this.title,
    required this.price,
    required this.userName,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.network(
              image,
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Icon(
                Icons.broken_image,
                size: 100,
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Text(
                  '\$${price.toString()}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Added by: $userName',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Center(
                  child: InkWell(
                    onTap: onRemove,
                    borderRadius: BorderRadius.circular(8),
                    splashColor: Colors.red.withOpacity(0.2),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.redAccent.withOpacity(0.4),
                            blurRadius: 4,
                            spreadRadius: 1,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.white),
                          SizedBox(width: 6),
                          Text(
                            'Remove',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
