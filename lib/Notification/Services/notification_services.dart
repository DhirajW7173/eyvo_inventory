import 'dart:convert';

import 'package:eyvo_inventory/Notification/notification_page.dart';
import 'package:eyvo_inventory/app/app.dart';
import 'package:eyvo_inventory/log_data.dart/logger_data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//Future Function when App is in background
Future<void> handleNotificationMessageInBackground(
    RemoteMessage message) async {
  LoggerData.dataPrint("Title : ${message.notification?.title}");
  LoggerData.dataPrint("Body : ${message.notification?.body}");
  LoggerData.dataPrint("PAyload : ${message.data}");
}

class NotificationServices {
  //create Instance Of FirebaseMessaging
  final firebaseMessage = FirebaseMessaging.instance;

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  //Abdroid Notification Details
  final androidChannel = const AndroidNotificationDetails(
    'new_inventory',
    'New Inventory',
    channelDescription: 'your channel description',
    importance: Importance.max,
    priority: Priority.high,
  );

  Future<void> initNotification() async {
    //Permission Pop up
    await firebaseMessage.requestPermission();

    //FCM token required for sending Notification
    final fcmToken = await firebaseMessage.getToken();
    LoggerData.dataLog("Getting Fcm Token : $fcmToken");

    initPushNotification();
    initLocalNotification();
  }

  void handleNotificationMessage(RemoteMessage? message) {
    if (message == null) return;

    LoggerData.dataPrint("Title: ${message.notification!.title}");
    //Navigate Part Mention Here

    navigatorKey.currentState!
        .pushNamed(NotificationPage.route, arguments: message);
    ;
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;

    if (notificationResponse.payload != null) {
      LoggerData.dataLog('notification payload: $payload');
    }

    //Navigator Part Here

    // navigatorKey.currentState!
    //     .pushNamed(NotificationPage.route, arguments: payload);
  }

  Future initPushNotification() async {
    await firebaseMessage.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    FirebaseMessaging.instance
        .getInitialMessage()
        .then(handleNotificationMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(handleNotificationMessage);

    FirebaseMessaging.onBackgroundMessage(
        handleNotificationMessageInBackground);

    FirebaseMessaging.onMessage.listen(
      (message) {
        final notification = message.notification;
        if (notification == null) return;

        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.body,
          notification.title,
          NotificationDetails(
            android: androidChannel,
          ),
          payload: jsonEncode(message.toMap()),
        );
      },
    );
  }

  Future<void> initLocalNotification() async {
    //  For Ios Permission
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    //Initialize For Android
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_launcher_round');
    //For iOS
    const initializationSettingsDarwin = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    //Initialize Setting for Local Notification
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    //initialize Local Notification
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }
}
