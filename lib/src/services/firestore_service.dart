import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {

  static Future storeUser(String email, String uid,
      {DateTime? signInTime}) async {
    return FirebaseFirestore.instance.collection("users").doc(uid).set({
      "uid": uid,
      "email": email,
      if (signInTime != null) "lastSignIn": signInTime
    }, SetOptions(merge: true));
  }

  static Future<Map<String, dynamic>?> getUser(
    String uid,
  ) async {
    DocumentSnapshot<Map<String, dynamic>> user =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    if (!user.exists) {
      throw Exception("The user $uid does not exist in database");
    }
    return user.data();
  }
}
