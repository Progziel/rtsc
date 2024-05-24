library buttons_helper;

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../colors.dart';
import '../screens.dart';

part 'attach.dart';
part 'icon_button.dart';
part 'open_icon_button.dart';
part 'open_profile_button.dart';
part 'open_simple_button.dart';
part 'simple_button.dart';
part 'simple_with_icon_button.dart';
part 'text_button.dart';

class MyButtonHelper {
  static Widget simpleButton(
          {required String buttonText,
          required VoidCallback onTap,
          double margin = 8.0,
          double padding = 16.0,
          double fontSize = 16.0,
          Color buttonColor = MyColorHelper.black,
          Color borderColor = MyColorHelper.black,
          Color textColor = Colors.white,
          bool disable = false}) =>
      _simpleButton(margin, padding, fontSize, buttonText, onTap, buttonColor,
          borderColor, textColor, disable);

  static Widget openSimpleButton(
          {required String buttonText,
          double margin = 8.0,
          double padding = 16.0,
          double fontSize = 16.0,
          Color buttonColor = MyColorHelper.black,
          Color borderColor = MyColorHelper.black,
          Color textColor = Colors.white,
          bool disable = false,
          required Widget openBody}) =>
      _openSimpleButton(margin, padding, fontSize, buttonText, buttonColor,
          borderColor, textColor, disable, openBody);

  static Widget text(
          {String text = 'Text',
          Color textColor = MyColorHelper.red1,
          required VoidCallback onTap}) =>
      InkWell(
        onTap: onTap,
        child: Text(
          text,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      );

  static Widget openIconButton(
          {IconData iconData = Icons.add,
          double iconSize = 30,
          Color iconColor = Colors.white,
          Color backgroundColor = MyColorHelper.black,
          double margin = 4.0,
          required String openTitle,
          required Widget openContainer}) =>
      _openIconButton(iconData, iconSize, iconColor, backgroundColor, margin,
          openTitle, openContainer);

  static Widget openProfileButton({required Widget openContainer}) =>
      _openProfileButton(openContainer);

  static Widget iconButton(
          {IconData iconData = Icons.add,
          double iconSize = 30,
          Color iconColor = Colors.white,
          Color backgroundColor = MyColorHelper.black,
          double margin = 4.0,
          required VoidCallback onTap}) =>
      _iconButton(
          iconData, iconSize, iconColor, backgroundColor, margin, onTap);

  static Widget attach({
    Color borderColor = MyColorHelper.red1,
    Color textColor = MyColorHelper.red1,
    String text = 'Please Select file',
    IconData icon = Icons.attach_file_rounded,
    required VoidCallback onTap,
  }) =>
      _attach(borderColor, textColor, text, icon, onTap);
}
