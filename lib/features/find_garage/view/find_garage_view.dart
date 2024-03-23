import 'package:fixtex/widgets/custom_searchbar.dart';
import 'package:fixtex/widgets/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search Bar
          const CustomSearchBar(),
          const SizedBox(
            height: 20,
          ),

          // Google Map
          Expanded(
              child:
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(37.7749, -122.4194), // San Francisco coordinates
                  zoom: 12,
                ),
                onMapCreated: (GoogleMapController controller) {
                  setState(() {
                    mapController = controller;
                  });
                },
                markers: {
                  // You can add markers for auto shops here
                  Marker(
                    markerId: MarkerId('1'),
                    position: LatLng(37.7749, -122.4194), // San Francisco coordinates
                    infoWindow: InfoWindow(title: 'Auto Shop 1'),
                  ),
                },
              ),
              ),
          // Scrollable List of Auto Shops
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Example count, replace with actual data
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    AutoServiceTile(
                      name: 'Auto Shop $index',
                      address: 'Address of Auto Shop $index',
                      imagePath:
                          'assets/images/dummy.png', // Replace with actual image path
                      rating: 4.5, // Replace with actual rating
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
