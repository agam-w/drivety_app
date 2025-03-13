import 'package:flutter/material.dart';
import '../models/menu_option.dart';

class Constants {
  Constants._();

  // Demo credentials
  static const String demoEmail = 'user@example.com';
  static const String demoPassword = 'password123';

  // Menu options
  static final List<MenuOption> menuOptions = [
    MenuOption(
      title: 'APD Check',
      icon: Icons.security,
      color: Colors.blue,
      description: 'Verify and inspect APD equipment status',
      route: '/apd-check',
    ),
    MenuOption(
      title: 'Health Check',
      icon: Icons.health_and_safety,
      color: Colors.green,
      description: 'Monitor and report health status',
      route: '/health-check',
    ),
    MenuOption(
      title: 'Check In',
      icon: Icons.login,
      color: Colors.orange,
      description: 'Register your attendance and location',
      route: '/check-in',
    ),
    MenuOption(
      title: 'Incident Report',
      icon: Icons.warning_amber,
      color: Colors.red,
      description: 'Report safety incidents and hazards',
      route: '/incident',
    ),
  ];
}
