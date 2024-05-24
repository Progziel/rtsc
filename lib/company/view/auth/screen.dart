import 'package:app/company/controller/company_auth_controller.dart';
import 'package:app/helper/buttons/buttons.dart';
import 'package:app/helper/colors.dart';
import 'package:app/helper/designs.dart';
import 'package:app/helper/dialog.dart';
import 'package:app/helper/image_picker.dart';
import 'package:app/helper/responsive.dart';
import 'package:app/helper/snackbars.dart';
import 'package:app/model/company_model.dart';
import 'package:app/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

part 'forget.dart';
part 'login.dart';
part 'singup.dart';

class MyCompanyAuthScreen extends StatefulWidget {
  const MyCompanyAuthScreen({super.key});

  @override
  State<MyCompanyAuthScreen> createState() => _MyCompanyAuthScreenState();
}

class _MyCompanyAuthScreenState extends State<MyCompanyAuthScreen> {
  MyCompanyAuthController controller = MyCompanyAuthController();
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
    controller.loadInitialData();
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
          Obx(() => (!controller.currentUserExits)
              ? context.width < myDefaultMaxWidth / 2 || !context.isLandscape
                  ? controller.auth == 1
                      ? _MyLoginScreen(controller)
                      : controller.auth == 2
                          ? _MyForgetPasswordForm(controller)
                          : _MySingUpScreen(controller)
                  : Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: (context.isLandscape && controller.auth == 0)
                            ? myDefaultMaxWidth
                            : (myDefaultMaxWidth / 2) * 1.25,
                        margin: EdgeInsets.only(right: context.width * 0.04),
                        child: controller.auth == 1
                            ? _MyLoginScreen(controller)
                            : controller.auth == 2
                                ? _MyForgetPasswordForm(controller)
                                : _MySingUpScreen(controller),
                      ),
                    )
              : _MySingUpScreen(controller, userLoggedIn: true)),
        ],
      ),
    );
  }
}
