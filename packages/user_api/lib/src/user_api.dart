
import 'package:user_api/user_api.dart';

abstract class UserApi {

  Future<void> signUP({required String email, required String password});

  Future<bool> signIn({required String email, required String password}) ;

  Future<void> signOut() ;

  Owner? getCurrentUser() ;

  bool signInSuccessfull() ;
}
