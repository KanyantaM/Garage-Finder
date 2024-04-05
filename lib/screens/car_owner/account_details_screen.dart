import 'package:fixtex/widgets/custome_text_field.dart';
import 'package:fixtex/widgets/main_entrance_text.dart';
import 'package:fixtex/widgets/rectangle_button.dart';
import 'package:flutter/material.dart';
import 'package:user_api_firebase/user_api_firebase_auth.dart';
import 'package:user_repository/user_repository.dart';

class EditOwnerScreen extends StatefulWidget {
  const EditOwnerScreen({
    super.key,
  });

  @override
  State<EditOwnerScreen> createState() => _StartingScreenState();
}

class _StartingScreenState extends State<EditOwnerScreen> {
  bool canEdit = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _userRepository = UserApiFirebase();
  final Owner _owner = UserApiFirebase().getCurrentUser()!;

  @override
  void initState() {
    _nameController.text = _owner.name;
    _emailController.text = _owner.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _viewBody(context),
      ),
    );
  }

  ListView _viewBody(BuildContext context) {
    return ListView(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RectangleTopRight(
                    text: canEdit ? 'Revert' : 'Edit',
                    onTap: () {
                      setState(() {
                        canEdit = !canEdit;
                      });
                    },
                  ),
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
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextFieldText(textFieldType: 'Name'),
                CustomTextField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  enabled: canEdit,
                ),
                const SizedBox(
                  height: 10,
                ),
                const TextFieldText(textFieldType: 'Email'),
                CustomTextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  enabled: canEdit,
                ),
                const SizedBox(
                  height: 10,
                ),
                if (canEdit) const TextFieldText(textFieldType: 'New Password'),
                if (canEdit)
                  CustomTextField(
                    controller: _passwordController,
                    // keyboardType: TextInputType.emailAddress,
                    enabled: canEdit,
                    obscureText: true,
                  ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        // Sign up button
        if (canEdit)
          RectangleMain(
            type: 'Save',
            onTap: () {
              if (_owner.name != _nameController.text) {
                _userRepository.updateUserName(_nameController.text);
              }
              if (_owner.email != _emailController.text) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Email Update'),
                      content: const Text(
                          'An email will be sent to the original email address.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _userRepository
                                .updateUserEmail(_emailController.text);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
              if (_passwordController.text.isNotEmpty) {
                if (_passwordController.text.length >= 6) {
                  _userRepository.updateUserPassword(_passwordController.text);
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Password Too Short'),
                        content: const Text(
                            'Password must be at least 6 characters long.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              }
            },
          )
      ],
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
