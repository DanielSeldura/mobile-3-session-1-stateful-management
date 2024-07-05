import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:state_change_demo/src/controllers/auth_controller.dart';
import 'package:state_change_demo/src/controllers/user_data_controller.dart';
import 'package:state_change_demo/src/dialogs/waiting_dialog.dart';
import 'package:state_change_demo/src/screens/demos/rest_demo.screen.dart';
import 'package:state_change_demo/src/screens/home/queries_demo.screen.dart';
import 'package:state_change_demo/src/screens/home/user_profile.screen.dart';
import 'package:state_change_demo/src/services/firestore_service.dart';

import '../../models/user2.model.dart';

class HomeScreen extends StatelessWidget {
  static const String route = '/home';
  static const String path = "/home";
  static const String name = "Home Screen";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Home"),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              WaitingDialog.show(context, future: AuthController.I.logout());
            },
            child: const Text("Sign out"),
          ),
        ),
      ),
      body: const SafeArea(
        // child: UserProfileScreen()
        child: QueriesDemo(),
      ),
    );
  }
}

