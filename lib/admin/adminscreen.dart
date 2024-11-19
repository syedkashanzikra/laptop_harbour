import 'package:flutter/material.dart';
import 'package:lhstore/admin/responsive.dart';
import 'package:lhstore/admin/screens/main/components/side_menu.dart';
import 'package:lhstore/admin/screens/main/main_screen.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  // Scaffold Key to control the drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Use the local ScaffoldKey
      drawer: SideMenu(), // Drawer for small screens
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display SideMenu only for large screens
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu(),
              ),
            Expanded(
              flex: 5,
              child: MainScreen(), // Main content area
            ),
          ],
        ),
      ),
    );
  }
}
