import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/information_service.dart';

class CloudNotificationController with ChangeNotifier {
  bool isListening = false, allowInAppNotifications = true;
  StreamSubscription<RemoteMessage>? fcmStream;
  StreamSubscription<RemoteMessage>? fcmStreamOnMessageOpened;
  StreamSubscription<String>? tokenRefreshStream;
  String? ianToken;
  late NotificationSettings settings;

  FirebaseMessaging get messaging => FirebaseMessaging.instance;

  static void initialize() {
    GetIt.instance.registerSingleton<CloudNotificationController>(
        CloudNotificationController());
  }

  static CloudNotificationController get instance =>
      GetIt.instance<CloudNotificationController>();

  static CloudNotificationController get I =>
      GetIt.instance<CloudNotificationController>();

  setAllowIAP(bool v) {
    allowInAppNotifications = v;
    notifyListeners();
  }

  Future<String?> getIAPToken() async {
    ianToken ??= await messaging.getToken();
    tokenRefreshStream ??= messaging.onTokenRefresh.listen((token) {
      print("Token refreshed");
      ianToken = token;
    });
    String? token = ianToken;
    print("Messaging Token");
    print(token);
    return token;
  }


  Future<void> requestPermissionAndListen() async {
    print("Calling request permission and listen [listening?]$isListening");
    if (isListening) return;
    settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: true,
      provisional: false,
    );
    print(settings.authorizationStatus);
    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      fcmStream ??= FirebaseMessaging.onMessage.listen(listener);
      fcmStreamOnMessageOpened ??=
          FirebaseMessaging.onMessageOpenedApp.listen(onOpenListener);
      isListening = true;
      print("FCM Listening: $isListening");
      RemoteMessage? fromKilledMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (fromKilledMessage != null) {
        onOpenListener(fromKilledMessage);
      }
      notifyListeners();
    }
  }

  listener(RemoteMessage message) {
    print("FCM MESSAGE");
    print(message.toMap());
    if (!allowInAppNotifications) return;
    print(message.messageType);
    print(message.data);

    Info.showInAppNotification(
      title: message.notification?.title ?? '',
      content: message.notification?.body ?? '',
    );
  }

  void onOpenListener(RemoteMessage message) {
    print("On Open message");
    print(message.toMap());
  }
}
