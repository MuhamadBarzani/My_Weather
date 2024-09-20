import 'package:flutter/material.dart';

class HourlyCard extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;
  final double elevation;

  const HourlyCard({
    super.key,
    required this.time,
    required this.icon,
    required this.temp,
    this.elevation = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.25, // Responsive width
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Icon(icon, size: 35),
            const SizedBox(height: 8),
            Text(
              temp,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
