import 'package:flutter/material.dart';

class BookingData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: ShapeDecoration(
            image: const DecorationImage(
              image: AssetImage("assets/images/dummy.png"),
              fit: BoxFit.fill,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(
          child: Text(
            'Auto car centre \nThursday 18th of May 11:00AM',
            style: TextStyle(
              color: Color(0xFF4D4C4C),
              fontSize: 20,
              fontFamily: '?????',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
        ),
        const Divider()
      ],
    );
  }
}
