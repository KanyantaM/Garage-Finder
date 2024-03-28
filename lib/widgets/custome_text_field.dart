import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final InputDecoration? decoration;
  final int? maxLines;
  final bool? isEntry;
  const CustomTextField({Key? key, this.maxLines = 1, this.isEntry,  this.controller,  this.decoration}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: (isEntry?? false) ? 150: null,
          constraints: BoxConstraints(
            maxHeight: maxLines! * 53.0, // Adjust the height dynamically based on maxLines
          ),
          decoration: ShapeDecoration(
            color: Color(0xFFEBEAEA),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              maxLines: maxLines,
            ),
          ),
        ),
      ],
    );
  }
}
