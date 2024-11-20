import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
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
