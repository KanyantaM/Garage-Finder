part of 'booking_bloc.dart';

// Define the Bloc events
abstract class BookingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class BookingCancelled extends BookingEvent{}

class FetchBookings extends BookingEvent {
  final Baber baber;

  FetchBookings({required this.baber});
}

class ResetBookings extends BookingEvent {}

class AddServices extends BookingEvent{
  final Baber baber;
  final Map<String, double> selectedServices;

  final bool isSubset = true;

  AddServices(this.selectedServices, this.baber);
  @override
  List<Object?> get props => [selectedServices];
}

class FowardFinalServices extends BookingEvent{
  final Baber baber;
  final Map<String, double> selectedServices;

  final bool isSubset = true;

  FowardFinalServices(this.selectedServices, this.baber);
  @override
  List<Object?> get props => [selectedServices];
}

