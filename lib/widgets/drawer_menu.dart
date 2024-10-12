import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFF121212),
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.calendar_today, color: Color(0xFFFFD300)),
            title: Text('Calendario', style: TextStyle(color: Colors.white)),
            onTap: () {
              context.go('/calendar');
            },
          ),
          ListTile(
            leading: Icon(Icons.location_on, color: Color(0xFFFFD300)),
            title: Text('Sedes', style: TextStyle(color: Colors.white)),
            onTap: () {
              context.go('/headquarter');
            },
          ),
          ListTile(
            leading: Icon(Icons.card_membership, color: Color(0xFFFFD300)),
            title: Text('Membresías', style: TextStyle(color: Colors.white)),
            onTap: () {
              context.go('/membership');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Salir', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Lógica para salir
            },
          ),
        ],
      ),
    );
  }
}
