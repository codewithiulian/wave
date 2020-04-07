import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wave/models/userprofile.dart';
import 'package:wave/utils/database.dart';

import '../models/user.dart';

class AuthHelper {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Registers a user using their email and password.
  /// Takes in the user email and password as strings.
  /// Returns a FirebaseUser object.
  Future<User> registerUserWithEmailAndPassword(
      String email, String name, String password) async {
    User user = _getUserFromFirebaseUser((await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password))
        .user);
    user.displayName = name;

    // Create default profile if non existent.
    await _createDefaultProfile(user);

    return user;
  }

  Future<User> getUser() async {
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

    final user = _getUserFromFirebaseUser(
        (await _firebaseAuth.signInWithCredential(credential)).user);

    // Create default profile if non existent.
    await _createDefaultProfile(user);

    return user;
  }

  /// Creates the default user profile only if it does not already exist.
  Future _createDefaultProfile(User user) async {
    final snapShot = await DatabaseHelper(uid: user.uid)
        .userProfileRef
        .document(user.uid)
        .get();

    if (!snapShot.exists) {
      // Create user profile.
      await DatabaseHelper(uid: user.uid).updateUserProfile(UserProfile(
          fullName: user.displayName ?? 'Please confirm your full name',
          firstName: 'Please confirm your first name',
          lastName: 'Please confirm your last name',
          address: 'Please confirm your address',
          bio: 'Hey there, I am using wave.',
          accountType: 'Waver'));
    }
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
