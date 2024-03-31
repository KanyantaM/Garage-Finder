part of 'booking_bloc.dart';


// Define the Bloc events
abstract class BookingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchBookings extends BookingEvent {}

class StartEditing extends BookingEvent{}

class AddServices extends BookingEvent{
  final Garage garage;
  final Map<String, double> selectedServices;

  final bool isSubset = true;

  AddServices(this.selectedServices, this.garage);
  @override
  List<Object?> get props => [selectedServices];
}



class AddSchedules extends BookingEvent{
  final Map<int, List<TimeOfDay>> workingDaysAndHours;
  final List<DateTime> disabledDates;
  final int disabledDays;

  AddSchedules({required this.workingDaysAndHours, required this.disabledDates, required this.disabledDays});
}

class FetchSchedules extends BookingEvent{}
