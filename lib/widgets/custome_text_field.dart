import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final InputDecoration? decoration;
  final int? maxLines;
  final bool? isEntry;
  final TextInputType? keyboardType;
  final bool? enabled;
  final String? Function(String?)? validator;
  final bool obscureText; 
  final String? hintText;
  final void Function(String)? onChanged;
  final Widget? prefixIcon;
  const CustomTextField({Key? key, this.maxLines = 1, this.isEntry,  this.controller,  this.decoration, this.keyboardType, this.enabled, this.validator, this.obscureText = false, this.hintText, this.onChanged, this.prefixIcon}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: (isEntry?? false) ? 80: null,
          constraints: BoxConstraints(
            maxHeight: maxLines! * 53.0, // Adjust the height dynamically based on maxLines
          ),
          decoration: ShapeDecoration(
            color:const Color(0xFFEBEAEA),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: onChanged,
              enabled: enabled,
              keyboardType: keyboardType,
              controller: controller,
              decoration: decoration ?? InputDecoration(
                prefixIcon: prefixIcon,
                border: InputBorder.none,
                hintText: hintText,
              ),
              maxLines: maxLines,
              validator: validator,
              obscureText: obscureText,
            ),
          ),
        ),
      ],
    );
  }
}
