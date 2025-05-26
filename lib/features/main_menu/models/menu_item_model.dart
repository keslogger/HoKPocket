// lib/features/main_menu/models/menu_item_model.dart
import 'package:flutter/material.dart';

class MenuItemModel {
  final String title;
  final String? iconLightPath;
  final String? iconDarkPath;
  final IconData? flutterIcon;
  final VoidCallback? onTap;

  MenuItemModel({
    required this.title,
    this.iconLightPath,
    this.iconDarkPath,
    this.flutterIcon,
    this.onTap,
  });
}
