// widgets/profile_info_card.dart
import 'package:flutter/material.dart';

class ProfileInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final Widget? child;
  final IconData icon;

  const ProfileInfoCard({
    super.key,
    required this.title,
    this.value = '',
    this.child,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          child ?? Text(value), // Provide fallback widget
          const SizedBox(height: 8),
          const Divider(),
        ],
      ),
    );
  }
}
