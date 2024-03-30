part of 'booking_bloc.dart';

abstract class BookingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ServicesNotSelected extends BookingState {}

class VerifingSelectedServices extends BookingState {}

class FinalVerifiedSelectedServices extends BookingState {
  final Map<String, double> selectedServices;

  FinalVerifiedSelectedServices(this.selectedServices);
}

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

  final List<DateTimeRange> generatePauseSlots;

  BookingLoaded( 
      {required this.getBookingStream,
      required this.uploadBooking,
      required this.convertStreamResultToDateTimeRanges,
      required this.generatePauseSlots});

  @override
  List<Object?> get props => [getBookingStream, uploadBooking, generatePauseSlots];
}

class BookingError extends BookingState {
  final String errorMessage;

  BookingError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
