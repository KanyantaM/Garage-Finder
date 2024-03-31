part of 'booking_bloc.dart';

abstract class BookingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EditingServicesState extends BookingState{}

class ServicesNotSelected extends BookingState {}

class VerifingSelectedServices extends BookingState {}

class VerifiedSelectedServices extends BookingState {}

class VerficationServicesError extends BookingState {
  final String errorMessage;

  VerficationServicesError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class BookingInitial extends BookingState {}

class BookingLoaded extends BookingState {
  final Stream<dynamic>? Function(
      {required DateTime end, required DateTime start}) getBookingStream;
  final Future<dynamic> Function({required BookingService newBooking})
      uploadBooking;
  final List<DateTimeRange> Function({required dynamic streamResult})
      convertStreamResultToDateTimeRanges;

 

  BookingLoaded(
      {required this.getBookingStream,
      required this.uploadBooking,
      required this.convertStreamResultToDateTimeRanges});

  @override
  List<Object?> get props => [getBookingStream, uploadBooking];
}

class BookingError extends BookingState {
  final String errorMessage;

  BookingError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class FetchedPauseSlots extends BookingState{
  final List<DateTimeRange> pauseSlots;

  FetchedPauseSlots(this.pauseSlots);

  @override
  List<Object?> get props => [pauseSlots];
  
}

class SuccessfullyEditedSchedule extends BookingState {

  @override
  List<Object?> get props => [];
}

class ErrorEditingSchedule extends BookingState {
final String error;

  ErrorEditingSchedule({required this.error});
  @override
  List<Object?> get props => [error];
}

class ErrorFetchingSchedules extends BookingState {
final String error;

  ErrorFetchingSchedules({required this.error});
  @override
  List<Object?> get props => [error];
}

class FetchedSchedules extends BookingState{
  final Map<int, List<TimeOfDay>> workingDaysAndHours;
  final List<DateTime> disabledDates;

  FetchedSchedules({required this.workingDaysAndHours, required this.disabledDates});

  @override
  List<Object?> get props => [disabledDates, workingDaysAndHours];

}