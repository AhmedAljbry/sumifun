import 'package:flutter/material.dart';

class DrawerItemModel {
  final String title;
  final IconData image;
  final Widget widget;

  const DrawerItemModel({required this.widget, required this.title, required this.image});
}