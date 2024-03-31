import 'package:flutter/material.dart';

class CustomTitles extends StatelessWidget {
  const CustomTitles({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(
          width: 276,
          height: 52,
          child: Text(
            'Bookings',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: '?????',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
        ),
      ],
    );
  }
}