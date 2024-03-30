import 'package:country_code_picker/country_code_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignInBottomSheet extends StatefulWidget {
  const SignInBottomSheet({super.key});

  @override
  State<SignInBottomSheet> createState() => _SignInBottomSheetState();
}

class _SignInBottomSheetState extends State<SignInBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        SizedBox(
          height: 10.h,
        ),
        ListTile(
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back)),
          title: Center(
            child: Container(
              margin: const EdgeInsets.only(right: 40),
              child: const CustomText(
                title: "SignIn",
                color: kBlackColor,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 29.h,
                    ),
                    CustomTextField(
                      controller: _emailController,
                      fillColor: kGreyLightColor,
                      isFilled: true,
                      hintText: "email",
                      hintFontSize: 14.h,
                      textFontSize: 14.h,
                      cursorColor: kBlackColor,
                      hintTextColor: kGreyDarkColor,
                      prefixIcon: const Icon(Icons.email_outlined),
                      keyboardType: TextInputType.emailAddress,
                      validation: (value) {
                        return value != null && !EmailValidator.validate(value)
                            ? 'Enter a valid email'
                            : null;
                      },
                    ),
                    // SizedBox(
                    //   height: 12.h,
                    // ),
                    // CustomTextField(
                    //   controller: _phoneController,
                    //   fillColor: kGreyLightColor,
                    //   isFilled: true,
                    //   hintText: "number",
                    //   hintFontSize: 14.h,
                    //   textFontSize: 14.h,
                    //   cursorColor: kBlackColor,
                    //   hintTextColor: kGreyDarkColor,
                    //   prefixIcon: const CountryCodePicker(),
                    //   keyboardType: TextInputType.phone,
                    // ),
                    // SizedBox(
                    //   height: 12.h,
                    // ),
                    CustomTextField(
                      obscureText: true,
                      controller: _passwordController,
                      fillColor: kGreyLightColor,
                      isFilled: true,
                      hintText: "password",
                      hintFontSize: 14.h,
                      textFontSize: 14.h,
                      cursorColor: kBlackColor,
                      hintTextColor: kGreyDarkColor,
                      prefixIcon: const Icon(Icons.password),
                      validation: (value) => value != null && value.length <= 6
                          ? 'enter a valid password'
                          : null,
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return CustomButton(
                          btnHeight: 51.h,
                          onPressed: () {
                            try {
                              _authenticateWithEmailAndPassword(context);
                              if (state is Authenticated) {
                                Helper.toScreen(
                                    context, const BottomNavigationScreen());
                              }
                              Navigator.pop(context);
                            } catch (e) {
                              Navigator.pop(context);
                              SnackBar(
                                content:
                                    Text('An unexpected error occurred: \n $e'),
                              );
                            }
                          },
                          btnColor: kSecondaryColor,
                          title: "Sign In",
                          textColor: kMainColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          btnRadius: 10,
                        );
                      },
                    ),
                    SizedBox(
                      height: 34.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.31,
                          child: const Divider(
                            color: kGreyDarkColor,
                          ),
                        ),
                        CustomText(
                          title: "or access quickly",
                          color: kGreyDarkColor,
                          fontSize: 10.h,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.31,
                          child: const Divider(
                            color: kGreyDarkColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 26.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // CustomButtonLoginWidget(
                        //     title: "Apple",
                        //     icon: "assets/_Group_2.png",
                        //     onPressed: () {}),
                        // CustomButtonLoginWidget(
                        //     title: "Facebook",
                        //     icon: "assets/facebook.png",
                        //     onPressed: () {}),
                        Expanded(
                          child: CustomButtonLoginWidget(
                            title: "Google",
                            icon: "assets/google (1).png",
                            onPressed: () {
                              _authenticateWithGoogle(context);
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void _authenticateWithEmailAndPassword(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        SignInRequested(_emailController.text, _passwordController.text),
      );
    }
  }

  void _authenticateWithGoogle(BuildContext context) {
    
      BlocProvider.of<AuthBloc>(context).add(
        GoogleSignInRequested(),
      );
    
  }
}
