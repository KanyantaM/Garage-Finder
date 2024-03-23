import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garage_api/garage_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

///This implementation uses firebase for the backend
///the rest of the location features are done using free on device services from the imported packages
class CloudGarageApi implements GarageApi {
  final CollectionReference _garagesCollection =
      FirebaseFirestore.instance.collection('garages');

  @override
  Stream<List<Garage>> getGarages() {
    return _garagesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Garage.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  @override
  Future<void> saveGarage(Garage garage) async {
    await _garagesCollection.doc(garage.id).set(garage.toJson());
  }

  @override
  Future<void> deleteGarage(String id) async {
    final doc = await _garagesCollection.doc(id).get();
    if (!doc.exists) {
      throw GarageNotFoundException();
    }
    await _garagesCollection.doc(id).delete();
  }

  @override
  Future<List<Garage>> arrangeGarageByLocation(
      String? postcode, double? lat, double? lng, List<Garage> garages) async {
    double startLatitude = 0;
    double startLongitude = 0;
    if (postcode != null) {
      List<Location> locations = await locationFromAddress(postcode);
      if (locations.isNotEmpty) {
        startLatitude = locations.first.latitude;
        startLongitude = locations.first.longitude;
      } else {
        // Handle case where postcode couldn't be found
        // For example, show an error message or fallback to default coordinates
      }
    } else if (lat != null && lng != null) {
      startLatitude = lat;
      startLongitude = lng;
    }

    garages.sort((a, b) {
      // Calculate the difference from the targetNumber in absolute terms
      double diffA = Geolocator.distanceBetween(
          startLatitude, startLongitude, a.lat, a.lng);
      double diffB = Geolocator.distanceBetween(
          startLatitude, startLongitude, b.lat, b.lng);

      // Compare the absolute differences
      return diffA.compareTo(diffB);
    });

    return garages;
  }
}
