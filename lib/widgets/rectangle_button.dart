import 'package:flutter/material.dart';
import 'package:fixtex/consts/colors.dart';

class RectangleTopRight extends StatelessWidget {
  final String text;
  final Function() onTap;
  final Color? color;
  final bool isAlertDialogue;
  const RectangleTopRight({
    Key? key,
    required this.text,
    required this.onTap,
    this.color = kmainBlue,
    this.isAlertDialogue = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: isAlertDialogue ? 100 : 153,
        height: 46,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w400,
              fontFamily: 'Roboto', // Replace with your desired font
            ),
          ),
        ),
      ),
    );
  }
}

class RectangleMain extends StatelessWidget {
  final String type;
  final Function() onTap;
  const RectangleMain({
    Key? key,
    required this.type,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 326,
        height: 68,
        decoration: BoxDecoration(
          color: kmainBlue,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: Text(
            type,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w400,
              fontFamily: 'Roboto', // Replace with your desired font
            ),
          ),
        ),
      ),
    );
  }
}
