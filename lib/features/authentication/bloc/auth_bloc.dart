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
             event.email, event.password).whenComplete(() {
              String id = authRepository.fetchOwnerCred()!.id;
          emit(Authenticated(isGarage:event.isGarage, id: id, email: event.email ));
               emit(Authenticated(isGarage: event.isGarage, id: id, email: event.email));
             });        
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(Unauthenticated());
      }
    });

    //When the user presses the singup bottun we will send the signuprequested event to the AuthBloc to handl it and emit it to the Authenticated state if the user is authenticated
    on<SignUpRequested>((event, emit) async {
      emit(Loading());
      try {
        await authRepository.signUpOwner(event.email, event.password, event.name).whenComplete(() {
          String id = authRepository.fetchOwnerCred()!.id;
          emit(Authenticated(isGarage:event.isGarage, id: id, email: event.email));
        });
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(Unauthenticated());
      }
    });

    on<GarageOwnerSignIn>((event, emit) => emit(AccountType(isGarage: true)),);

    on<CarOwnerSignIn>((event, emit) => emit(AccountType(isGarage: false)),);

    //sign out requested
    on<SignOutRequested>((event, emit) async {
      emit(Loading());
      try {
        await (authRepository.signOutOwner()).whenComplete(() => emit(Unauthenticated()));
      } catch (e) {
        emit(AuthError(e.toString()));
        String id = authRepository.fetchOwnerCred()!.id;
        String email = authRepository.fetchOwnerCred()!.email;
          emit(Authenticated(isGarage:event.isGarage, id: id, email: email ));
      }
    });

    on<Back>(((event, emit) => emit(Unauthenticated())));
  }
}
