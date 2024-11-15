import 'package:flutter/material.dart';

class YellowButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isEnabled;

  const YellowButton({
    required this.onPressed,
    required this.text,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled ? Color(0xFFFFD700) : Colors.grey,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
      onPressed: isEnabled ? onPressed : null,
      child: Text(text, style: TextStyle(fontSize: 16)),
    );
  }
}
