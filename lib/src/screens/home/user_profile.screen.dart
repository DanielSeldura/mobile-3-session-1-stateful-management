
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../controllers/user_data_controller.dart';
import '../../dialogs/waiting_dialog.dart';
import '../../models/user2.model.dart';
import '../../services/firestore_service.dart';
import '../demos/rest_demo.screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Map<String, dynamic>? user;
  late UserDataController userDataController;
  UserController uc = UserController();
  @override
  void initState() {
    super.initState();
    userDataController = UserDataController();
    userDataController
        .listen(FirebaseAuth.instance.currentUser?.uid ?? 'unknown');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () async {
            user = await WaitingDialog.show<Map<String, dynamic>?>(context,
                future: FirestoreService.getUser(
                    FirebaseAuth.instance.currentUser?.uid ?? 'unknown'));
            setState(() {});
          },
        ),
        if (user != null)
          Text(
            user.toString(),
            textAlign: TextAlign.center,
          ),
        ListenableBuilder(
            listenable: userDataController,
            builder: (context, _) {
              return Text(
                userDataController.userData.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.blueAccent),
              );
            }),
        const SizedBox(
          height: 72,
        ),
        ValueListenableBuilder<UserModel?>(
            valueListenable: userDataController.userModelNotifier,
            builder: (context, user, _) {
              if (user == null) {
                return const Text(
                  "DataModel is null!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blueAccent),
                );
              }
              return Text(
                user.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.blueAccent),
              );
            }),
        IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              try {
                UserModel model1 =
                UserModel(uid: "uid", siblings: const ["A", "B", "C"]);
                UserModel model2 =
                UserModel(uid: "uid", siblings: const ["A", "2", "C"]);
                print(model1 == model2);
              } catch (e) {
                print(e);
              }
            }),
        IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              WaitingDialog.show(context,
                  future: uc.storeExampleUsersInFirestore());
            }),
      ],
    );
  }
}