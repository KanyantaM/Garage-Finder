import 'package:user_api/user_api.dart';

class UserRepository {
  const UserRepository({
    required UserApi userApi,
  }) : _userApi = userApi;

  final UserApi _userApi;

  Future<void> signUpOwner(String email, String password) =>
      _userApi.signUP(email: email, password: password);

  Future<void> signInOwner(String email, String password) =>
      _userApi.signIn(email: email, password: password);

  Future<void> signOutOwner() => _userApi.signOut();

  Owner? fetchOwnerCred() => _userApi.getCurrentUser();

  bool isOwnerSignedIn() => _userApi.signInSuccessfull();
}
