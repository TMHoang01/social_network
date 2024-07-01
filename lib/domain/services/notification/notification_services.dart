import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:social_network/domain/repository/auth_repository.dart';
import 'package:social_network/router.dart';
import 'package:social_network/sl.dart';
import 'package:social_network/utils/logger.dart';

import 'crud_service.dart';

class PushNotification {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // request notification permission
  static Future init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    final token = await _firebaseMessaging.getToken();
    print("device token: $token");
  }

  // get the fcm device token
  static Future getDeviceToken({int maxRetires = 3}) async {
    try {
      String? token;
      bool kIsWeb = false;
      if (kIsWeb) {
        // get the device fcm token
        token = await _firebaseMessaging.getToken(
            vapidKey:
                "BPA9r_00LYvGIV9GPqkpCwfIl3Es4IfbGqE9CSrm6oeYJslJNmicXYHyWOZQMPlORgfhG8RNGe7hIxmbLXuJ92k");
        print("for web device token: $token");
      } else {
        // get the device fcm token
        token = await _firebaseMessaging.getToken();
        print("for android device token: $token");
      }
      saveTokentoFirestore(token: token!);
      return token;
    } catch (e) {
      print("failed to get device token");
      if (maxRetires > 0) {
        print("try after 10 sec");
        await Future.delayed(Duration(seconds: 10));
        return getDeviceToken(maxRetires: maxRetires - 1);
      } else {
        return null;
      }
    }
  }

  static saveTokentoFirestore({required String token}) async {
    bool isUserLoggedin = await sl<AuthRepository>().getCurrentUser() != null;
    print("User is logged in $isUserLoggedin");
    if (isUserLoggedin) {
      await CRUDService.saveUserToken(token);
      print("save to firestore");
    }
    // also save if token changes
    _firebaseMessaging.onTokenRefresh.listen((event) async {
      if (isUserLoggedin) {
        await CRUDService.saveUserToken(token);
        print("save to firestore");
      }
    });
  }

  // initalize local notifications
  static Future localNotiInit() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);

    // request notification permissions for android 13 or above
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();

    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }

  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }

  static handlerInit() async {
    // // Listen to background notifications
    // FirebaseMessaging.onBackgroundMessage(());
    // // on background notification tapped
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification.handleForeground(message);
    });
    // to handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      PushNotification.handleForeground(message);
    });
  }

// function to listen to background changes
  Future _firebaseBackgroundMessage(RemoteMessage message) async {
    if (message.notification != null) {
      print("Some notification Received in background...");
    }
  }

  static handleForeground(RemoteMessage message) {
    String payloadData = jsonEncode(message.data);
    print("Got a message in foreground");
    if (message.notification != null) {
      PushNotification.showSimpleNotification(
          title: message.notification!.title!,
          body: message.notification!.body!,
          payload: payloadData);
    }
  }

  static handlerBackground(RemoteMessage message) {
    if (message.notification != null) {
      print("Background Notification Tapped");

      navigatorKey.currentState!.pushNamed('/message', arguments: message);
    }
  }

  static void onNotificationTap(NotificationResponse notificationResponse) {
    navigatorKey.currentState!
        .pushNamed('/message', arguments: notificationResponse);
    logger.d(notificationResponse.toString());
  }
}
