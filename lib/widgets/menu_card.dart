import 'package:flutter/material.dart';
import '../models/menu_option.dart';

class MenuCard extends StatelessWidget {
  final MenuOption option;

  const MenuCard({
    Key? key,
    required this.option,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${option.title} feature coming soon!')),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(8.0), // Reduced padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // Use minimum height needed
            children: [
              Container(
                padding: const EdgeInsets.all(10), // Reduced padding
                decoration: BoxDecoration(
                  color: option.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  option.icon,
                  color: option.color,
                  size: 28, // Smaller icon
                ),
              ),
              const SizedBox(height: 8),
              Text(
                option.title,
                style: const TextStyle(
                  fontSize: 16, // Smaller text
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  option.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12, // Smaller text
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
