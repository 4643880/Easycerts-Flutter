import 'dart:developer';
import 'dart:io';
import 'package:easy_certs/config/routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:developer' as devtools show log;

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

final _firebaseMessaging = FirebaseMessaging.instance;
final FlutterLocalNotificationsPlugin foregroundFcmPlugin =
    FlutterLocalNotificationsPlugin();
late final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

//LOCAL NOTIFICATION
const AndroidNotificationChannel androidFcmChannel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.',
  // description
  importance: Importance.max,
);

Future<void> initAndroidForegroundFcm() async {
  await foregroundFcmPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidFcmChannel);
}

Future<void> enableIOSForeground() async {
  await _firebaseMessaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

Future<void> checkPermissions() async {
  var status = await Permission.notification.status;
  if (status.isGranted) {
    devtools.log("=> Permission Granted Successfully.");
  } else {
    Permission.notification.request();
  }
}

Future<void> requestDeviceFcmPermissions() async {
  NotificationSettings settings = await _firebaseMessaging.requestPermission(
    alert: true,
    sound: true,
    badge: true,
    announcement: false,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
  );
  final status = settings.authorizationStatus;

  if (status == AuthorizationStatus.authorized) {
    log("User granted permission");
  } else if (status == AuthorizationStatus.provisional) {
    log("User granted provisional permission");
  } else {
    log("User declined or has not accepted permission: $status");
  }
}

// HANDLING SHOW NOTIFICATIONS
Future<void> onBgNotification(RemoteMessage message) async {
  final msg = "Handling a background notification ${message.data}";
  final msg2 = "Handling a background notification ${message.notification}";
  final msg3 = "Handling a background notification ${message.messageId}";

  log("data = $msg");
  log("notification = $msg2");
  log("message = $msg3");
}

Future<String?> getUdid() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    // import 'dart:io'
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else if (Platform.isAndroid) {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.id; // unique ID on Android
  }
}

initInfo() async {
  var androidInitialize =
      const AndroidInitializationSettings("@mipmap/launcher_icon");
  var iosInitialize = const DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    defaultPresentSound: true,
    defaultPresentBadge: true,
    defaultPresentAlert: true,
  );
  var initializationSettings = InitializationSettings(
    android: androidInitialize,
    iOS: iosInitialize,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (details) {
      try {
        if (details.payload != null) {
          Get.toNamed(routeDashboard);
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) =>
          //         NewScreen(info: details.payload.toString()),
          //   ),
          // );
        } else {}
      } catch (e) {}
      return;
    },
  );

  FirebaseMessaging.onMessage.listen(
    (RemoteMessage message) async {
      devtools.log(".................... onMessage ................");
      devtools.log(
          "onMessage: ${message.notification?.title} / ${message.notification?.body}");
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );
      AndroidNotificationDetails androidPlatformChannelSpecifies =
          AndroidNotificationDetails(
        "UniqIdPasteHere",
        "aizazUnique",
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true,
        // sound: const RawResourceAndroidNotificationSound('riseup'),
      );

      DarwinNotificationDetails iosPlatformChannelSpecifies =
          const DarwinNotificationDetails();
      NotificationDetails platformChannelSpecifies = NotificationDetails(
          android: androidPlatformChannelSpecifies,
          iOS: iosPlatformChannelSpecifies);
      await flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title,
        message.notification?.body,
        platformChannelSpecifies,
        payload: message.data["body"],
      );
    },
  );
}
