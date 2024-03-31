import 'package:cloud_storage_booking_api/cloud_storage_booking_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'my_booking_state.dart';
part 'my_bookings_events.dart';

class SaloonBookingBloc extends Bloc<SaloonBookingEvent, SaloonBookingState> {
  SaloonBookingBloc() : super(AllSaloonBookingInitialState()) {
    CloudStorageBookingApi bookingApi = CloudStorageBookingApi();
    on<FetchAllBookingsEvent>((event, emit) async {
      try {
        emit(AllSaloonBookingLoadingState());
        List<BookingService> bookings =
            await bookingApi. getBookingServicesStream(isCustomer: false).first;
        // List<Cancellation> cancellations = await getCancellationsStream().first;

        // int numCancellations = cancellations.length;

        int activeBookings = bookings.where((element) => element.bookingEnd.compareTo(DateTime.now()) > 0).length;
        double totalEarnings = 0;
        for (var booking in bookings) {
          if(booking.confirmed ?? false) {
            totalEarnings += booking.servicePrice!;
          }
        }

        // Calculate daily and monthly earnings
        Map<DateTime, double> dailyEarnings = {};
        Map<String, double> monthlyEarnings = {};

        for (var booking in bookings) {
          if (booking.confirmed ?? false) {
            DateTime date = booking.bookingStart;
          String monthKey = '${date.year}-${date.month}';

          // Daily earnings
          dailyEarnings.update(DateTime(date.year, date.month, date.day),
              (value) => value + booking.servicePrice!,
              ifAbsent: () => booking.servicePrice!);

          // Monthly earnings
          monthlyEarnings.update(
              monthKey, (value) => value + booking.servicePrice!,
              ifAbsent: () => booking.servicePrice!);
          }
          
        }
        emit(AllSaloonBookingLoadedState(totalEarnings, activeBookings, 2, bookings, dailyEarnings, monthlyEarnings));
      } catch (error) {
        emit(AllSaloonBookingErrorState('An error occurred: $error'));
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
        await bookingApi. deleteSaloonBooking(event.bookingId, event.reason, event.serviceId, event.customerId);
        emit(DeletedSaloonBookingState());
        Future.delayed(const Duration(seconds: 1));
        emit(AllSaloonBookingInitialState());
      } catch (error) {
        emit(AllSaloonBookingErrorState('An error occurred: $error'));
      }
    });
  }
}
