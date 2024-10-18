import 'package:flutter/material.dart';

class QrEmployeeScreen extends StatelessWidget {
  const QrEmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Empleado'),
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
