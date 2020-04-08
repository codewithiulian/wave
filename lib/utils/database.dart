import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wave/models/user.dart';
import 'package:wave/models/userprofile.dart';
import 'package:wave/models/wavedata.dart';

class DatabaseHelper {
  final String uid;

  DatabaseHelper({this.uid});

  // User Profile Collection Reference.
  final CollectionReference userProfileRef =
      Firestore.instance.collection('userProfile');
  // Waves Collection Reference.
  final CollectionReference waveRef = Firestore.instance.collection('wave');

  /// Creates a new Wave record in the following path:
  /// Collection / Document / Collection / Document
  /// wave       / uid      / waves      / uniqueId
  Future addWave(String uid, WaveData waveData) async {
    await waveRef.document(uid).collection('waves').add({
      'collabType': waveData.collabType,
      'address': waveData.address,
      'budget': waveData.budget,
      'doneBy': waveData.doneBy,
      'createdOn': waveData.createdOn,
      'createdBy': waveData.createdBy,
    }).catchError((error) => print(error));
  }

  /// Returns a WaveData stream.
  /// Listen to this getter to get notified every time data is added
  Stream<List<WaveData>> get waveData {
    return waveRef
        .document(uid)
        .collection('waves')
        .snapshots()
        .map(_getWaveDataFromSnapshot);
  }

  /// Get a UserProfile from a QuerySnapshot.
  List<WaveData> _getWaveDataFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.documents.map((e) {
        return new WaveData(
          collabType: e.data['collabType'],
          address: e.data['address'],
          budget: e.data['budget'],
          doneBy: e.data['doneBy'],
          createdOn: e.data['createdOn'],
          createdBy: e.data['createdBy'],
        );
      }).toList();
    } catch (error) {
      print(error);
    }
  }

  /// Updates the profile of the Lancer.
  Future updateUserProfile(UserProfile userProfile) async {
    return await userProfileRef.document(uid).setData({
      'fullName': userProfile.fullName,
      'firstName': userProfile.firstName,
      'lastName': userProfile.lastName,
      'address': userProfile.address,
      'bio': userProfile.bio,
      'accountType': userProfile.accountType
    }).catchError((error) => print(error));
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
