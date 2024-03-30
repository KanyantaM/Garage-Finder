import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final String userID = FirebaseAuth.instance.currentUser!.uid;

// final CollectionReference baberCollection =
//     FirebaseFirestore.instance.collection('babers');
// final CollectionReference categoriesCollection =
//     FirebaseFirestore.instance.collection('categories');
final CollectionReference userCollection =
    FirebaseFirestore.instance.collection('users');
final CollectionReference saloonCollection = FirebaseFirestore.instance.collection('saloons');


// Future<List<CateGory>> getCategoriesFromFirestore () async{
//   final querySnapshot = await baberCollection.get();
//       return querySnapshot.docs
//           .map((doc) => CateGory.fromFirestore(documentSnapshot: doc))
//           .toList();
// }





// void deleteCategoryFromFirestore(String id) async{
// await categoriesCollection.doc(id).delete();
// }

// void addNewCategoryToFirestore(CateGory category) async {
//   await categoriesCollection.add(category.toFirestore());
// }

Future<List<DateTimeRange>> fetchClosedTimes(String id) async {
  // Get the CollectionReference to the schedule collection
  CollectionReference scheduleCollection =
      saloonCollection.doc(id)
      .collection('schedule');

  // Get a QuerySnapshot of all documents in the schedule collection
   QuerySnapshot snapshot = await scheduleCollection.get();

  // Iterate over the QuerySnapshot and get the DateTimeRanges from each document
  List<DateTimeRange> closedTimes = [];
  for (DocumentSnapshot document in snapshot.docs) {
    List<Map<String, dynamic>> closedTimesData =
        document.get('closedTimes');
    closedTimes.addAll(closedTimesData.map((data) {
      return DateTimeRange(
        start: data['start'] as DateTime,
        end: data['end'] as DateTime,
      );
    }));
  }

  // Return the list of DateTimeRanges
  return closedTimes;
}

Future<String> uploadXfile(XFile? imageFile, String folderName) async {
  try {
    firebase_storage.Reference storageReference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('$folderName/${DateTime.now().millisecondsSinceEpoch}');

    // Upload the file to Firebase Storage
    await storageReference.putFile(File(imageFile!.path));

    // Get the download URL of the uploaded file
    String downloadURL = await storageReference.getDownloadURL();

    return downloadURL;
  } catch (e) {
    Future.error('Error uploading image: $e');
    return '';
  }
}


