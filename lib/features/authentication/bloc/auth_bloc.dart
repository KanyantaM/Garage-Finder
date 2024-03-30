import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

part 'auth_events.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository authRepository;

  AuthBloc({required this.authRepository}) : super(Unauthenticated()) {
    //When the user Presses the signin button we will send the SingInRequested event to the AuthBloc to handle it and emit theemti the Authenticated State if the user is authenticated
    on<SignInRequested>((event, emit) async {
      emit(Loading());
      try {
         await authRepository.signInOwner(
             event.email, event.password);
          bool signedIn = authRepository.isOwnerSignedIn();
        if (signedIn) {
          emit(Authenticated());
        } else {
          emit(Unauthenticated());
        }
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(Unauthenticated());
      }
    });

    //When the user presses the singup bottun we will send the signuprequested event to the AuthBloc to handl it and emit it to the Authenticated state if the user is authenticated
    on<SignUpRequested>((event, emit) async {
      emit(Loading());
      try {
        await authRepository.signUpOwner(event.email, event.password);
        // addNewUserToFirestore(Client(phone: event.phone, email: event.email));
        bool signedIn = authRepository.isOwnerSignedIn();
        if (signedIn) {
          emit(Authenticated());
        } else {
          emit(Unauthenticated());
        }
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(Unauthenticated());
      }
    });

    on<GarageOwnerSignIn>((event, emit) => AccountType(isGarage: true),);

    on<CarOwnerSignIn>((event, emit) => AccountType(isGarage: false),);

    //sign out requested
    on<SignOutRequested>((event, emit) async {
      emit(Loading());
      try {
        await (authRepository.signOutOwner());
        bool signedIn = authRepository.isOwnerSignedIn();
        if (signedIn) {
          emit(Authenticated());
        } else {
          emit(Unauthenticated());
        }
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(Authenticated());
      }
    });
  }
}
