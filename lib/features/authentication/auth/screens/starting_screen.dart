import 'package:email_validator/email_validator.dart';
import 'package:fixtex/consts/strings.dart';
import 'package:fixtex/features/authentication/bloc/auth_bloc.dart';
import 'package:fixtex/widgets/custome_text_field.dart';
import 'package:fixtex/widgets/main_entrance_text.dart';
import 'package:fixtex/widgets/rectangle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StartingScreen extends StatefulWidget {
  final bool isGarageOwner;
  const StartingScreen({super.key, required this.isGarageOwner});

  @override
  State<StartingScreen> createState() => _StartingScreenState();
}

class _StartingScreenState extends State<StartingScreen> {
  bool isSignUp = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();

  @override
  void initState() {
    isSignUp = false;
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
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
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RectangleTopRight(
                        text: isSignUp ? 'Log in' : 'Sign up',
                        onTap: () {
                          setState(() {
                            isSignUp = !isSignUp;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WelcomTitle(title: isSignUp ? 'Sign up' : 'Log in'),
                    WelcomeMessage(
                        welcomeMessage: isSignUp ? welcomeSignUp : welcomeBack),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextFieldText(textFieldType: 'email'),
                      CustomTextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          return value != null &&
                                  !EmailValidator.validate(value)
                              ? 'Enter a valid email'
                              : null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const TextFieldText(textFieldType: 'password'),
                      CustomTextField(
                        obscureText: true,
                        controller: _passwordController,
                        validator: (value) => value != null && value.length <= 6
                            ? 'enter a valid password'
                            : null,
                      ),
                      if (isSignUp)
                        const SizedBox(
                          height: 10,
                        ),
                      if (isSignUp)
                        const TextFieldText(textFieldType: 'confirm password'),
                      if (isSignUp)
                        CustomTextField(
                            obscureText: false,
                            controller: _password2Controller,
                            validator: (String? value) {
                              final password = value ?? '';
                              final confirmPassword = _passwordController.text;
    
                              if (password.isEmpty) {
                                return 'Password is required';
                              }
    
                              if (password.length < 6) {
                                return 'Password must be at least 6 characters long';
                              }
    
                              if (password != confirmPassword) {
                                return 'Passwords do not match';
                              }
    
                              return null; 
                            }),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 70,
            ),
            // Sign up button
            RectangleMain(
              type: isSignUp ? 'Next' : 'Login', onTap: () {
              if (isSignUp) {
                 _signInWithEmailAndPassword(context);
                
              } else{
                _authenticateWithEmailAndPassword(context);
              }
            },
            ),
          ],
        ),
      ),
    );
  }

  void _signInWithEmailAndPassword(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        SignUpRequested(_emailController.text, _passwordController.text, widget.isGarageOwner),
      );
    }
  }

  void _authenticateWithEmailAndPassword(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        SignInRequested(_emailController.text, _passwordController.text, widget.isGarageOwner),
      );
    }
  }
}
