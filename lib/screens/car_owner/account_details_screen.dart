import 'package:fixtex/features/authentication/auth/auth_page.dart';
import 'package:fixtex/widgets/custome_text_field.dart';
import 'package:fixtex/widgets/main_entrance_text.dart';
import 'package:fixtex/widgets/rectangle_button.dart';
import 'package:flutter/material.dart';
import 'package:user_api_firebase/user_api_firebase_auth.dart';

class AccountingDetailsScreen extends StatefulWidget {
  final bool isSignUp;
  final bool? isGarageOwner;
  const AccountingDetailsScreen(
      {super.key, required this.isSignUp, this.isGarageOwner});

  @override
  State<AccountingDetailsScreen> createState() => _StartingScreenState();
}

class _StartingScreenState extends State<AccountingDetailsScreen> {
  bool canEdit = false;

  @override
  void initState() {
    canEdit = widget.isSignUp ? true : false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                if (!widget.isSignUp)
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RectangleTopRight(
                            text: canEdit ? 'Revert' : 'Edit', onTap: () {setState(() {
                            canEdit = !canEdit;
                          });  },),
                      ],
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                const ProfileImage(),
                const SizedBox(
                  height: 20,
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFieldText(textFieldType: 'Name'),
                    CustomTextField(),
                    SizedBox(
                      height: 10,
                    ),
                    TextFieldText(textFieldType: 'Email'),
                    CustomTextField(),
                    SizedBox(
                      height: 10,
                    ),
                    TextFieldText(textFieldType: 'Security'),
                    CustomTextField(),

                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            // Sign up button
             RectangleMain(
              type: 'Log out',
              onTap: () {
                UserApiFirebase().signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthPage()),
                  (route) =>
                      false, // This will remove all routes from the stack
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class ProfileImage extends StatelessWidget {
  const ProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 344,
          height: 82,
          decoration: ShapeDecoration(
            image: const DecorationImage(
              image: NetworkImage("https://via.placeholder.com/344x82"),
              fit: BoxFit.fill,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
