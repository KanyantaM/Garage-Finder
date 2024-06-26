import 'package:cloud_storage_booking_api/cloud_storage_booking_api.dart';
import 'package:fixtex/features/car_owner/book_garage/booking_cubit/booking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:garage_repository/garage_repository.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final CloudStorageBookingApi bookingApi;
  BookingBloc(this.bookingApi) : super(BookingInitial()) {
    on<BookingCancelled>(
      (event, emit) => emit(BookingInitial()),
    );
    on<FetchBookings>(
      (event, emit) async {
        Garage garage = event.garage;
        try {
          List<DateTimeRange> generatePauseSlots = await bookingApi.fetchClosedTimes(garage.id);
          Stream<dynamic> getBookings(
              {required DateTime end, required DateTime start}) {
            return bookingApi.getBookingStreamFirebase(
                end: end, start: start, garageId: garage.id);
          }

          Future<dynamic> uploadBooking({required BookingService newBooking}) {
            return bookingApi.uploadBookingToFirebase(
                newBooking: newBooking, garageId: garage.id).whenComplete(() => hasBookedCubit.hasBooked());
          }

          emit(BookingLoaded(
              getBookingStream: getBookings,
              uploadBooking: uploadBooking,
              convertStreamResultToDateTimeRanges:
                  bookingApi.convertStreamResultToFirebase,
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
      } else if (event.garage.services.keys
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

  
}
