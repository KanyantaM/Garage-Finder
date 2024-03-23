part of 'find_garage_bloc.dart';
// find_garage_event.dart

abstract class FindGarageState extends Equatable {
  const FindGarageState();

  @override
  List<Object> get props => [];
}

class FindGarageInitial extends FindGarageState {}

class FindGarageLoading extends FindGarageState {}

class FindGarageLoaded extends FindGarageState {
  final List<Garage> garages;

  const FindGarageLoaded({required this.garages});

  @override
  List<Object> get props => [garages];

  @override
  String toString() => 'FindGarageLoaded { garages: $garages }';
}

class FindGarageError extends FindGarageState {
  final String message;

  const FindGarageError({required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'FindGarageError { message: $message }';
}