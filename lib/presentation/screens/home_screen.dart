import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(
        child: Placeholder(
          fallbackHeight: 200, // Altura predeterminada del placeholder
          fallbackWidth: 200, // Ancho predeterminado del placeholder
          color: Colors.grey, // Color del placeholder
          strokeWidth: 2, // Grosor de la línea del placeholder
        ),
      ),
    );
  }
}
