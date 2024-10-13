import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_force/config/providers/user_provider.dart';

class DrawerNavMenu extends ConsumerWidget {
  // Cambiar de StatelessWidget a ConsumerWidget
  const DrawerNavMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Agregar el WidgetRef
    // Accede al notifier del estado de usuario
    final userNotifier = ref.read(userProvider.notifier);

    return Drawer(
      backgroundColor: const Color(0xFF121212),
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.calendar_today, color: Color(0xFFFFD300)),
            title:
                const Text('Calendario', style: TextStyle(color: Colors.white)),
            onTap: () {
              context.push('/calendar');
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on, color: Color(0xFFFFD300)),
            title: const Text('Sedes', style: TextStyle(color: Colors.white)),
            onTap: () {
              context.push('/headquarter');
            },
          ),
          ListTile(
            leading:
                const Icon(Icons.card_membership, color: Color(0xFFFFD300)),
            title:
                const Text('Membresías', style: TextStyle(color: Colors.white)),
            onTap: () {
              context.push('/membership');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Salir', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Llama a la función logOut del UserNotifier
              userNotifier.logOut();

              // Redirigir al login después de cerrar sesión
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}
