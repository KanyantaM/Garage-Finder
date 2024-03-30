import 'package:fixtex/features/authentication/auth/auth_view.dart';
import 'package:fixtex/features/authentication/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_api_firebase/user_api_firebase_auth.dart';
import 'package:user_repository/user_repository.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AuthBloc(authRepository: UserRepository(userApi: UserApiFirebase())),
      child: const AuthView(),
    );
  }
}
