part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable{
  @override
  List<Object> get props => [];
}

//When the user signing in with email and password this even is called and the [authrepository] is called to sign in the user
class SignInRequested extends AuthEvent{
  final String email;
  final String password;
  final bool isGarage;

  SignInRequested(this.email, this.password, this.isGarage);
}

//When the user signing up with email and password this even is called and the [authrepository] is called to sign in the user
class SignUpRequested extends AuthEvent{
  final String email;
  final String password;
  final bool isGarage;
  final String name;

  SignUpRequested(this.email, this.password, this.isGarage, this.name, );
}

//when the user siging in with google this event is called and the [authrepository] is called to sign in the user
class GarageOwnerSignIn extends AuthEvent{

}

class CarOwnerSignIn extends AuthEvent{

}

//when the user signs out
class SignOutRequested extends AuthEvent{
final bool isGarage;

  SignOutRequested({required this.isGarage});
}

class Back extends AuthEvent{
  
}
