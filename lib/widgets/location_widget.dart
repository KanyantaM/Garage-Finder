import 'dart:developer';

import 'package:fixtex/widgets/custome_text_field.dart';
import 'package:flutter/material.dart';
import 'package:garage_repository/garage_repository.dart' show Garage;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class LocationWidget extends StatefulWidget {
  final Garage garage;
  final Function(double lat, double long, String? address) onTap;
  const LocationWidget({super.key, required this.onTap, required this.garage});

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  late GoogleMapController _mapController;
  LatLng _selectedLocation =  const LatLng(51.5,0.2);
  final TextEditingController _addressController = TextEditingController();
  Marker _location = const Marker(markerId: MarkerId('Location'), position: LatLng(51.5, 0.2));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  markers: {_location},
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _selectedLocation,
                    zoom: 25,
                  ),
                  onTap: _selectLocation,
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: CustomTextField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          hintText: 'Enter Address',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: _searchLocation,
                          ),
                        ),
                      ),),
                
              ],
            ),
          ),
          ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onTap;
                          
                        },
                        child: const Text('Save Location'),
                      ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }


Future<void> _selectLocation(LatLng latLng) async {
  _selectedLocation = latLng;
  _location = Marker(markerId: const MarkerId('Location'), position: latLng);
  
  List<Placemark> placemarks = await placemarkFromCoordinates(
    _selectedLocation.latitude,
    _selectedLocation.longitude,
  );
  
  if (placemarks.isNotEmpty) {
    Placemark placemark = placemarks.first;
    _addressController.text = placemark.street ?? '';
    
    setState(() {
      widget.onTap(
        _selectedLocation.latitude,
        _selectedLocation.longitude,
        _addressController.text,
      );
    });
  }
}


  void _searchLocation() async {
    String address = _addressController.text;
    List<Location> locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      Location location = locations.first;
      _mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(location.latitude, location.longitude),
          15,
        ),
      );
      setState(() {
        _selectedLocation = LatLng(location.latitude, location.longitude);
      });
    } else {
      // Handle error if location not found
      log('Location not found');
    }
  }
}
