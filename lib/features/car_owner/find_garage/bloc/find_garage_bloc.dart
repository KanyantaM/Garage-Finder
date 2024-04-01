import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:garage_repository/garage_repository.dart';

part 'find_garage_event.dart';
part 'find_garage_state.dart';

class FindGarageBloc extends Bloc<FindGarageEvent, FindGarageState> {
  final GarageRepository garageRepository;

  FindGarageBloc(this.garageRepository) : super(FindGarageInitial(streamListGarages: garageRepository.getGarages())) {
    on<SearchByPostcode>((event, emit) async {
      log('we are in the event handler');
      emit(FindGarageLoading());
      try {
        final garages = await garageRepository
            .searchGarages(event.postcode, null, null,);
        emit(FindGarageLoaded(garages: garages));
      } catch (e) {
        emit(FindGarageError(message: 'Failed to search garages by postcode: $e'));
      }
    });

    on<SearchByMapInteraction>(
      (event, emit) async {
        emit(FindGarageLoading());
      try {
        final garages = await garageRepository
            .searchGarages(null, event.latitude, event.longitude,);
        emit(FindGarageLoaded(garages: garages));
      } catch (e) {
        emit(FindGarageError(message: 'Failed to search garages by map: $e'));
      }
      },
    );

    on<SearchByPhoneLocation>(
      (event, emit) async {
        emit(FindGarageLoading());
      try {
        final garages = await garageRepository
            .searchGarages(null, event.latitude, event.longitude,);
        emit(FindGarageLoaded(garages: garages));
      } catch (e) {
        emit(FindGarageError(message: 'Failed to locate garages using phone location: $e'));
      }
      },
    );
  }
}
