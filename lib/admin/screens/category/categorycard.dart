import 'package:flutter/material.dart';
import '../../constants.dart';

class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const CategoryCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    icon,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(width: defaultPadding),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            Text(
              description.length > 50
                  ? "${description.substring(0, 47)}..." // Truncate description
                  : description,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
