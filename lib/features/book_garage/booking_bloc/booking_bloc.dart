import 'package:booking_calendar/booking_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc() : super(BookingInitial()) {
    on<BookingCancelled>(
      (event, emit) => emit(BookingInitial()),
    );
    on<FetchBookings>(
      (event, emit) async {
        try {
          List<DateTimeRange> generatePauseSlots = await fetchClosedTimes();
          Stream<dynamic> getBookings(
              {required DateTime end, required DateTime start}) {
            return getBookingStreamFirebase(
                end: end, start: start, baberid: event.baber.baberId!);
          }

          Future<dynamic> uploadBooking({required BookingService newBooking}) {
            return uploadBookingToFirebase(
                newBooking: newBooking, baberId: event.baber.baberId!);
          }

          emit(BookingLoaded(
              getBookingStream: getBookings,
              uploadBooking: uploadBooking,
              convertStreamResultToDateTimeRanges:
                  convertStreamResultToFirebase,
              generatePauseSlots: generatePauseSlots));
        } catch (e) {
          emit(BookingError("Error fetching bookings\n $e"));
        }
      },
    );
    on<AddServices>(((event, emit) {
      if (event.selectedServices.isEmpty) {
        emit(VerficationServicesError(
            'No service selected\nPlease select a service'));
      } else if (event.baber.services.keys
          .toSet()
          .containsAll(event.selectedServices.keys)) {
        emit(VerifiedSelectedServices());
      } else {
        emit(VerficationServicesError('Invalid Entry'));
      }
    }));

    on<FowardFinalServices>(((event, emit) {
      emit(BookingInitial());
    }));

    on<ResetBookings>(((event, emit) {
      emit(BookingInitial());
    }));
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

  //Fetching the schedules
}

final CollectionReference schedulesCollection =
    FirebaseFirestore.instance.collection('schedules');

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
