import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wave/models/userprofile.dart';
import 'package:wave/models/wavedata.dart';

class DatabaseHelper {
  final String uid;

  DatabaseHelper({this.uid});

  // User Profile Collection Reference.
  final CollectionReference userProfileRef =
      Firestore.instance.collection('userProfile');
  // Waves Collection Reference.
  final CollectionReference waveRef = Firestore.instance.collection('waves');

  Future switchUserAccountType(String uid, String accountType) {
    userProfileRef.document(uid).updateData(
        {'accountType': accountType}).catchError((error) => print(error));
  }

  /// Updates a Wave's status to being a collaboration.
  /// Also defines the lancerId.
  Future collabWave(String lancerId, String waveDocumentId) async {
    return await waveRef
        .document(waveDocumentId)
        .updateData({'lancerId': lancerId, 'status': 'Collab'}).catchError(
            (error) => print(error));
  }

  /// Creates a new Wave record.
  Future addWave(WaveData waveData) async {
    await waveRef.add({
      'collabType': waveData.collabType,
      'address': waveData.address,
      'budget': waveData.budget,
      'doneBy': waveData.doneBy,
      'createdOn': waveData.createdOn,
      'createdBy': waveData.createdBy,
      'waverId': waveData.waverId,
      'status': waveData.status,
      'lancerId': waveData.lancerId
    }).catchError((error) => print(error));
  }

  /// Returns a waver specific WaveData stream.
  /// Listen to this getter to get notified every time data is added
  Stream<List<WaveData>> get waverWaveData {
    return waveRef
        .orderBy('createdOn', descending: true)
        .where("waverId", isEqualTo: uid)
        .snapshots()
        .map(_getWaveDataFromSnapshot);
  }

  /// Returns a lancer specific WaveData stream.
  Stream<List<WaveData>> get waveData {
    return waveRef
        .orderBy('createdOn', descending: true)
        .snapshots()
        .map(_getWaveDataFromSnapshot);
  }

  /// Returns a lancer specific WaveData stream.
  Stream<List<WaveData>> get lancerWaveData {
    return waveRef
        .orderBy('createdOn', descending: true)
        .where('lancerId', isEqualTo: uid)
        .snapshots()
        .map(_getWaveDataFromSnapshot);
  }

  /// Get a UserProfile from a QuerySnapshot.
  List<WaveData> _getWaveDataFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((e) {
      return new WaveData(
          collabType: e.data['collabType'],
          address: e.data['address'],
          budget: e.data['budget'],
          doneBy: e.data['doneBy'],
          createdOn: e.data['createdOn'],
          createdBy: e.data['createdBy'],
          waverId: e.data['waverId'],
          status: e.data['status'],
          lancerId: e.data['lancerId'],
          documentId: e.documentID);
    }).toList();
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
