import 'package:flutter/material.dart';

class WelcomTitle extends StatelessWidget {
  final String title;

  const WelcomTitle({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 36,
            //TODO: find out the font family
            // fontFamily: '?????',
            fontWeight: FontWeight.w400,
            height: 0,
          ),
        ),
      ],
    );
  }
}

class WelcomeMessage extends StatelessWidget {
  final String welcomeMessage;

  const WelcomeMessage({super.key, required this.welcomeMessage});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 326,
          child: Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: '\n',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                TextSpan(
                  text: welcomeMessage,
                  style: const TextStyle(
                    color: Color(0xFF797474),
                    fontSize: 20,
                    //TODO:Find out the font
                    fontFamily: '?????',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TextFieldText extends StatelessWidget {
  final String textFieldType;

  const TextFieldText({super.key, required this.textFieldType});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          textFieldType,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF797474),
            fontSize: 24,
            fontFamily: '?????',
            fontWeight: FontWeight.w400,
            height: 0,
          ),
        ),
      ],
    );
  }
}