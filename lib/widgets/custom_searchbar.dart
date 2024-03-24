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
            stream: suggestionStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return TextField(
                autofillHints: snapshot.data,
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
              );
            },
          ),
        ),
      ],
    );
  }
}
