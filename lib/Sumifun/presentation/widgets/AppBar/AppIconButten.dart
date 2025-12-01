import 'package:flutter/material.dart';

class AppIconButten extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const AppIconButten({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }
}