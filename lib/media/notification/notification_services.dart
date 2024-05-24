// import 'dart:io';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class MyNotificationServices {
//   MyNotificationServices(BuildContext context) {
//     _requestPermissions();
//     _foregroundMessage();
//     _initNotifications(context);
//     _refreshToken();
//     _getDeviceToken().then((value) => print(value));
//   }
//
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   Future<String?> _getDeviceToken() async => await messaging.getToken();
//
//   void _refreshToken() =>
//       messaging.onTokenRefresh.listen((event) => event.toString());
//
//   Future<void> _requestPermissions() async {
//     if (Platform.isIOS) {
//       await messaging.requestPermission(
//         alert: true,
//         announcement: true,
//         badge: true,
//         carPlay: true,
//         criticalAlert: true,
//         provisional: true,
//         sound: true,
//       );
//     }
//
//     NotificationSettings notificationSettings =
//         await messaging.requestPermission(
//       alert: true,
//       announcement: true,
//       badge: true,
//       carPlay: true,
//       criticalAlert: true,
//       provisional: true,
//       sound: true,
//     );
//
//     if (notificationSettings.authorizationStatus ==
//         AuthorizationStatus.authorized) {
//       print('Authorized Permission');
//     } else if (notificationSettings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       print('Provisional Permission');
//     } else {
//       print('Permission not granted');
//     }
//   }
//
//   void _initNotifications(BuildContext context) {
//     FirebaseMessaging.onMessage.listen((message) {
//       RemoteNotification? remoteNotification = message.notification;
//       AndroidNotification? androidNotification = remoteNotification!.android;
//
//       print('Notification Title: ${remoteNotification.title}');
//       print('Notification Body: ${remoteNotification.body}');
//       print('Notification data: ${message.data.toString()}');
//
//       if (Platform.isIOS) {
//         _foregroundMessage();
//       }
//
//       if (Platform.isAndroid) {
//         initLocalNotification(context, message);
//         showNotification(message);
//       }
//     });
//   }
//
//   Future<void> _foregroundMessage() async {
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }
//
//   void initLocalNotification(
//       BuildContext context, RemoteMessage message) async {
//     AndroidInitializationSettings androidInitializationSettings =
//         const AndroidInitializationSettings('@mipmap/ic_launcher');
//     DarwinInitializationSettings iosInitializationSettings =
//         const DarwinInitializationSettings();
//
//     InitializationSettings initializationSettings = InitializationSettings(
//         android: androidInitializationSettings, iOS: iosInitializationSettings);
//
//     await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse: (payload) =>
//             handleMessage(context, message));
//   }
//
//   void handleMessage(BuildContext context, RemoteMessage message) {}
//
//   void showNotification(RemoteMessage message) async {
//     AndroidNotificationChannel androidNotificationChannel =
//         AndroidNotificationChannel(
//             message.notification!.android!.channelId.toString(),
//             message.notification!.android!.channelId.toString(),
//             importance: Importance.max,
//             showBadge: true,
//             playSound: true);
//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       androidNotificationChannel.id.toString(),
//       androidNotificationChannel.name.toString(),
//       channelDescription: 'Flutter Notification',
//       importance: Importance.max,
//       priority: Priority.max,
//       ticker: 'ticker',
//       sound: androidNotificationChannel.sound,
//     );
//
//     DarwinNotificationDetails iosNotificationDetails =
//         const DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );
//
//     NotificationDetails notificationDetails = NotificationDetails(
//         android: androidNotificationDetails, iOS: iosNotificationDetails);
//
//     _flutterLocalNotificationsPlugin.show(0, message.notification!.title,
//         message.notification!.body, notificationDetails);
//   }
// }
//
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class LocalNotificationService {
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   static void initialize() {
//     // initializationSettings  for Android
//     const InitializationSettings initializationSettings =
//     InitializationSettings(
//       android: AndroidInitializationSettings("@mipmap/ic_launcher"),
//     );
//
//     _notificationsPlugin.initialize(
//       initializationSettings,
//       // onSelectNotification: (String? id) async {
//       //   print("onSelectNotification");
//       //   if (id!.isNotEmpty) {
//       //     print("Router Value1234 $id");
//       //
//       //     // Navigator.of(context).push(
//       //     //   MaterialPageRoute(
//       //     //     builder: (context) => DemoScreen(
//       //     //       id: id,
//       //     //     ),
//       //     //   ),
//       //     // );
//       //
//       //
//       //   }
//       // },
//     );
//   }
//
//   static void createanddisplaynotification(RemoteMessage message) async {
//     try {
//       final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//       NotificationDetails notificationDetails = NotificationDetails(
//         android: AndroidNotificationDetails(
//             "pushnotificationapp", "pushnotificationappchannel",
//             importance: Importance.max,
//             priority: Priority.high,
//             sound: RawResourceAndroidNotificationSound(message.notification!.android!.sound!.split('.')[0])
//           // playSound: false,
//         ),
//       );
//
//       await _notificationsPlugin.show(
//         id,
//         message.notification!.title,
//         message.notification!.body,
//         notificationDetails,
//       );
//     } on Exception catch (e) {
//       print(e);
//     }
//   }
// }
//
//
// // {
// // "to": "cYZ5bEMjQA6p3zwZfUh0ho:APA91bHauBFqoCq7aYHRt8dkqGtO0AZ3Z7r1icgCqHJB48nHCH-abExeI106o6xaAveM8nlT_K3DMUNUlZvZorgk80gzBSIq2CCPiI5fjfwJNlVEfvE3nRmlQrDIVpCxZpWkPItaYuJS",
// // "notification" : {
// // "title" : "Jaggps 2",
// // "body" : "Sound Testing",
// // "sound" : "notify01.wav",
// // "android_channel_id": "pushnotificationapp"
// // }
// // }
