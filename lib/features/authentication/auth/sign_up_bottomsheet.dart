import 'package:sassyglamupadmin/bottom_navigation/bottom_try.dart';
import 'package:sassyglamupadmin/utilites/constants.dart';
import 'package:sassyglamupadmin/utilites/helper.dart';
import 'package:sassyglamupadmin/widget/custom_text.dart';
import 'package:sassyglamupadmin/widget/custom_textfield.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../widget/custom_botto_login_widget.dart';
import '../../../widget/custom_button.dart';

class SignUpBottomSheet extends StatefulWidget {
  const SignUpBottomSheet({super.key});

  @override
  State<SignUpBottomSheet> createState() => _SignUpBottomSheetState();
}

class _SignUpBottomSheetState extends State<SignUpBottomSheet> {
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
                title: "Sign up",
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
                    SizedBox(
                      height: 12.h,
                    ),
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
                      controller: _passwordController,
                      fillColor: kGreyLightColor,
                      isFilled: true,
                      hintText: "create password",
                      hintFontSize: 14.h,
                      textFontSize: 14.h,
                      cursorColor: kBlackColor,
                      hintTextColor: kGreyDarkColor,
                      prefixIcon: const Icon(Icons.password),
                      validation: (value) => value != null && value.length <= 6
                          ? 'enter a min of 6 characters'
                          : null,
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    CustomTextField(
                      controller: _passwordController,
                      fillColor: kGreyLightColor,
                      isFilled: true,
                      hintText: "re-enter password",
                      hintFontSize: 14.h,
                      textFontSize: 14.h,
                      cursorColor: kBlackColor,
                      hintTextColor: kGreyDarkColor,
                      prefixIcon: const Icon(Icons.password),
                      validation: (value) => value != null && value != _passwordController.text
                          ? 'passwords do not match'
                          : null,
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    CustomButton(
                      btnHeight: 51.h,
                      onPressed: () {
                        try {
                          _createAccountWithEmailAndPassword(context);
                          Helper.toScreen(
                              context, const BottomNavigationScreen());
                        } catch (e) {
                          SnackBar(
                            content:
                                Text('An unexpected error occurred: \n $e'),
                          );
                        }
                      },
                      btnColor: kSecondaryColor,
                      title: "Sign up",
                      textColor: kMainColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      btnRadius: 10,
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
                              onPressed: (){_authenticateWithGoogle(context);},),
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

  void _createAccountWithEmailAndPassword(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        SignUpRequested(_emailController.text, _passwordController.text,_phoneController.text,),
      );
    }
  }

  void _authenticateWithGoogle(BuildContext context) {
    
      BlocProvider.of<AuthBloc>(context).add(
        GoogleSignInRequested(),
      );
    
  }
}
