import 'package:cloud_storage_garage_api/cloud_storage_garage_api.dart';
import 'package:fixtex/consts/colors.dart';
import 'package:fixtex/features/authentication/bloc/auth_bloc.dart';
import 'package:fixtex/screens/car_owner/car_bottom_nav.dart.dart';
import 'package:fixtex/features/authentication/auth/screens/starting_screen.dart';
import 'package:fixtex/screens/garage_owner/garage_bottom_nav.dart';
import 'package:fixtex/widgets/rectangle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garage_repository/garage_repository.dart';

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
          body: BlocConsumer<AuthBloc, AuthState>(listener: (context, state)  {
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
              if (state.isGarage) {
                GarageRepository garageRepository = GarageRepository(garageApi: CloudGarageApi());
               return FutureBuilder<Garage>(
  future: garageRepository.getAGarage(state.id),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      // While data is loading, show a loading indicator
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasError) {
        // If an error occurred while loading data, handle the error
        if(snapshot.error.toString().contains('not found')){
          return GarageBottomNav(
          garage: snapshot.data ?? Garage(
            lat: 51.5,
            lng: 0.2,
            id: state.id,
            name: '',
            address: '',
            rating: 0,
            services: <String, double>{},
            imageUrl: '',
            bio: '',
            phone: '',
          ),
        );
      
        }
        return Center(child: Center(child: Text('Error: ${snapshot.error}')));
      } else {
        // If data is loaded successfully, render the screen with the data
        return GarageBottomNav(
          garage: snapshot.data ?? Garage(
            lat: 51.5,
            lng: 0.2,
            id: state.id,
            name: '',
            address: '',
            rating: 0,
            services: <String, double>{},
            imageUrl: '',
            bio: '',
            phone: '',
          ),
        );
      }
    } else {
      // This is an unexpected case, you may handle it according to your needs
      return Center(child: Text('Unexpected ConnectionState: ${snapshot.connectionState}'));
    }
  },
);

                
              } else {
                return const BottomNav();
              }
              
            }
            if (state is Unauthenticated) {
              {
                return Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/dummy.png"),
                            fit: BoxFit.cover)),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(height: 20,),
                          Container(
                            margin: const EdgeInsets.only(top: 77),
                            child: const Text(
                              "",
                              style: TextStyle(
                                color: kmainBlue,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              RectangleMain(
                                type: 'Garge Owner',
                                onTap: () {
                                  context
                                      .read<AuthBloc>()
                                      .add(GarageOwnerSignIn());
                                },
                              ),
                              const SizedBox(height: 10,)
,                              RectangleMain(
                                type: 'Car Owner',
                                onTap: () {
                                  context
                                      .read<AuthBloc>()
                                      .add(CarOwnerSignIn());
                                },
                              ),
                              const SizedBox(height: 20,)
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
