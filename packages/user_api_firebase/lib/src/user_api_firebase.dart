import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_api/user_api.dart';

class UserApiFirebase extends UserApi {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<void> signUP({required String email, required String password,}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception(e.code);
      } else if (e.code == 'email-already-in-use') {
        throw Exception('An account with that email already exists');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> signIn({required String email, required String password,}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email');
      } else if (e.code == 'wrong-password') {
        throw Exception('Password does not match email');
      }
      return false;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Owner? getCurrentUser() {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      Owner owner = Owner(
        id: user.uid,
        name: user.displayName ?? '',
        imageUrl: user.photoURL ?? '',
      );
      return owner;
    } else {
      return null;
    }
  }

  @override
  bool signInSuccessfull() {
    bool status = _firebaseAuth.currentUser == null &&
        _firebaseAuth.currentUser!.isAnonymous;
    return status;
  }
}
