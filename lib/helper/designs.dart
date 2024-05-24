import 'package:flutter/material.dart';

import 'colors.dart';

class MyDecorationHelper {
  static InputDecoration textFieldDecoration({
    IconData? prefixIcon,
    String? label,
    String? hints,
    bool isDense = false,
    double borderRadius = 16.0,
    Color borderColor = MyColorHelper.red1,
    Color labelColor = Colors.black87,
    Color? backgroundColor,
  }) =>
      InputDecoration(
        hintText: hints,
        labelText: label,
        fillColor: backgroundColor ?? MyColorHelper.white.withOpacity(0.10),
        filled: true,
        isDense: isDense,
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Icon(
                  prefixIcon,
                  size: 32,
                  color: borderColor,
                ),
              )
            : null,
        labelStyle: TextStyle(color: labelColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor, width: 2.0),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor, width: 2.0),
        ),
      );
}

class WaterPainter extends CustomPainter {
  WaterPainter({this.color = MyColorHelper.black1});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color.withOpacity(0.20);

    Path path1 = Path();
    path1.moveTo(0, size.height);
    path1.quadraticBezierTo(
      size.width / 4,
      size.height * 0.88,
      size.width / 2,
      size.height,
    );
    path1.quadraticBezierTo(
      size.width * 3 / 4,
      size.height * 1.15,
      size.width,
      size.height,
    );
    path1.lineTo(size.width, 0);
    path1.lineTo(0, 0);
    path1.close();

    Path path2 = Path();
    path2.moveTo(0, size.height);
    path2.quadraticBezierTo(
      size.width / 4,
      size.height * 0.80,
      size.width / 2,
      size.height,
    );
    path2.quadraticBezierTo(
      size.width * 3 / 4,
      size.height * 1.20,
      size.width,
      size.height,
    );
    path2.lineTo(size.width, 0);
    path2.lineTo(0, 0);
    path2.close();

    canvas.drawPath(path1, paint);
    paint.color = color.withOpacity(0.10);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
