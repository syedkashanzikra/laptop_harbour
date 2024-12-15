import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lhstore/admin/responsive.dart';
import 'package:lhstore/admin/screens/category/adminprofile/adminprofile.dart';
import '../../../constants.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isMobile(context))
          Text(
            "Dashboard",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        Expanded(child: SearchField()),
        ProfileCard(),
      ],
    );
  }
}

class ProfileCard extends StatefulWidget {
  const ProfileCard({Key? key}) : super(key: key);

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  String userName = "User";

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  void _fetchUserName() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userName = user.displayName ?? "Admin";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: defaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(Icons.person, size: 38, color: Colors.white),
          if (!Responsive.isMobile(context))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: Text(userName),
            ),
          PopupMenuButton<String>(
            icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
            onSelected: (value) {
              if (value == "Profile") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminProfileScreen(),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "Profile",
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.black),
                    SizedBox(width: 10),
                    Text("View Profile"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SearchField extends StatefulWidget {
  const SearchField({Key? key}) : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController _controller = TextEditingController();
  List<String> searchResults = [];
  bool isLoading = false;

  void _search(String query) async {
    query = query.trim();
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    setState(() {
      isLoading = true;
      searchResults = [];
    });

    try {
      // Search Users in Firestore
      final usersSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('FirstName', isGreaterThanOrEqualTo: query)
          .get();

      for (var doc in usersSnapshot.docs) {
        searchResults.add("User: ${doc['FirstName']} ${doc['LastName']} - ${doc['Email']}");
      }

      // Search Products in Realtime Database
      final productsSnapshot = await FirebaseDatabase.instance.ref("Products").get();
      if (productsSnapshot.exists) {
        final products = Map<String, dynamic>.from(productsSnapshot.value as Map);
        products.forEach((key, value) {
          if (value["name"].toString().toLowerCase().contains(query.toLowerCase())) {
            searchResults.add("Product: ${value['name']}");
          }
        });
      }

      // Search Categories in Realtime Database
      final categoriesSnapshot = await FirebaseDatabase.instance.ref("Categories").get();
      if (categoriesSnapshot.exists) {
        final categories = Map<String, dynamic>.from(categoriesSnapshot.value as Map);
        categories.forEach((key, value) {
          if (value["name"].toString().toLowerCase().contains(query.toLowerCase())) {
            searchResults.add("Category: ${value['name']}");
          }
        });
      }
    } catch (e) {
      print("Error searching: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          onChanged: _search,
          decoration: InputDecoration(
            hintText: "Search",
            fillColor: secondaryColor,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            suffixIcon: isLoading
                ? Padding(
                    padding: EdgeInsets.all(10.0),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(Icons.search, color: Colors.white),
          ),
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 8),
        if (searchResults.isNotEmpty)
          Container(
            margin: EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: searchResults.length,
              separatorBuilder: (_, __) => Divider(color: Colors.white10, height: 1),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                    searchResults[index],
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
