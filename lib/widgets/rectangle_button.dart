import 'package:fixtex/consts/colors.dart';
import 'package:flutter/material.dart';

class RectangleTopRight extends StatelessWidget {
  final String text;
  final Function() onTap;
  final Color? color;
  const RectangleTopRight({super.key, required this.text, required this.onTap, this.color = kmainBlue});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap:  onTap,
          child: Container(
            width: 153,
            height: 46,
            decoration: ShapeDecoration(
              color: color,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: '?????',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class RectangleMain extends StatelessWidget {
  final String type;
  final Function() onTap;
  const RectangleMain({super.key, required this.type, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            width: 326,
            height: 68,
            decoration: ShapeDecoration(
              color: kmainBlue,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Center(
              child: Text(type,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: '?????',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
