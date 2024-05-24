import 'dart:async';

import 'package:app/admin/controller/auth_controller.dart';
import 'package:app/admin/view/dashboard/screen.dart';
import 'package:app/helper/buttons/buttons.dart';
import 'package:app/helper/colors.dart';
import 'package:app/helper/designs.dart';
import 'package:app/helper/dialog.dart';
import 'package:app/helper/snackbars.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

part 'form.dart';

class MyAdminAuthScreen extends StatefulWidget {
  const MyAdminAuthScreen({
    super.key,
  });

  @override
  State<MyAdminAuthScreen> createState() => _MyAdminAuthScreenState();
}

class _MyAdminAuthScreenState extends State<MyAdminAuthScreen> {
  final _authController = MyAdminAuthController();
  VideoPlayerController? controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.asset('assets/videos/intro.mp4')
      ..initialize().then((_) {
        setState(() {});
        controller?.setLooping(true);
        controller?.setVolume(0); // Mute the video
        controller?.play();
      }).onError((error, stackTrace) => null);

    if (FirebaseAuth.instance.currentUser != null &&
        FirebaseAuth.instance.currentUser!.email == 'admin@gmail.com') {
      Timer.periodic(1.seconds, (timer) {
        Get.offAll(() => const MyAdminDashboardScreen());
        timer.cancel();
      });
    }
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
                width: controller?.value.size.width ?? 0,
                height: controller?.value.size.height ?? 0,
                child: VideoPlayer(controller!),
              ),
            ),
          ),
          (FirebaseAuth.instance.currentUser != null &&
                  FirebaseAuth.instance.currentUser!.email == 'admin@gmail.com')
              ? AlertDialog(
                  backgroundColor: MyColorHelper.black.withOpacity(0.90),
                  scrollable: true,
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        CircularProgressIndicator(
                          color: MyColorHelper.white.withOpacity(0.90),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Loading...',
                          style: TextStyle(
                            color: MyColorHelper.white.withOpacity(0.90),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : context.width < 400 || !context.isLandscape
                  ? _MyForm(_authController)
                  : Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 400,
                        margin: EdgeInsets.only(right: context.width * 0.04),
                        child: _MyForm(_authController),
                      ),
                    ),
        ],
      ),
    );
  }
}
