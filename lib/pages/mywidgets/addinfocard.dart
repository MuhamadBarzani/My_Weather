import 'package:flutter/material.dart';

class AddInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final TextStyle labelStyle;
  final TextStyle valueStyle;

  const AddInfoCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor = Colors.white,
    this.labelStyle = const TextStyle(fontSize: 14),
    this.valueStyle = const TextStyle(fontSize: 14),
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // Make the card responsive
      child: Column(
        children: [
          Icon(
            icon,
            size: 35,
            color: iconColor,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: labelStyle,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: valueStyle,
          ),
        ],
      ),
    );
  }
}
