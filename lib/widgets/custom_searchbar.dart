import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextCapitalization? textCapitalization;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final void Function(PointerDownEvent)? onTapOutside;
  final Iterable<String>? autofillHints = const <String>[];

  const CustomSearchBar(
      {super.key,
      this.controller,
      this.focusNode,
      this.textCapitalization,
      this.onChanged,
      this.onEditingComplete,
      this.onSubmitted,
      this.onTap,
      this.onTapOutside});

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
