import 'package:eyvo_inventory/log_data.dart/logger_data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleNotificationMessageInBackground(
    RemoteMessage message) async {
  LoggerData.dataLog("Title : ${message.notification?.title}");
  LoggerData.dataLog("Body : ${message.notification?.body}");
  LoggerData.dataLog("PAyload : ${message.data}");
}

class NotificationServices {
  final firebaseMessage = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    //Permission Pop up
    await firebaseMessage.requestPermission();

    //FCM token required for sending Notification
    final fcmToken = await firebaseMessage.getToken();
    LoggerData.dataLog("Getting Fcm Token : $fcmToken");

    initPushNotification();
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
  }

  void handleNotificationMessage(RemoteMessage? message) {
    if (message == null) return;

    LoggerData.dataPrint("Title: ${message.notification!.title}");
  }
}
