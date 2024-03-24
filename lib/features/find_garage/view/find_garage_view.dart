import 'package:fixtex/widgets/custom_searchbar.dart';
import 'package:fixtex/widgets/service_provider.dart';
import 'package:fixtex/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:garage_repository/garage_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:postcode_repository/postcode_repository.dart';

import '../bloc/find_garage_bloc.dart';

class FindGarageView extends StatefulWidget {
  const FindGarageView({Key? key}) : super(key: key);

  @override
  State<FindGarageView> createState() => _FindGarageViewState();
}

class _FindGarageViewState extends State<FindGarageView> {
  late GoogleMapController mapController;
  final TextEditingController postcodeController = TextEditingController();
  final PostcodeRepository postcodeRepository = PostcodeRepository();
  LatLng _target = const LatLng(51.5, 0.13);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FindGarageBloc, FindGarageState>(
        builder: (context, state) {
          print('=================================STATE: ${state.toString()}===================================');
          if (state is FindGarageLoading) {
            // Show loading indicator
            return ShimmerLoading(isLoading: true, child: buildLoadingView());
          } else if (state is FindGarageLoaded) {
            // Handle loaded state
            return buildLoadedView(state.garages);
          } else if (state is FindGarageError) {
            // Handle error state
            return Center(child: Text(state.message));
          } else {
            // Initial state
            return FutureBuilder(
              future: _determinePosition(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    // Return a widget to handle the case when there is no connection
                    return const Center(child: Text('No Connection'));
                  case ConnectionState.waiting:
                    // Return a widget to show a loading indicator while waiting for the future to complete
                    return const Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                    // Return a widget to handle the case when the future is actively processing
                    return const Center(child: Text('Processing...'));
                  case ConnectionState.done:
                    // Return a widget based on the result of the future
                    if (snapshot.hasError) {
                      // Return a widget to handle the case when there is an error
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      // Return a widget to handle the case when the future completes successfully
                      // if (state is FindGarageInitial) {
                      //   StreamBuilder(
                      //     stream: state.streamListGarages,
                      //     builder: (context, snapshot) {
                      //       switch (snapshot.connectionState) {
                      //         case ConnectionState.none:
                      //           // Return a widget to handle the case when there is no connection
                      //           return const Center(
                      //               child: Text('No Connection'));
                      //         case ConnectionState.waiting:
                      //           // Return a widget to show a loading indicator while waiting for the future to complete
                      //           return const Center(
                      //               child: CircularProgressIndicator());
                      //         case ConnectionState.active:
                      //           // Return a widget to handle the case when the future is actively processing
                      //           return const Center(
                      //               child: Text('Processing...'));
                      //         case ConnectionState.done:
                      //           // Return a widget based on the result of the future
                      //           if (snapshot.hasError) {
                      //             // Return a widget to handle the case when there is an error
                      //             return Center(
                      //                 child: Text('Error: ${snapshot.error}'));
                      //           } else {
                      //             // Return a widget to handle the case when the future completes successfully
                      //             context.read<FindGarageBloc>().add(
                      //                 SearchByPhoneLocation(
                      //                     latitude: snapshot.data!.latitude,
                      //                     longitude: snapshot.data!.longitude));
                      //             return ShimmerLoading(
                      //                 isLoading: true,
                      //                 child: buildLoadingView());
                      //           }
                      //       }
                      //     },
                      //   );
                      // }

                      context.read<FindGarageBloc>().add(SearchByPhoneLocation(
                          latitude: snapshot.data!.latitude,
                          longitude: snapshot.data!.longitude));
                      print('===============================called the event====================================================================');
                      return ShimmerLoading(
                          isLoading: true, child: buildLoadingView());
                    }
                }
              },
            );
// print('=================================all things come to last========================================');
//             return ShimmerLoading(isLoading: true, child: buildLoadingView());
          }
        },
      ),
    );
  }

  Column buildLoadingView() {
    print('================================In the fucking loading view========================================');
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 60),
          child: CustomSearchBar(),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Container(
              // Replace this Container with Google Maps widget
              color: Colors.black,
              child: const Center(
                child: Text('Google Map'),
              )),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return const Column(
                children: [
                  AutoServiceTile(
                    isLoading: true,
                  ),
                  Divider(),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Set<Marker> _buildMarkers(List<Garage> garages) {
    return {
      for (Garage garage in garages)
        Marker(
          markerId: MarkerId(garage.address),
          position: LatLng(garage.lat, garage.lng),
          infoWindow: InfoWindow(title: garage.name),
        ),
    };
  }

  Widget buildLoadedView(List<Garage> garages) {
    // Implement how to build the view when data is loaded
    print('In the loaded view');
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 60),
          child: CustomSearchBar(
            controller: postcodeController,
            suggestionStream: postcodeRepository
                .autocompletePostcodes(postcodeController.text),
            onChanged: (value) async {
              // Handle search query changes here
              if (value != '') {
                List<String> propablePostCodes =
                    await postcodeRepository.autocompletePostcodes(value).first;
                String propablePostCode = propablePostCodes.first;
                Map<String, double> location = await postcodeRepository
                    .lookupPostCodeCoordinates(propablePostCode);
                setState(() {
                  _target = LatLng(location['latitude'] ?? _target.latitude,
                      location['longitude'] ?? _target.longitude);
                });
              }
            },
            onSubmitted: (value) {
              // Handle search query submission here
              context.read<FindGarageBloc>().add(SearchByPostcode(
                    postcode: postcodeController.text,
                  ));
            },
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _target,
              zoom: 12,
            ),
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                mapController = controller;
              });
            },
            markers: _buildMarkers(garages),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: garages.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  AutoServiceTile(
                    garage: garages[index],
                    isLoading: false,
                  ),
                  const Divider(),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

}
