import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextCapitalization? textCapitalization;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final void Function(PointerDownEvent)? onTapOutside;
  final Stream<List<String>>? suggestionStream;

  const CustomSearchBar({
    Key? key,
    this.controller,
    this.focusNode,
    this.textCapitalization,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onTap,
    this.onTapOutside,
    this.suggestionStream,
  }) : super(key: key);

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
          child: StreamBuilder<List<String>>(
            stream: suggestionStream?.debounceTime(const Duration(milliseconds: 300)), // Debounce user input
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'), // Display error message
                );
              }
              // if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
              //   return const Center(
              //     child: CircularProgressIndicator(), // Show loading indicator while waiting for suggestions
              //   );
              // }
              return Center(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  textCapitalization: textCapitalization ?? TextCapitalization.none,
                  onChanged: onChanged,
                  onEditingComplete: onEditingComplete,
                  onSubmitted: onSubmitted,
                  onTap: onTap,
                  onTapOutside: onTapOutside,
                  decoration: InputDecoration(
                    hintText: 'Search Postcode',
                    hintStyle: const TextStyle(
                      color: Color(0xFF797474),
                      fontSize: 15,
                      fontFamily: '?????',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                    prefixIcon: const Icon(Icons.search),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller!.clear();
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
