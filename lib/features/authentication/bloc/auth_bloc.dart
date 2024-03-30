import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_events.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(Unauthenticated()) {
    //When the user Presses the signin button we will send the SingInRequested event to the AuthBloc to handle it and emit theemti the Authenticated State if the user is authenticated
    on<SignInRequested>((event, emit) async {
      emit(Loading());
      try {
        bool signedIn = await authRepository.signIn(
            email: event.email, password: event.password);
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
        await authRepository.signUP(
            email: event.email, password: event.password);
        addNewUserToFirestore(Client(phone: event.phone, email: event.email));
        emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(Unauthenticated());
      }
    });

    //sing in with google requrested
    on<GoogleSignInRequested>((event, emit) async {
      emit(Loading());
      try {
        await authRepository.signInWithGoogle();
        emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(Unauthenticated());
      }
    });

    //sign out requested
    on<SignOutRequested>((event, emit) async {
      emit(Loading());
      try {
        await (authRepository.signOut());
        emit(Unauthenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(Authenticated());
      }
    });
  }
}
