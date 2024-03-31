part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable{}

//when the user presses sign in or signup the state is changed from loading to authenticated
class Loading extends AuthState{
  @override
  List<Object?> get props => [];
}

//when the user is authenticated, state is changed to authenticated
class Authenticated extends AuthState{
  final bool isGarage;
  final String id;

  Authenticated({required this.id, required this.isGarage});
  @override
  List<Object?> get props => [];
}

// this is the initial state of the bloc. when the user is not authenticated the state is changed to unauthenticated
class AccountType extends AuthState{
  final bool isGarage;

  AccountType({required this.isGarage});
  @override
  List<Object?> get props => [isGarage];
}

//when the user is authenticated, state is changed to authenticated
class Unauthenticated extends AuthState{
  @override
  List<Object?> get props => [];
}

// the error that occurs when state is changing
class AuthError extends AuthState{
  final String error;

  AuthError(this.error);

  @override
  List<Object?> get props => [];
}