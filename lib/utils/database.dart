import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseHelper {
  final String uid;
  DatabaseHelper({this.uid});

  // Document Reference.
  final CollectionReference userProfile =
      Firestore.instance.collection('userProfile');

  /// Updates the profile of the Lancer.
  Future updateUserProfile(
      String name, String address) async {
    return await userProfile.document(uid).setData({
      'name': name,
      'address': address,
    });
  }
}
