import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_force/widgets/bottom_nav_bar.dart';
import 'package:gym_force/widgets/drawer_menu.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello Home'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: DrawerMenu(), // Menú desplegable
      body: Center(child: Text('Hello Home Screen')),
      bottomNavigationBar: BottomNavBar(currentIndex: 0), // Bottom bar
    );
  }
}
