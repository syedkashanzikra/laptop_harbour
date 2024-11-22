import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lhstore/admin/screens/category/viewcategory.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              if (ModalRoute.of(context)?.settings.name != '/dashboard') {
                Navigator.pushNamed(context, '/dashboard');
              }
            },
          ),
          DrawerListTile(
            title: "Transaction",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              if (ModalRoute.of(context)?.settings.name != '/transaction') {
                Navigator.pushNamed(context, '/transaction');
              }
            },
          ),
          DrawerListTile(
            title: "Category",
            svgSrc: "assets/icons/menu_task.svg",
            press: () {
              if (ModalRoute.of(context)?.settings.name != '/viewCategory') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewCategoryScreen(),
                    settings: RouteSettings(name: '/viewCategory'),
                  ),
                );
              }
            },
          ),
          DrawerListTile(
            title: "Documents",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () {
              if (ModalRoute.of(context)?.settings.name != '/documents') {
                Navigator.pushNamed(context, '/documents');
              }
            },
          ),
          DrawerListTile(
            title: "Store",
            svgSrc: "assets/icons/menu_store.svg",
            press: () {
              if (ModalRoute.of(context)?.settings.name != '/store') {
                Navigator.pushNamed(context, '/store');
              }
            },
          ),
          DrawerListTile(
            title: "Notification",
            svgSrc: "assets/icons/menu_notification.svg",
            press: () {
              if (ModalRoute.of(context)?.settings.name != '/notifications') {
                Navigator.pushNamed(context, '/notifications');
              }
            },
          ),
          DrawerListTile(
            title: "Profile",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {
              if (ModalRoute.of(context)?.settings.name != '/profile') {
                Navigator.pushNamed(context, '/profile');
              }
            },
          ),
          DrawerListTile(
            title: "Settings",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {
              if (ModalRoute.of(context)?.settings.name != '/settings') {
                Navigator.pushNamed(context, '/settings');
              }
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(Colors.white54, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
