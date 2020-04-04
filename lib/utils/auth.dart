import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Registers a user using their email and password.
  /// Takes in the user email and password as strings.
  /// Returns a FirebaseUser object.
  Future<User> registerEmailAndPassword(String email,
      String password) async {
    return _getUserFromFirebaseUser(
        (await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
            .user);
  }

  /// Gets the user stream when it has changed.
  Stream<User> get user {
    return _firebaseAuth.onAuthStateChanged.map(_getUserFromFirebaseUser);
  }

  /// Returns a User object given a FirebaseUser object.
  User _getUserFromFirebaseUser(FirebaseUser firebaseUser) {
    return firebaseUser != null ? new User(
        uid: firebaseUser.uid,
        email: firebaseUser.email,
        displayName: firebaseUser.displayName)
        : null;
  }

  /// Signs the user out.
  /// Returns null after it is signed out.
  /// See console for any potential errors thrown.
  Future signOut() async {
    try {
      print('Sign out');
      return await _firebaseAuth.signOut();
    }catch (e) {
      print(e.toString());
    }
    return null;
  }

  /// Registers a user using their email and password.
//  Future<bool> isUserAuthenticated() {}

}
