import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wave/models/user.dart';
import 'package:wave/models/userprofile.dart';

class DatabaseHelper {
  final String uid;

  DatabaseHelper({this.uid});

  // Document Reference.
  final CollectionReference userProfileRef =
      Firestore.instance.collection('userProfile');

  /// Updates the profile of the Lancer.
  Future updateUserProfile(UserProfile userProfile) async {
    return await userProfileRef.document(uid).setData({
      'fullName': userProfile.fullName,
      'firstName': userProfile.firstName,
      'lastName': userProfile.lastName,
      'address': userProfile.address,
      'bio': userProfile.bio,
      'accountType': userProfile.accountType
    });
  }

  /// Returns the User Profile Stream.
  Stream<UserProfile> get profile {
    return userProfileRef
        .document(uid)
        .snapshots()
        .map(_getUserProfileFromSnapshot);
  }

  /// Get a UserProfile from a QuerySnapshot.
  UserProfile _getUserProfileFromSnapshot(DocumentSnapshot snapshot) {
    return new UserProfile(
        fullName: snapshot.data['fullName'] ?? 'Please confirm your name',
        firstName:
            snapshot.data['firstName'] ?? 'Please confirm your first name',
        lastName: snapshot.data['lastName'] ?? 'Please confirm your last name',
        address: snapshot.data['address'] ?? 'Please confirm your address',
        bio: snapshot.data['bio'] ?? 'Please confirm your bio',
        accountType:
            snapshot.data['accountType'] ?? 'Please confirm your account type');
  }
}
