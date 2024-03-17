import 'package:fixtex/consts/strings.dart';
import 'package:fixtex/screens/account_details_screen.dart';
import 'package:fixtex/screens/main_scaffold.dart';
import 'package:fixtex/widgets/custome_text_field.dart';
import 'package:fixtex/widgets/main_entrance_text.dart';
import 'package:fixtex/widgets/rectangle_button.dart';
import 'package:flutter/material.dart';

class StartingScreen extends StatefulWidget {
  const StartingScreen({super.key});

  @override
  State<StartingScreen> createState() => _StartingScreenState();
}

class _StartingScreenState extends State<StartingScreen> {
  bool isSignUp = false;

  @override
  void initState() {
    isSignUp = false;
    super.initState();
  }
  @override
   Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: (){
                          setState(() {
                            isSignUp = !isSignUp;
                          });
                        },
                        child: RectangleTopRight(text: isSignUp? 'Log in' :  'Sign up')),
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WelcomTitle(title: isSignUp ? 'Sign up' : 'Log in'),
                    WelcomeMessage(welcomeMessage: isSignUp ? welcomeSignUp : welcomeBack),
                  ],
                ),
                const SizedBox(height: 25,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextFieldText(textFieldType: 'email'),
                    const CustomTextField(),
                    const SizedBox(height: 10,),
                    const TextFieldText(textFieldType: 'password'),
                    const CustomTextField(),
                    if(isSignUp) const SizedBox(height: 10,),
                    if(isSignUp) const TextFieldText(textFieldType: 'confirm password'),
                    if(isSignUp) const CustomTextField(),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 70,),
            // Sign up button
            InkWell(onTap: () {
              if (isSignUp) {
                Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AccountingDetailsScreen(isSignUp: true)),
            );
              } else {
                Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage()),
            );
              }
            },child: RectangleMain(type: isSignUp? 'Next': 'Login',)),
          ],
        ),
      ),
    );
  }

}
