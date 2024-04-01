import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:garage_api/garage_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:postcode_repository/postcode_repository.dart';

///This implementation uses firebase for the backend
///the rest of the location features are done using free on device services from the imported packages
class CloudGarageApi implements GarageApi {
  final PostcodeRepository _postcodeRepo = PostcodeRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
    if(id == (_auth.currentUser?.uid ?? '')) {
      try {
    await _auth.currentUser!.delete();
    log("User account deleted successfully.");
  } catch (error) {
    log("Failed to delete user account: $error");
    // Handle error appropriately, such as displaying a message to the user.
  }
    }
  }

  @override
  Future<List<Garage>> arrangeGarageByLocation(
    String? postcode,
    double? lat,
    double? lng,
  ) async {
    List<Garage> garages = await getGarages().first;
    double startLatitude = 0;
    double startLongitude = 0;
    if (postcode != null) {
      Map<String, double> locations =
          await _postcodeRepo.lookupPostCodeCoordinates(postcode);
      if (locations.isNotEmpty) {
        startLatitude = locations['latitude'] ?? startLatitude;
        startLongitude = locations['longitude'] ?? startLongitude;
      } else {
        // Handle case where postcode couldn't be found
        // For example, show an error message or fallback to default coordinates
      }
    } else{
      startLatitude = lat ?? startLatitude;
      startLongitude = lng ?? startLongitude;
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

  @override
  Future<Garage> getGarage(String garageID) async {
    DocumentSnapshot snapshot = await _garagesCollection.doc(garageID).get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      print('========================================$data================================================');
      return Garage.fromJson(data);
    } else {
      throw Exception('Garage with ID $garageID not found');
    }
  }
}
