part of 'edit_garage_bloc.dart';

abstract class EditGarageState extends Equatable {
  const EditGarageState();  

  @override
  List<Object> get props => [];
}

class InitalState extends EditGarageState{
  
}

class UpdatingState extends EditGarageState {

}

class ErrorState extends EditGarageState {
 final String message;

  const ErrorState({required this.message});

 @override
  List<Object> get props => [message];
}

class UpdatedState extends EditGarageState {
  final String message;

  const UpdatedState({required this.message});

  @override
  List<Object> get props => [message];

}
