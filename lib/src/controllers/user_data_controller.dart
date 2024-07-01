import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:state_change_demo/src/models/user.model.dart';

class UserDataController with ChangeNotifier {
  ValueNotifier<UserModel?> userModelNotifier = ValueNotifier(null);

  setUserModel(UserModel user) {
    userModelNotifier.value = user;
  }

  Map<String, dynamic>? userData;

  StreamSubscription? userStream;

  listen(String uid) {
    userStream ??= FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots()
        .listen(onDataChange);
  }

  onDataChange(DocumentSnapshot<Map<String, dynamic>> data) {
    if (data.exists) {
      userData = data.data();
      notifyListeners();
    }
  }
}
