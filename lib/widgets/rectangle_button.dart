import 'package:fixtex/consts/colors.dart';
import 'package:flutter/material.dart';

class RectangleTopRight extends StatelessWidget {
  final String text;
  const RectangleTopRight({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: 153,
            height: 46,
            decoration: ShapeDecoration(
              color: kmainBlue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Center(
                child: Text(text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: '?????',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ))))
      ],
    );
  }
}

class RectangleMain extends StatelessWidget {
  final String type;
  const RectangleMain({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: '?????',
                  fontWeight: FontWeight.w400,
                  height: 0,
                )),
          ),
        ),
      ],
    );
  }
}
