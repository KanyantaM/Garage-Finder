import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garage_api/garage_api.dart';

class FirestoreGarageApi implements GarageApi {
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
}
