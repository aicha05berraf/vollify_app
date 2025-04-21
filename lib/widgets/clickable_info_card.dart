import 'package:flutter/material.dart';

class ClickableInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final VoidCallback onTap;
  final Widget? child;

  const ClickableInfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              child ?? Text(value, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 4),
              const Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.open_in_new, size: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
