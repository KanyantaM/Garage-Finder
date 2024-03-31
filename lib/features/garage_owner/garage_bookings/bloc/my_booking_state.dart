part of 'my_bookings_bloc.dart';

abstract class SaloonBookingState extends Equatable {
  @override
  List<Object?> get props => [];
}

//all Saloon bookings
class AllSaloonBookingInitialState extends SaloonBookingState {}

class AllSaloonBookingLoadingState extends SaloonBookingState {}

class AllSaloonBookingLoadedState extends SaloonBookingState {
  final double totalEarnings;
  final int activeBookings;
  // final int totalCancelations;
  final int totalServices;
  final List<BookingService> saloonBookingStream;
  final Map<DateTime, double> dailyEarnings;
  final Map<String, double> monthlyEarnings;

  

  AllSaloonBookingLoadedState(this.totalEarnings, this.activeBookings,  this.totalServices, this.saloonBookingStream, this.dailyEarnings, this.monthlyEarnings);

  @override
  List<Object?> get props => [ totalEarnings, totalServices, activeBookings, saloonBookingStream, dailyEarnings, monthlyEarnings];
}

//Saloon bookigs awaiting
class SaloonAwaitedBookingInitialState extends SaloonBookingState {}

class SaloonAwaitedBookingLoadingState extends SaloonBookingState {}

class SaloonAwaitedBookingLoadedState extends SaloonBookingState {
  final List<BookingService> appoinents;

  SaloonAwaitedBookingLoadedState(this.appoinents);

  @override
  List<Object?> get props => [appoinents];
}

//

class DeletedSaloonBookingState extends SaloonBookingState{

  DeletedSaloonBookingState();

  @override
  List<Object?> get props => [];
}

class AllSaloonBookingErrorState extends SaloonBookingState {
  final String message;

  AllSaloonBookingErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
