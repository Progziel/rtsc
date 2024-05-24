import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'colors.dart';

class MyTabModel {
  MyTabModel({
    required this.iconData,
    required this.title,
    required this.openBody,
  });
  final IconData iconData;
  final String title;
  final Widget openBody;
}

class MyTab extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const MyTab({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Row(
              children: [
                Icon(icon),
                const SizedBox(width: 10),
                Text(
                  text,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.black)
              ],
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}

class OpenScreen extends StatelessWidget {
  const OpenScreen({
    super.key,
    required this.widget,
    required this.string,
    required this.openBody,
  });
  final Widget widget;
  final String string;
  final Widget openBody;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                height: context.height * 0.25,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: MyColorHelper.red.withOpacity(0.25),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24.0),
                        bottomRight: Radius.circular(24.0))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8.0),
                    Expanded(child: widget),
                    const SizedBox(height: 8.0),
                    Text(
                      string,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              openBody,
            ],
          ),
        ),
      ),
    );
  }
}
