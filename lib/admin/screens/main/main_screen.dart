import 'package:flutter/material.dart';
import 'package:lhstore/admin/controllers/menu_app_controller.dart';
import 'package:lhstore/admin/screens/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'components/side_menu.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey, // Scaffold key for controlling the drawer
      drawer: SideMenu(), // SideMenu always acts as a drawer
      body: SafeArea(
        child: DashboardScreen(), // Main content area
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final scaffoldKey = context.read<MenuAppController>().scaffoldKey;
          if (!scaffoldKey.currentState!.isDrawerOpen) {
            scaffoldKey.currentState!.openDrawer(); // Open drawer manually
          }
        },
        child: Icon(Icons.menu), // Menu icon for opening the drawer
      ),
    );
  }
}
