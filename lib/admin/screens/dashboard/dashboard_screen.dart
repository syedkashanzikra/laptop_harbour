import 'package:flutter/material.dart';
import 'package:lhstore/admin/screens/dashboard/components/my_fields.dart';

import '../../constants.dart';
import 'components/header.dart';

import 'components/recent_files.dart';


class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      MyFiles(),
                      SizedBox(height: defaultPadding),
                      RecentFiles(),
                      
                    ],
                  ),
                ),
              
                // On Mobile means if the screen is less than 850 we don't want to show it
              
              ],
            )
          ],
        ),
      ),
    );
  }
}
