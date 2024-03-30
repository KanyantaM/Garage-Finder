import 'dart:io';

import 'package:booking_calendar/booking_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CloudStorageBookingApi {
  final String userID = FirebaseAuth.instance.currentUser!.uid;

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference garagesCollection =
      FirebaseFirestore.instance.collection('garages');

  Future<List<DateTimeRange>> fetchClosedTimes(String id) async {
    // Get the CollectionReference to the schedule collection
    CollectionReference scheduleCollection =
        garagesCollection.doc(id).collection('schedule');

    // Get a QuerySnapshot of all documents in the schedule collection
    QuerySnapshot snapshot = await scheduleCollection.get();

    // Iterate over the QuerySnapshot and get the DateTimeRanges from each document
    List<DateTimeRange> closedTimes = [];
    for (DocumentSnapshot document in snapshot.docs) {
      List<Map<String, dynamic>> closedTimesData = document.get('closedTimes');
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
      firebase_storage.Reference storageReference = firebase_storage
          .FirebaseStorage.instance
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

//this is for the booking screen
  CollectionReference<BookingService> getBookingStream(String garageId) {
    return garagesCollection
        .doc(garageId)
        .collection('bookings')
        .withConverter<BookingService>(
            fromFirestore: (snapshots, _) =>
                BookingService.fromJson(snapshots.data()!),
            toFirestore: (snapshots, _) {
              return snapshots.toJson();
            });
  }

  Future<void> rateBookingInFirestore(
      {required BookingService bookingService, required int rating}) async {
    CollectionReference bookings = FirebaseFirestore.instance
        .collection('garages')
        .doc(bookingService.serviceProviderId)
        .collection('bookings');
    QuerySnapshot querySnapshot = await bookings
        .where('bookingStart',
            isEqualTo: bookingService.bookingStart.toIso8601String())
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      await bookings
          .doc(querySnapshot.docs.first.id)
          .update({'rating': rating});
    }
  }

  Future<dynamic> uploadBookingToFirebase(
      {required BookingService newBooking, required String garageId}) async {
    {
      CollectionReference bookings = FirebaseFirestore.instance
          .collection('garages')
          .doc(garageId)
          .collection('bookings');
      await bookings.add(newBooking.toJson());
    }
  }

  Stream<dynamic> getBookingStreamFirebase(
      {required DateTime end,
      required DateTime start,
      required String garageId}) {
    return getBookingStream(garageId)
        .where('bookingStart', isGreaterThanOrEqualTo: start.toIso8601String())
        .where('bookingStart', isLessThanOrEqualTo: end.toIso8601String())
        .snapshots();
  }

  List<DateTimeRange> convertStreamResultToFirebase(
      {required dynamic streamResult}) {
    List<DateTimeRange> converted = [];
    for (int i = 0; i < streamResult.size; i++) {
      final item = streamResult.docs[i].data();

      converted.add(
          DateTimeRange(start: (item.bookingStart!), end: (item.bookingEnd!)));
    }
    return converted;
  }

  Stream<List<BookingService>> getBookingServicesStream({
    required bool isCustomer,
  }) {
    if (isCustomer) {
      return FirebaseFirestore.instance
          .collection('garages')
          .snapshots()
          .asyncMap(
        (QuerySnapshot garagesSnapshot) async {
          List<String> garageIds =
              garagesSnapshot.docs.map((garage) => garage.id).toList();

          return await Future.wait(garageIds.map((garageId) async {
            var bookingSnapshot = await FirebaseFirestore.instance
                .collection('garages')
                .doc(garageId)
                .collection('bookings')
                .where('userId', isEqualTo: userID)
                .get();

            return bookingSnapshot.docs
                .map((doc) => BookingService.fromJson(doc.data()))
                .toList();
          }));
        },
      ).map((List<List<BookingService>> nestedList) =>
              nestedList.expand((list) => list).toList());
    } else {
      return FirebaseFirestore.instance
          .collection('garages') // Change to 'babers' collection
          .snapshots()
          .asyncMap(
        (QuerySnapshot garagesSnapshot) async {
          List<String> garageIds =
              garagesSnapshot.docs.map((garage) => garage.id).toList();

          return await Future.wait(garageIds.map((garageId) async {
            var bookingSnapshot = await FirebaseFirestore.instance
                .collection('garages')
                .doc(garageId)
                .collection('bookings')
                .where('serviceName', isNotEqualTo: 'repeat')
                .get();

            return bookingSnapshot.docs
                .map((doc) => BookingService.fromJson(doc.data()))
                .toList();
          }));
        },
      ).map((List<List<BookingService>> nestedList) =>
              nestedList.expand((list) => list).toList());
    }
  }

  Future<void> deleteMyBooking(
      DateTime bookingStart, String reason, String serviceId) async {
    // Get the reference to the document you want to delete
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('garages')
        .doc(serviceId)
        .collection('bookings')
        .where('bookingStart', isEqualTo: bookingStart.toIso8601String())
        .get();

    // Check if there's a document with the specified bookingStart
    if (querySnapshot.docs.isNotEmpty) {
      // Delete the document
      await FirebaseFirestore.instance
          .collection('garages')
          .doc(serviceId)
          .collection('bookings')
          .doc(querySnapshot.docs.first.id)
          .delete();
    }
  }
}

class ScheduleManipulator {
  final String garageId;
  late CollectionReference schedulesCollection;

  ScheduleManipulator({required this.garageId}) {
    schedulesCollection = FirebaseFirestore.instance
        .collection('garages')
        .doc(garageId)
        .collection('schedules');
  }

  

Future<Map<int, List<TimeOfDay>>> fetchWorkingDaysAndHours() async {
  QuerySnapshot workingDaysAndHoursSnapshot =
      await schedulesCollection.where('type', isEqualTo: 'working_day').get();

  Map<int, List<TimeOfDay>> result = {};

  for (QueryDocumentSnapshot doc in workingDaysAndHoursSnapshot.docs) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    int day = data['day'];
    List<String> startTimeString = (data['startTime'] as String).split(':');
    List<String> endTimeString = (data['endTime'] as String).split(':');

    TimeOfDay startTime = TimeOfDay(
        hour: int.parse(startTimeString[0]),
        minute: int.parse(startTimeString[1]));

    TimeOfDay endTime = TimeOfDay(
        hour: int.parse(endTimeString[0]), minute: int.parse(endTimeString[1]));

    // Update result map with day and corresponding TimeRange
    result[day] = [startTime, endTime];
  }

  return result;
}

Future<List<DateTime>> fetchDisabledDates() async {
  QuerySnapshot disabledDatesSnapshot =
      await schedulesCollection.where('type', isEqualTo: 'disabled_date').get();

  List<DateTime> result = [];

  for (QueryDocumentSnapshot doc in disabledDatesSnapshot.docs) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Assuming 'date' is a Timestamp field, convert it to DateTime
    DateTime date = (data['date'] as Timestamp).toDate();

    result.add(date);
  }

  return result;
}

List<DateTimeRange> generatePauseSlots(
    Map<int, List<TimeOfDay>> workingDaysAndHours) {
  List<DateTimeRange> nonWorkingHours = [];
  DateTime now = DateTime.now();

  for (var week = 0; week<4; week++) {
  for (int weekday in workingDaysAndHours.keys.toList()) {
    nonWorkingHours.add(DateTimeRange(
      start: DateTime(
          now.year,
          now.month,
          now.day + (weekday - 1) + week*7,
          workingDaysAndHours[weekday]?.last.hour ?? 0,
          workingDaysAndHours[weekday]?.last.minute ?? 0),
      end: DateTime(
        now.year,
        now.month,
        now.day +  (weekday ) + week*7,
        workingDaysAndHours[(weekday % 7) + 1]?.first.hour ?? 0,
        workingDaysAndHours[(weekday % 7) + 1]?.first.minute ?? 0,
      ),
    ));
  }
}
  return nonWorkingHours;
}

List<DateTimeRange> convertBookingListToDateTimeRanges(
      List<BookingService> bookings) {
    List<DateTimeRange> convertedBookings = [];
    for (var booking in bookings) {
      convertedBookings.add(DateTimeRange(
        start: booking.bookingStart,
        end: booking.bookingEnd,
      ));
    }
    return convertedBookings;
  }
}