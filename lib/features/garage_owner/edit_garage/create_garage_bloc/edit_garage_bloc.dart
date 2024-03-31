import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garage_repository/garage_repository.dart';

part 'edit_garage_event.dart';
part 'edit_garage_state.dart';

class EditGarageBloc extends Bloc<EditGarageEvent, EditGarageState> {
  final GarageRepository garageRepository;
  EditGarageBloc(this.garageRepository) : super(InitalState()) {
    on<SaveGarage>((event, emit) async{
      emit(UpdatingState());
      try {
        await garageRepository.saveGarages(event.garage);
        emit(const UpdatedState(message: 'Updated Succesfully'));
      } catch (e) {
        emit(ErrorState(message: e.toString()));
      }
    });

    on<DeleteGarage>((event, emit) async{
      emit(UpdatingState());
      try {
        await garageRepository.deleteGarage(event.garageID);
        emit(const UpdatedState(message: 'Deleted Garage Succesfully'));
      } catch (e) {
        emit(ErrorState(message: e.toString()));
      }
    });
  }
}
