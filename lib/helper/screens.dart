import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'colors.dart';
import 'designs.dart';

class MyScreensHelper {
  static Widget simpleScreen(
          {required BuildContext context,
          String? title,
          Widget? widget,
          required Widget body,
          Color headerColor = MyColorHelper.red}) =>
      Stack(
        children: [
          CustomPaint(
            size: Size(double.infinity, context.height * 0.34),
            painter: WaterPainter(color: headerColor),
          ),
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: true,
                foregroundColor: Colors.white,
                elevation: 0,
                title: (title != null)
                    ? Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : (widget != null)
                        ? widget
                        : const SizedBox.shrink(),
              ),
              Expanded(
                  child:
                      simpleBackground(borderColor: headerColor, child: body)),
            ],
          )
        ],
      );

  static Widget simpleBackground(
          {Widget? child, Color borderColor = MyColorHelper.red}) =>
      Card(
        margin: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(color: borderColor, width: 2),
        ),
        color: MyColorHelper.white.withOpacity(0.95),
        elevation: 4.0,
        child: child,
      );
}
