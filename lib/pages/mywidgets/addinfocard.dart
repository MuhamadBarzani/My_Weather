import 'package:flutter/material.dart';

class AddInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const AddInfoCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        children: [
          Icon(
            icon,
            size: 35,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 14))
        ],
      ),
    );
  }
}
