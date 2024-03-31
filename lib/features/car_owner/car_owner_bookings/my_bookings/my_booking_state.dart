part of 'my_bookings_bloc.dart';


abstract class MyBookingState extends Equatable {
  @override
  List<Object?> get props => [];
}

//all my bookings
class AllMyBookingInitialState extends MyBookingState {}

class AllMyBookingLoadingState extends MyBookingState {}

class AllMyBookingLoadedState extends MyBookingState {
  final List<BookingService> myBookingStream;
  

  AllMyBookingLoadedState(this.myBookingStream);

  @override
  List<Object?> get props => [myBookingStream];
}

//my bookigs awaiting
class MyAwaitedBookingInitialState extends MyBookingState {}

class MyAwaitedBookingLoadingState extends MyBookingState {}

class MyAwaitedBookingLoadedState extends MyBookingState {
  final List<BookingService> appoinents;

  MyAwaitedBookingLoadedState(this.appoinents);

  @override
  List<Object?> get props => [appoinents];
}

//

class DeletedMyBookingState extends MyBookingState{

  DeletedMyBookingState();

  @override
  List<Object?> get props => [];
}

class AllMyBookingErrorState extends MyBookingState {
  final String message;

  AllMyBookingErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
