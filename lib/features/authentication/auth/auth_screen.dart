import 'package:fixtex/consts/colors.dart';
import 'package:fixtex/features/authentication/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
  bool confirmExit = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Confirm Exit"),
      content: const Text("Are you sure you want to exit the Garage Finder app?"),
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
        body: BlocConsumer<AuthBloc, AuthState>(listener: (context, state){
          if(state is Authenticated){
            //navigate to the dashboard screen if the user is authenticated
            // Helper.toScreen(context, const BottomNavigationScreen());
          }
          if(state is AuthError){
            //Displaying the error message if the user is not authenticated
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
          }
        }, builder: (context, state){
          if(state is Loading){
            //Display the loading indicator while the user is signing up
             return const Center(child: CircularProgressIndicator(),);
          }
          if (state is Authenticated) {
            return const BottomNavigationScreen();
          }
          if(state is Unauthenticated){
            if(FirebaseAuth.instance.currentUser?.isAnonymous ?? false || FirebaseAuth.instance.currentUser!.uid.isEmpty) {
              return Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/dummy.jpg"), fit: BoxFit.cover)),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // SizedBox(height: 20.h,),
                Container(
                  margin: EdgeInsets.only(top: 77.h),
                  child: Text(
                    "",
                    style: TextStyle(
                    color: kmainBlue,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,),
                    
                    textAlign: TextAlign.end,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomButton(
                      btnHeight: 67.h,
                      btnColor: kSecondaryColor,
                      title: "Login",
                      onPressed: () {
                        _onButtonPressed(context, const SignInBottomSheet());
                      },
                      textColor: kMainColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      btnRadius: 10,
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    InkWell(
                      onTap: () {
                        _onButtonPressed(context, const SignUpBottomSheet());
                      },
                      child: Container(
                        height: 67.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: kMainColor),
                        ),
                        child: const Center(
                          child: CustomText(
                            title: "Sign up",
                            color: kMainColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 23.h,
                    ),
                  ],
                ),
              ],
            ),
          ));
            }else{
              return const BottomNavigationScreen();
            }
          }
          return Container();
        }) 
          // child: Image.asset("assets/"),
        ),
    );
  }

void _onButtonPressed(BuildContext context, Widget task) {
    showModalBottomSheet(
      backgroundColor: kMainColor,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (BuildContext _) {
        double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

        return Container(
          height: 400 + keyboardHeight, // Adjust as needed
          margin: EdgeInsets.only(top: 10.h),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            color: kMainColor,
          ),
          child: task,
        );
      },
      isScrollControlled: true,
    );
  }
}
