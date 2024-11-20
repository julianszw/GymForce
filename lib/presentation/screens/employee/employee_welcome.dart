import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_force/config/providers/user_provider.dart';
import 'package:gym_force/services/branch_services.dart';

class EmployeeWelcomeScreen extends ConsumerStatefulWidget {
  const EmployeeWelcomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EmployeeWelcomeScreen> createState() =>
      _EmployeeWelcomeScreenState();
}

class _EmployeeWelcomeScreenState
    extends ConsumerState<EmployeeWelcomeScreen> {
  final BranchService _branchService = BranchService();

  Future<String?> _getBranchImage(String? barrioAsignado) async {
    if (barrioAsignado == null || barrioAsignado.isEmpty) return null;

    final branch = await _branchService.getBranchByBarrio(barrioAsignado);
    return branch?.outsidePic;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final userNotifier = ref.read(userProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fitness_center, color: Colors.white),
            SizedBox(width: 8), // Espaciado entre el ícono y el texto
            Text(
              'GymForce',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.logout, color: Colors.red),
          onPressed: () {
            userNotifier.logOut();
            context.go('/auth');
          },
        ),
        elevation: 0,
        backgroundColor: Colors.black54,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Bienvenido, ${user.name ?? 'Empleado'}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Sucursal: ${user.barrioAsignado ?? 'Desconocido'}',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FutureBuilder<String?>(
              future: _getBranchImage(user.barrioAsignado),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text(
                    'Error al cargar la imagen.',
                    style: TextStyle(color: Colors.red),
                  );
                } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return Column(
                    children: const [
                      Icon(Icons.image_not_supported,
                          size: 100, color: Colors.grey),
                      SizedBox(height: 10),
                      Text(
                        'No hay imagen disponible',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  );
                } else {
                  return Image.network(
                    snapshot.data!,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text(
                        'No se pudo cargar la imagen.',
                        style: TextStyle(color: Colors.red),
                      );
                    },
                  );
                }
              },
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[700],
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () => context.push('/qr-employee'), // Navegar a QR Screen
              child: const Text(
                'Escanear QRs',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
