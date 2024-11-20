import 'package:flutter/material.dart';
import 'package:gym_force/presentation/widgets/navigation/drawer_nav_menu.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: const DrawerNavMenu(),
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
