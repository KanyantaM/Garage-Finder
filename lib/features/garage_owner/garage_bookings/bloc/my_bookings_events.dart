part of 'my_bookings_bloc.dart';

abstract class SaloonBookingEvent extends Equatable{}

class FetchAllBookingsEvent extends SaloonBookingEvent{
  final int type;
  final bool isCustomer;

  FetchAllBookingsEvent({required this.isCustomer, required this.type});
  @override
  List<Object?> get props => [type, isCustomer];
  
}

class DeleteBooking extends SaloonBookingEvent{
  final DateTime bookingId;
  final String reason;
  final String serviceId;
  final String customerId;

  DeleteBooking(this.bookingId, this.reason, this.serviceId, this.customerId);
  @override
  List<Object?> get props => [bookingId, reason];
}

class RequestStartedBookings extends SaloonBookingEvent{
  @override 
  List<Object?> get props => [];
} 