import 'package:flutter/material.dart';

import 'colors.dart';

class MyDialogHelper {
  static void showLoadingDialog(BuildContext context,
          {String text = 'Loading...', bool dark = false}) =>
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: dark
              ? MyColorHelper.black.withOpacity(0.90)
              : MyColorHelper.white.withOpacity(0.90),
          scrollable: true,
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CircularProgressIndicator(
                    color: dark
                        ? MyColorHelper.white.withOpacity(0.90)
                        : MyColorHelper.black.withOpacity(0.90)),
                const SizedBox(height: 8.0),
                Text(
                  text,
                  style: TextStyle(
                      color: dark
                          ? MyColorHelper.white.withOpacity(0.90)
                          : MyColorHelper.black.withOpacity(0.90)),
                ),
              ],
            ),
          ),
        ),
      );
}
