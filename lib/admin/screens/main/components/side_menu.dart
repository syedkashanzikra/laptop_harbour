import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lhstore/admin/screens/admin_product/admin_product_page.dart';
import 'package:lhstore/admin/screens/category/adminprofile/adminprofile.dart';
import 'package:lhstore/admin/screens/category/viewcategory.dart';
import 'package:lhstore/admin/screens/components/adminuserscreen.dart';
import 'package:lhstore/admin/screens/main/main_screen.dart';
import 'package:lhstore/data/repositories_authentication/authentication_repository.dart';
import 'package:lhstore/admin/screens/components/adminfeedbackscreen.dart';

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
              // Close the drawer and navigate back to MainScreen
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(),
                ),
              );
            },
          ),

          DrawerListTile(
            title: "Category",
            svgSrc: "assets/icons/category-svgrepo-com.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewCategoryScreen(),
                ),
              );
            },
          ),
            DrawerListTile(
            title: "Products",
            svgSrc: "assets/icons/category-svgrepo-com.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductAdminView(),
                ),
              );
            },
          ),

             DrawerListTile(
            title: "Feedback",
            svgSrc: "assets/icons/category-svgrepo-com.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminViewFeedback(),
                ),
              );
            },
          ),
             DrawerListTile(
            title: "Users",
          svgSrc: "assets/icons/menu_profile.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminViewUsers(),
                ),
              );
            },
          ),

            
          DrawerListTile(
            title: "Profile",
            svgSrc: "assets/icons/menu_profile.svg",
     press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminProfileScreen(),
                ),
              );
            },
          ),

            DrawerListTile(
            title: "Logout",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {
         AuthenticationRepository.instance.logout();
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
