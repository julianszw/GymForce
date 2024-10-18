import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayuda'),
      ),
      body: const Center(
        child: Placeholder(
          fallbackHeight: 200,
          fallbackWidth: 200,
          color: Colors.grey,
          strokeWidth: 2,
        ),
      ),
    );
  }
}
