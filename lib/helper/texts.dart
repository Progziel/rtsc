import 'package:flutter/material.dart';

import 'colors.dart';

class MyTextsHelper {
  static Text simpleText(String text, {Color color = MyColorHelper.red1}) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static Widget title(String title) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: MyColorHelper.black,
          ),
        ),
      );

  static Widget item(String string1, String? string2) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        children: [
          Text(
            string1,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              string2 ?? 'Null',
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          )
        ],
      ),
    );
  }

  static Widget statusText(String text,
      {Color textColor = Colors.white,
      Color backgroundColor = MyColorHelper.red}) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(8.0)),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
