import 'package:fixtex/consts/colors.dart';
import 'package:fixtex/features/authentication/bloc/auth_bloc.dart';
import 'package:fixtex/screens/main_scaffold.dart';
import 'package:fixtex/features/authentication/auth/screens/starting_screen.dart';
import 'package:fixtex/widgets/rectangle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthView extends StatelessWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool confirmExit = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Confirm Exit"),
            content: const Text(
                "Are you sure you want to exit the Garage Finder app?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Exit"),
              ),
            ],
          ),
        );

        return confirmExit;
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
            if (state is AuthError) {
              //Displaying the error message if the user is not authenticated
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            }
          }, builder: (context, state) {
            if (state is Loading) {
              //Display the loading indicator while the user is signing up
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is Authenticated) {
              return const BottomNav();
            }
            if (state is Unauthenticated) {
              {
                return Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/dummy.jpg"),
                            fit: BoxFit.cover)),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // SizedBox(height: 20.h,),
                          Container(
                            margin: const EdgeInsets.only(top: 77),
                            child: Text(
                              "",
                              style: TextStyle(
                                color: kmainBlue,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              RectangleTopRight(
                                text: 'Garge Owner',
                                onTap: () {
                                  context
                                      .read<AuthBloc>()
                                      .add(GarageOwnerSignIn());
                                },
                              ),
                              RectangleTopRight(
                                text: 'Car Owner',
                                onTap: () {
                                  context
                                      .read<AuthBloc>()
                                      .add(CarOwnerSignIn());
                                },
                              ),
                              // CustomButton(
                              //   btnHeight: 67.h,
                              //   btnColor: kSecondaryColor,
                              //   title: "Login",
                              //   onPressed: () {
                              //     _onButtonPressed(
                              //         context, const SignInBottomSheet());
                              //   },
                              //   textColor: kMainColor,
                              //   fontWeight: FontWeight.w400,
                              //   fontSize: 15,
                              //   btnRadius: 10,
                              // ),
                              // SizedBox(
                              //   height: 15,
                              // ),
                              // InkWell(
                              //   onTap: () {
                              //     _onButtonPressed(
                              //         context, const SignUpBottomSheet());
                              //   },
                              //   child: Container(
                              //     height: 67.h,
                              //     decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(10),
                              //       border: Border.all(color: kmainBlue),
                              //     ),
                              //     child: const Center(
                              //       child: Text(
                              //         "Sign up",
                              //         style: TextStyle(color: k,
                              //         fontSize: 15,
                              //         fontWeight: FontWeight.w400,),

                              //         textAlign: TextAlign.center,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: 23.h,
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ));
              }
            }
            if (state is AccountType) {
              return StartingScreen(
                isGarageOwner: state.isGarage,
              );
            }
            return Container();
          })
          // child: Image.asset("assets/"),
          ),
    );
  }
}
