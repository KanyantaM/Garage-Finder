import 'package:flutter/material.dart';

class CustomTitles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
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