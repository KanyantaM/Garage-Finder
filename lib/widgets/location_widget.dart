import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class LocationWidget extends StatefulWidget {
  final Function(double lat, double long, String? address) onTap;
  const LocationWidget({super.key, required this.onTap});

  @override
  _LocationWidgetState createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  late GoogleMapController _mapController;
  LatLng _selectedLocation =  LatLng(51.5,0.2);
  TextEditingController _addressController = TextEditingController();
  Marker _location = Marker(markerId: MarkerId('Location'), position: LatLng(51.5, 0.2));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            markers: {_location},
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _selectedLocation,
              zoom: 10,
            ),
            onTap: _selectLocation,
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Enter Address',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: _searchLocation,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _saveLocation(context);
                  },
                  child: Text('Save Location'),
                ),
              ],
            ),
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
      print('Location not found');
    }
  }

  void _saveLocation(BuildContext context) {
    if (_selectedLocation != null) {
      // Save the selected location (latitude and longitude) to database or wherever you need to save it
      double latitude = _selectedLocation.latitude;
      double longitude = _selectedLocation.longitude;

      // Example of what you might do next (displaying latitude and longitude)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Location saved: Latitude: $latitude, Longitude: $longitude'),
      ));

      // You can also navigate to a new screen or perform any other action here after saving the location
    } else {
      // Handle case where no location is selected
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select a location.'),
      ));
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: LocationWidget(onTap: (double lat, double long, String? address) {  },),
  ));
}
