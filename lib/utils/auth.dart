import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user.dart';

class AuthHelper {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Registers a user using their email and password.
  /// Takes in the user email and password as strings.
  /// Returns a FirebaseUser object.
  Future<User> registerUserWithEmailAndPassword(
      String email, String password) async {
    return _getUserFromFirebaseUser((await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password))
        .user);
  }

  Future<User> getUser() async{
    return _getUserFromFirebaseUser(await _firebaseAuth.currentUser());
  }

  /// Authenticates a user in the system.
  /// Requires email and password as strings.
  /// Returns a custom User object.
  Future<User> authenticateUserWithEmailAndPassword(
      String email, String password) async {
    return _getUserFromFirebaseUser((await _firebaseAuth
            .signInWithEmailAndPassword(email: email, password: password))
        .user);
  }

  /// Authenticates a user with the Google account.
  /// This means registration of new users and logging in existing ones.
  /// Returns a custom User object with the recently authenticated user.
  Future<User> signUserInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    return _getUserFromFirebaseUser(
        (await _firebaseAuth.signInWithCredential(credential)).user);
  }

  /// Gets the user stream when it has changed and notifies the stream.
  Stream<User> get user {
    return _firebaseAuth.onAuthStateChanged.map(_getUserFromFirebaseUser);
  }

  /// Returns a User object given a FirebaseUser object.
  User _getUserFromFirebaseUser(FirebaseUser firebaseUser) {
    return firebaseUser != null
        ? new User(
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
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  /// Registers a user using their email and password.
//  Future<bool> isUserAuthenticated() {}

}
