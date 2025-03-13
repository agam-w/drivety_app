import 'package:flutter/material.dart';

class StatusData {
  static final List<Map<String, dynamic>> items = [
    {
      'icon': Icons.people,
      'label': 'Staff',
      'value': '35/40',
      'color': Colors.blue
    },
    {
      'icon': Icons.warning,
      'label': 'Incidents',
      'value': '0',
      'color': Colors.green
    },
    {
      'icon': Icons.check_circle,
      'label': 'Checks',
      'value': '12/20',
      'color': Colors.orange
    },
  ];
}
