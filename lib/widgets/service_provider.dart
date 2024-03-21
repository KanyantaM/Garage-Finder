import 'package:flutter/material.dart';
import 'package:garage_repository/garage_repository.dart';

class AutoServiceTile extends StatelessWidget {
  final Garage garage; // Rating out of 5

  const AutoServiceTile({
    Key? key,
    required this.garage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(garage.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          garage.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              garage.address,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.yellow),
                const SizedBox(width: 4),
                Text(
                  '${garage.rating}',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          // Handle tapping on auto shop
          //TODO: add the booking functionality
        },
      ),
    );
  }
}
