import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HeadquarterScreen extends StatelessWidget {
  const HeadquarterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sedes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Ícono de retroceso
          onPressed: () {
            context.pop();
          },
        ),
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
