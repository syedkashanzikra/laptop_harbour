import 'package:lhstore/admin/controllers/menu_app_controller.dart';
import 'package:lhstore/admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:lhstore/admin/screens/main/components/side_menu.dart';
import 'package:lhstore/admin/screens/main/main_screen.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Side menu for large screens
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu(),
              ),
            Expanded(
              flex: 5,
              child: MainScreen(), // Embed the MainScreen here
            ),
          ],
        ),
      ),
    );
  }
}
