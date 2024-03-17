import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
            top: 328,
            left: 44,
            right: 43,
            bottom: 422,
          ),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Color(0xFF1BB7E8)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 303,
                height: 94,
                child: Text(
                  'Garage Finnder',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF1226DB),
                    fontSize: 64,
                    fontFamily: '?????',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}