part of 'booking_bloc.dart';

// Define the Bloc events
abstract class BookingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class BookingCancelled extends BookingEvent{}

class FetchBookings extends BookingEvent {
  final Garage garage;

  FetchBookings({required this.garage});
}

class ResetBookings extends BookingEvent {}

class AddServices extends BookingEvent{
  final Garage garage;
  final Map<String, double> selectedServices;

  final bool isSubset = true;

  AddServices(this.selectedServices, this.garage);
  @override
  List<Object?> get props => [selectedServices];
}

class FowardFinalServices extends BookingEvent{
  final Garage garage;
  final Map<String, double> selectedServices;

  final bool isSubset = true;

  FowardFinalServices(this.selectedServices, this.garage);
  @override
  List<Object?> get props => [selectedServices];
}

