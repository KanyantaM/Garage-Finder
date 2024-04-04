
import 'package:user_api/user_api.dart';

abstract class UserApi {

  Future<void> signUP({required String email, required String password, required String name});

  Future<bool> signIn({required String email, required String password,}) ;

  Future<void> signOut() ;

  Owner? getCurrentUser() ;

  bool signInSuccessfull() ;

  
  Future<void> updateUserEmail(String owner);

  Future<void> updateUserName(String owner);

  Future<void> updateUserPassword(String newPassword);

  Future<void> sendEmailVerificationCode() ;

  Future<bool> isUserVerified() ;

  Future<void> updatePhotUrl(String url);
}
