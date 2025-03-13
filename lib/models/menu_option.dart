import 'package:flutter/material.dart';

class MenuOption {
  final String title;
  final IconData icon;
  final Color color;
  final String description;
  final String route;

  MenuOption({
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
    required this.route,
  });
}
