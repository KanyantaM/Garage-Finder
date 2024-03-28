part of 'edit_garage_bloc.dart';

abstract class EditGarageEvent extends Equatable {
  const EditGarageEvent();
  @override
  List<Object> get props => [];
}

class SaveGarage extends EditGarageEvent {
  final Garage garage;

  const SaveGarage({required this.garage,});

  @override
  List<Object> get props => [garage];

  @override
  String toString() => 'SaveGarage { postcode: ${garage.name}}';
}

class DeleteGarage extends EditGarageEvent{
  final String garageID;

  const DeleteGarage({required this.garageID});

  @override
  List<Object> get props => [garageID];

  @override

  String toString() => 'DeleteGarage {ID: $garageID}';
}
