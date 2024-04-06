import 'package:cloud_storage_booking_api/cloud_storage_booking_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'my_booking_state.dart';
part 'my_bookings_events.dart';


class MyBookingBloc extends Bloc<MyBookingEvent, MyBookingState> {
  CloudStorageBookingApi bookingApi = CloudStorageBookingApi();
  MyBookingBloc() : super(AllMyBookingInitialState()) {
    on<FetchAllBookingsEvent>((event, emit) async {
      try {
        emit(AllMyBookingLoadingState());
        List<BookingService> bookings =
            await bookingApi. getBookingServicesStream().first;
        emit(AllMyBookingLoadedState(bookings));
      } catch (error) {
        emit(AllMyBookingErrorState('An error occurred: $error'));
      }
    });

    on<DeleteBooking>((event, emit) async {
      try {
        //  NotificationService().showNotification(
        //     id: int.parse(
        //         '${event.bookingId.day}${event.bookingId.month}${event.bookingId.hour}${event.bookingId.minute}'),
        //     title: 'Appointment Cancelled',
        //     body:
        //         'You have cancelled your appointment schedualed for ${event.bookingId}');
        await bookingApi. deleteMyBooking(event.bookingId, event.reason,event.serviceId );
        emit(DeletedMyBookingState());
        Future.delayed(const Duration(seconds: 1));
        emit(AllMyBookingInitialState());
      } catch (error) {
        emit(AllMyBookingErrorState('An error occurred: $error'));
      }
    });
  }
}
