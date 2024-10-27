import 'package:flutter/material.dart';

class YellowButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isEnabled;
  final double width;
  final bool isLoading;

  const YellowButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isEnabled = true,
    this.width = 150,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircularProgressIndicator()
        : SizedBox(
            width: width,
            child: ElevatedButton(
              onPressed: isEnabled ? onPressed : null,
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
  }
}
