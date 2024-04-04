import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:user_api/user_api.dart';

class UserApiFirebase extends UserApi {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<void> signUP({required String email, required String password, required name}) async {
    print('========================In the signup=========================');
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
    await updateUserName(name);

      String uid = _firebaseAuth.currentUser!.uid;

      try {
  await FirebaseChatCore.instance.createUserInFirestore(
    types.User(
      firstName: name,
      id: uid,
      imageUrl: 'https://i.pravatar.cc/300?u=$email',
      role: types.Role.user 
      // lastName: _lastName,
    ),
  );
} on Exception catch (e) {
  print(e.toString());
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
        imageUrl: user.photoURL ?? 'User Name',
        email: user.email ?? 'user.name@email.com'
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

  @override
  Future<void> updateUserEmail(String owner)async{
    User user = _firebaseAuth.currentUser!;
    user.updateEmail(owner);
  }

  @override
  Future<void> updateUserName(String owner)async{
    User user = _firebaseAuth.currentUser!;
    user.updateEmail(owner);
  }

  @override
  Future<void> updateUserPassword(String newPassword) async {
    User user = _firebaseAuth.currentUser!;
    user.updatePassword(newPassword);
  }

  @override
  Future<void> sendEmailVerificationCode() async {
    User user = _firebaseAuth.currentUser!;
    user.sendEmailVerification();
  }

  @override
  Future<bool> isUserVerified() async{
    User user = _firebaseAuth.currentUser!;
    return user.emailVerified;
  }

  @override
  Future<void> updatePhotUrl(String url) async {
    User user = _firebaseAuth.currentUser!;
    user.updatePhotoURL(url);
  }
}
