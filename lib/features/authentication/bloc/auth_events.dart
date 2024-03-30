part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable{
  @override
  List<Object> get props => [];
}

//When the user signing in with email and password this even is called and the [authrepository] is called to sign in the user
class SignInRequested extends AuthEvent{
  final String email;
  final String password;

  SignInRequested(this.email, this.password);
}

//When the user signing up with email and password this even is called and the [authrepository] is called to sign in the user
class SignUpRequested extends AuthEvent{
  final String email;
  final String password;
  final String phone;

  SignUpRequested(this.email, this.password, this.phone);
}

//when the user siging in with google this event is called and the [authrepository] is called to sign in the user
class GarageOwnerSignIn extends AuthEvent{

}

class CarOwnerSignIn extends AuthEvent{

}

//when the user signs out
class SignOutRequested extends AuthEvent{

}