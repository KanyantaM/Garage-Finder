import 'package:flutter/material.dart';
import 'package:garage_repository/garage_repository.dart';

class AutoServiceTile extends StatelessWidget {
  final Garage? garage;
  final bool isLoading;

  const AutoServiceTile({
    Key? key,
    this.garage,
    required this.isLoading,
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
            color: Colors.black,
            shape: BoxShape.circle,
            image: (isLoading)
                ? DecorationImage(
                    image: NetworkImage(garage?.imageUrl ?? ''),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
        ),
        title: Text(
          garage?.name ?? '',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: _buildText(),
        onTap: () {
          // Handle tapping on auto shop
          //TODO: add the booking functionality
        },
      ),
    );
  }

  Widget _buildText() {
    if (isLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 25,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            garage?.address ?? '',
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
                '${garage?.rating ?? "N/A"}',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      );
    }
  }
}
