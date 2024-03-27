import 'dart:async';

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
  final Future<List<String>>? suggestionStream;

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
          child: FutureBuilder<List<String>>(
            future: suggestionStream, // Debounce user input
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
          child: Center(
                child: TextField(
                  // autofillHints: snapshot.data,
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
              )),
              if(snapshot.data != null && snapshot.data!.isNotEmpty)
          Expanded(
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index]),
                  onTap: () {
                    // Handle selection of suggestion
                    controller!.text = snapshot.data![index];
                  },
                );
              },
            ),
          ),
      ],
    );
            },
          ),
        ),
      ],
    );
  }
}
