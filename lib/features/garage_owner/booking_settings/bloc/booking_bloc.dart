import 'package:cloud_storage_booking_api/cloud_storage_booking_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garage_repository/garage_repository.dart';
part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final String garageId;

  BookingBloc(this.garageId) : super(BookingInitial()) {
    ScheduleManipulator schedule = ScheduleManipulator(garageId: garageId);

    on<StartEditing>((event, emit) => emit(EditingServicesState()),);
    on<AddSchedules>((event, emit) async {
      try {
        // Add working days and hours to Firestore
        await schedule. addWorkingDaysAndHours(event.workingDaysAndHours);

        // Add disabled dates to Firestore
        await schedule. addDisabledDates(event.disabledDates);

        // Emit a successfully edited schedule state
        emit(SuccessfullyEditedSchedule());
      } catch (e) {
        // Handle errors and emit an error state if necessary
        emit(ErrorEditingSchedule(error: e.toString()));
      }
    });

    on<FetchSchedules>((event, emit) async {
      try {
        // Fetch working days and hours from Firestore
        Map<int, List<TimeOfDay>> workingDaysAndHours =
            await schedule. fetchWorkingDaysAndHours();

        // Fetch disabled dates from Firestore
        List<DateTime> disabledDates = await schedule. fetchDisabledDates();

        // Emit the fetched schedules state
        emit(FetchedSchedules(
          workingDaysAndHours: workingDaysAndHours,
          disabledDates: disabledDates,
        ));
      } catch (e) {
        // Handle errors and emit an error state if necessary
        emit(ErrorFetchingSchedules(error: e.toString()));
      }
    });
  }

 
}


