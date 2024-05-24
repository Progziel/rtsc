import 'package:flutter/material.dart';

class MyDashboardModel {
  MyDashboardModel({
    required this.icon,
    required this.title,
    required this.widget,
  });
  final IconData icon;
  final String title;
  final Widget widget;
}

class MyTopTabModel {
  MyTopTabModel({
    required this.title,
    required this.icon,
    required this.subtitle,
    required this.widget,
  });
  final String title, subtitle;
  final IconData icon;
  final Widget widget;
}
