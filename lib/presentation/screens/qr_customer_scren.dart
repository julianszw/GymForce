import 'package:flutter/material.dart';
import 'package:gym_force/presentation/widgets/navigation/drawer_nav_menu.dart';

class QrCustomerScren extends StatelessWidget {
  const QrCustomerScren({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Customer'),
      ),
      drawer: const DrawerNavMenu(),
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
