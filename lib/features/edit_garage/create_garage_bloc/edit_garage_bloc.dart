import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garage_repository/garage_repository.dart';

part 'edit_garage_event.dart';
part 'edit_garage_state.dart';

class EditGarageBloc extends Bloc<EditGarageEvent, EditGarageState> {
  final GarageRepository garageRepository;
  EditGarageBloc(this.garageRepository) : super(UpdatedState()) {
    on<SaveGarage>((event, emit) async{
      emit(UpdatingState());
      try {
        await garageRepository.saveGarages(event.garage);
      } catch (e) {
        emit(ErrorState(message: e.toString()));
      }
    });

    on<DeleteGarage>((event, emit) async{
      emit(UpdatingState());
      try {
        await garageRepository.deleteGarage(event.garageID);
      } catch (e) {
        emit(ErrorState(message: e.toString()));
      }
    });
  }
}
