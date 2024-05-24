import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'colors.dart';

class MySnackBarsHelper {
  static void showError(String value) => Get.snackbar('Error!', value,
      colorText: Colors.white,
      backgroundColor: MyColorHelper.red.withOpacity(0.80));
  static void showRequired(String value) => Get.snackbar('Required*', value,
      colorText: Colors.white,
      backgroundColor: MyColorHelper.red.withOpacity(0.80));
  static void showMessage(String value, {bool dark = false}) =>
      Get.snackbar('Message', value,
          colorText: MyColorHelper.white,
          backgroundColor: dark
              ? MyColorHelper.black.withOpacity(0.80)
              : MyColorHelper.red.withOpacity(0.80));
}
