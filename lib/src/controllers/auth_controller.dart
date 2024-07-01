import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:github_sign_in_plus/github_sign_in_plus.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:state_change_demo/src/enum/enum.dart';
import 'package:state_change_demo/src/services/firestore_service.dart';

class AuthController with ChangeNotifier {
  // Static method to initialize the singleton in GetIt
  static void initialize() {
    GetIt.instance.registerSingleton<AuthController>(AuthController());
  }

  // Static getter to access the instance through GetIt
  static AuthController get instance => GetIt.instance<AuthController>();

  static AuthController get I => GetIt.instance<AuthController>();

  late StreamSubscription<User?> currentAuthedUser;

  AuthState state = AuthState.unauthenticated;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  final GitHubSignIn gitHubSignIn = GitHubSignIn(
      clientId: const String.fromEnvironment("GHCLIENT"),
      clientSecret: const String.fromEnvironment("GHSECRET"),
      redirectUrl:
          "https://seldura-firebase-demo.firebaseapp.com/__/auth/handler");

  listen() {
    currentAuthedUser =
        FirebaseAuth.instance.authStateChanges().listen(handleUserChanges);
  }

  void handleUserChanges(User? user) {
    if (user == null) {
      state = AuthState.unauthenticated;
    } else {
      state = AuthState.authenticated;
      FirestoreService.storeUser(user.email ?? "No email available", user.uid);
    }
    notifyListeners();
  }

  login(String userName, String password) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: userName, password: password);
    // User? user  = userCredential.user;
  }

  register(String userName, String password) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: userName, password: password);
    // User? user  = userCredential.user;
  }

  signInWithGoogle() async {
    GoogleSignInAccount? gSign = await _googleSignIn.signIn();
    if (gSign == null) throw Exception("No Signed in account");
    GoogleSignInAuthentication googleAuth = await gSign.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    FirebaseAuth.instance.signInWithCredential(credential);
  }

  signInWithGithub(BuildContext context) async {
    GitHubSignInResult gitHubSignin = await gitHubSignIn.signIn(context);
    if (gitHubSignin.token == null) {
      throw Exception("No Signed in account / token is null");
    }
    final OAuthCredential credential =
        GithubAuthProvider.credential(gitHubSignin.token!);
    FirebaseAuth.instance.signInWithCredential(credential);
  }

  ///write code to log out the user and add it to the home page.
  logout() {
    if (_googleSignIn.currentUser != null) {
      _googleSignIn.signOut();
    }
    return FirebaseAuth.instance.signOut();
  }

  ///must be called in main before runApp
  ///
  loadSession() async {
    listen();
    User? user = FirebaseAuth.instance.currentUser;
    handleUserChanges(user);
  }

  ///https://pub.dev/packages/flutter_secure_storage or any caching dependency of your choice like localstorage, hive, or a db
}

class SimulatedAPI {
  Map<String, String> users = {"testUser": "12345678ABCabc!"};

  Future<bool> login(String userName, String password) async {
    await Future.delayed(const Duration(seconds: 4));
    if (users[userName] == null) throw Exception("User does not exist");
    if (users[userName] != password) {
      throw Exception("Password does not match!");
    }
    return users[userName] == password;
  }
}
