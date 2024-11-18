import 'package:flutter/material.dart';

class YellowButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isEnabled;
  final double width;
  final bool isLoading;
  final double fontSize;
  final EdgeInsets padding;

  const YellowButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.isEnabled = true,
      this.width = 150,
      this.isLoading = false,
      this.padding = const EdgeInsets.symmetric(vertical: 8),
      this.fontSize = 18});

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircularProgressIndicator()
        : SizedBox(
            width: width,
            child: ElevatedButton(
              onPressed: isEnabled ? onPressed : null,
              style: ElevatedButton.styleFrom(padding: padding),
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
  }
}
