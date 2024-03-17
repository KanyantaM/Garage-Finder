import 'package:flutter/material.dart';

class AutoServiceTile extends StatelessWidget {
  final String name;
  final String address;
  final String imagePath; // Path to image asset or URL
  final double rating; // Rating out of 5

  const AutoServiceTile({
    Key? key,
    required this.name,
    required this.address,
    required this.imagePath,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              address,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.star, color: Colors.yellow),
                SizedBox(width: 4),
                Text(
                  '$rating',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          // Handle tapping on auto shop
        },
      ),
    );
  }
}
