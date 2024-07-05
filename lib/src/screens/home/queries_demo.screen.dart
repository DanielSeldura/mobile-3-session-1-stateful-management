import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:state_change_demo/src/dialogs/waiting_dialog.dart';
import 'package:state_change_demo/src/models/user.model.dart';

class QueriesDemo extends StatefulWidget {
  const QueriesDemo({super.key});

  @override
  State<QueriesDemo> createState() => _QueriesDemoState();
}

class _QueriesDemoState extends State<QueriesDemo> {
  UserQueriesController uqc = UserQueriesController();

  @override
  void initState() {
    super.initState();
    uqc.listen();
  }

  @override
  void dispose() {
    super.dispose();
    uqc.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: uqc,
        builder: (context, _) {
          return Column(
            children: [
              ListTile(
                onTap: () {
                  WaitingDialog.show(context, future: uqc.getAllUsers());
                },
                leading: const Icon(Icons.refresh),
                title: const Text("Get Data"),
              ),
              // ListTile(
              //   onTap: () {
              //     WaitingDialog.show(context,
              //         future: uqc.getUserByName("Ervin Howell"));
              //   },
              //   leading: const Icon(Icons.refresh),
              //   title: const Text("Get a specific person"),
              // ),
              // ListTile(
              //   onTap: () {
              //     WaitingDialog.show(context,
              //         future: uqc.getUserByWebsite("ambrose.net"));
              //   },
              //   leading: const Icon(Icons.refresh),
              //   title: const Text("Get people with website ambrose.net"),
              // ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (MapEntry<String, UserExampleModel> userEntry
                          in uqc.users.entries)
                        ListTile(
                          onTap: () async {
                            bool? choice = await showDialog(
                                context: context,
                                builder: (dCon) {
                                  return AlertDialog(
                                    title: const Text("Are you sure?"),
                                    actions: [
                                      IconButton(
                                          onPressed: () {
                                            Navigator.of(dCon).pop(true);
                                          },
                                          icon: const Icon(Icons.check)),
                                      IconButton(
                                          onPressed: () {
                                            Navigator.of(dCon).pop(false);
                                          },
                                          icon:
                                              const Icon(CupertinoIcons.xmark))
                                    ],
                                  );
                                });
                            print(choice);
                            if (choice ?? false) {
                              if (!context.mounted) {
                                return uqc.delete(userEntry.key);
                              }
                              WaitingDialog.show(context,
                                  future: uqc.delete(userEntry.key));
                            }
                          },
                          leading: Text(userEntry.key),
                          title: Text(userEntry.value.name),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}

class UserQueriesController with ChangeNotifier {
  Map<String, UserExampleModel> users = {};

  StreamSubscription? streamSubscription;

  listen() {
    streamSubscription ??= FirebaseFirestore.instance
        .collection('exampleUsers')
        .snapshots()
        .listen(handleQueryDocumentSnap);
  }

  disconnect(){
    streamSubscription?.cancel();
  }

  handleQueryDocumentSnap(
      QuerySnapshot<Map<String, dynamic>> queryCollectionSnap) {
    print("Changes received");
    print( queryCollectionSnap.docs.length);
    if (queryCollectionSnap.docs.isNotEmpty) {
      List<UserExampleModel> userList = queryCollectionSnap.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> e) {
        return UserExampleModel.fromJson(e.data());
      }).toList();
      users = {
        for (UserExampleModel user in userList) user.id.toString(): user
      };

      // for(UserExampleModel user in userList){
      //   users["${user.id}"] = user;
      // }
    } else {
      users = {};
    }
    notifyListeners();
  }

  Future<void> getUserByName(String name) async {
    QuerySnapshot<Map<String, dynamic>> snaps = await FirebaseFirestore.instance
        .collection('exampleUsers')
        .where("name", isEqualTo: name)
        .get();
    handleQueryDocumentSnap(snaps);
  }

  Future<void> getUserByWebsite(String website) async {
    QuerySnapshot<Map<String, dynamic>> snaps = await FirebaseFirestore.instance
        .collection('exampleUsers')
        .where("website", isEqualTo: website)
        .orderBy("id")
        .get();
    if (snaps.docs.isNotEmpty) {
      List<UserExampleModel> userList =
          snaps.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> e) {
        return UserExampleModel.fromJson(e.data());
      }).toList();
      users = {
        for (UserExampleModel user in userList) user.id.toString(): user
      };

      // for(UserExampleModel user in userList){
      //   users["${user.id}"] = user;
      // }
    } else {
      users = {};
    }
    notifyListeners();
  }

  Future delete(String uid) async {
    DocumentReference<Map<String, dynamic>> user =
        FirebaseFirestore.instance.collection("exampleUsers").doc(uid);
    return await user.delete();
  }

  Future<void> getAllUsers() async {
    QuerySnapshot<Map<String, dynamic>> snaps =
        await FirebaseFirestore.instance.collection('exampleUsers').get();
    if (snaps.docs.isNotEmpty) {
      List<UserExampleModel> userList =
          snaps.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> e) {
        return UserExampleModel.fromJson(e.data());
      }).toList();
      users = {
        for (UserExampleModel user in userList) user.id.toString(): user
      };

      // for(UserExampleModel user in userList){
      //   users["${user.id}"] = user;
      // }
      notifyListeners();
    }
  }
}
