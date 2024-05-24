part of 'screen.dart';

Future<void> listenNotification() async {
  FirebaseMessaging.onMessage.listen((message) {
    RemoteNotification? remoteNotification = message.notification;

    try {
      Get.snackbar(remoteNotification!.title!, remoteNotification.body!,
          colorText: MyColorHelper.white,
          backgroundColor: MyColorHelper.black.withOpacity(0.80));
    } catch (e) {
      Get.snackbar('Notification Error', e.toString(),
          colorText: MyColorHelper.white,
          backgroundColor: MyColorHelper.black.withOpacity(0.80));
    }
  });
}
