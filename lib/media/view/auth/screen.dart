library auth_view;

import 'dart:io';

import 'package:app/helper/buttons/buttons.dart';
import 'package:app/helper/colors.dart';
import 'package:app/helper/designs.dart';
import 'package:app/helper/responsive.dart';
import 'package:app/helper/snackbars.dart';
import 'package:app/media/controller/auth_controller.dart';
import 'package:app/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

part 'form.dart';

class MyMediaAuthScreen extends StatefulWidget {
  const MyMediaAuthScreen({super.key});

  @override
  State<MyMediaAuthScreen> createState() => _MyMediaAuthScreenState();
}

class _MyMediaAuthScreenState extends State<MyMediaAuthScreen> {
  MyMediaAuthController controller = MyMediaAuthController();
  VideoPlayerController? videoController;

  @override
  void initState() {
    super.initState();
    videoController = VideoPlayerController.asset('assets/videos/intro.mp4')
      ..initialize().then((_) {
        setState(() {});
        videoController?.setLooping(true);
        videoController?.setVolume(0); // Mute the video
        videoController?.play();
      }).onError((error, stackTrace) => null);
    _requestPermissions();
    // MyNotificationServices(context);
    controller.isLoading.value = true;
    controller.finalCheck();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: videoController?.value.size.width ?? 0,
                height: videoController?.value.size.height ?? 0,
                child: VideoPlayer(videoController!),
              ),
            ),
          ),
          _MyForm(controller),
        ],
      ),
    );
  }

  Future<void> _requestPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    if (Platform.isIOS) {
      await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true,
      );
    }

    NotificationSettings notificationSettings =
        await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      print('Authorized Permission');
      print(await messaging.getToken());
    } else if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('Provisional Permission');
      print(await messaging.getToken());
    } else {
      print('Permission not granted');
    }
  }
}
