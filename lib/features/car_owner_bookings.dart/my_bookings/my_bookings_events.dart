part of 'my_bookings_bloc.dart';

abstract class MyBookingEvent extends Equatable{}

class FetchAllBookingsEvent extends MyBookingEvent{
  final int type;
  final bool isCustomer;

  FetchAllBookingsEvent({required this.isCustomer, required this.type});
  @override
  List<Object?> get props => [type, isCustomer];
  
}

class DeleteBooking extends MyBookingEvent{
  final DateTime bookingId;
  final String reason;
  final String serviceId;

  DeleteBooking(this.bookingId, this.reason, this.serviceId);
  @override
  List<Object?> get props => [bookingId, reason];
}

class RequestStartedBookings extends MyBookingEvent{
  @override 
  List<Object?> get props => [];
} 