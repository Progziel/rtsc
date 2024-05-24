import 'dart:ui';

import 'package:app/admin/view/auth/auth.dart';
import 'package:app/company/view/auth/screen.dart';
import 'package:app/essentials/contact_us.dart';
import 'package:app/essentials/delete_account.dart';
import 'package:app/essentials/privacy_policy.dart';
// import 'package:app/media/view/auth/screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  Permission.notification.request();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      getPages: [
        GetPage(name: '/', page: () => const MyCompanyAuthScreen()),
        GetPage(name: '/admin', page: () => const MyAdminAuthScreen()),
        GetPage(name: '/privacy_policy', page: () => const MyPrivacyPolicy()),
        GetPage(name: '/user_support', page: () => MyContactUsWebPage()),
        GetPage(name: '/delete_account', page: () => MyDeleteAccount()),
      ],
      initialRoute: '/',
      // home: const MyMediaAuthScreen(),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices =>
      {PointerDeviceKind.touch, PointerDeviceKind.mouse};
}
