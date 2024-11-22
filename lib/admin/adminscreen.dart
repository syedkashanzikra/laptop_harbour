import 'package:flutter/material.dart';
import 'package:lhstore/admin/screens/main/components/side_menu.dart';
import 'package:lhstore/admin/screens/main/main_screen.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Local ScaffoldKey
      drawer: SideMenu(), // SideMenu will always act as a drawer
      body: SafeArea(
        child: MainScreen(), // Main content area
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controlMenu, // Open drawer on button click
        child: Icon(Icons.menu),
      ),
    );
  }
}
