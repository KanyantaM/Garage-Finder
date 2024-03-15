import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 349,
          height: 63,
          decoration: ShapeDecoration(
            color: const Color(0xFFD9D9D9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Center(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Postcode',
                hintStyle: TextStyle(
                  color: Color(0xFF797474),
                  fontSize: 15,
                  fontFamily: '?????',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
