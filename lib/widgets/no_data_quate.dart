import 'package:flutter/material.dart';

class DiscoverAndBookAutoService extends StatelessWidget {
  const DiscoverAndBookAutoService({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/images/empty_calender.png')
        ,
        const SizedBox(
          width: 315,
          height: 79,
          child: Text(
            'Discover and book auto service specialist\'s  near you. Your scheduled appointments will show up here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF4E4C4C),
              fontSize: 16,
              fontFamily: '?????',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
        ),
      ],
    );
  }
}