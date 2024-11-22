import 'package:flutter/material.dart';
import 'package:lhstore/admin/screens/dashboard/dashboard_screen.dart';
import 'components/side_menu.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  if (MediaQuery.of(context).size.width < 1100) // Show menu icon on smaller screens
                    IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                    ),
                  Text(
                    "Dashboard",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
            Expanded(child: DashboardScreen()),
          ],
        ),
      ),
    );
  }
}
