import 'package:flutter/material.dart';

class LoadingStatus extends StatelessWidget {
  final String status;

  const LoadingStatus({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Text(
      status.toUpperCase(),
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.4),
        fontSize: 12,
        fontWeight: FontWeight.normal,
        letterSpacing: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }
}
