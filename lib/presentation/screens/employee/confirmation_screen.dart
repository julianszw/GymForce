import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // Asegúrate de importar este paquete

import 'package:gym_force/utils/common_dialog.dart';

class ConfirmationScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> userData;
  final String uid;
  final String barrio;
  final DateTime expirationDate;

  const ConfirmationScreen({
    Key? key,
    required this.userData,
    required this.uid,
    required this.barrio,
    required this.expirationDate,
  }) : super(key: key);

  @override
  ConsumerState<ConfirmationScreen> createState() => ConfirmationScreenState();
}

class ConfirmationScreenState extends ConsumerState<ConfirmationScreen> {
  Future<void> registerAccess(String uid, String barrio) async {
    final router = GoRouter.of(context);
    try {
      await FirebaseFirestore.instance.collection('user_entry').add({
        "branch": barrio,
        "uid": uid,
        "timestamp": DateTime.now(),
      });

      if (context.mounted) {
        router.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Ingreso registrado!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      print("Error registrando el acceso: $e");
    }
  }

  void _showUserDetails() {
    String formattedExpirationDate =
        DateFormat('dd/MM/yyyy').format(widget.expirationDate);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Detalles del usuario'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.userData['profile']),
                radius: 40,
              ),
              const SizedBox(height: 10),
              Text('Nombre: ${widget.userData['name']}'),
              Text('Género: ${widget.userData['gender']}'),
              Text('DNI: ${widget.userData['dni']}'),
              Text('Teléfono: ${widget.userData['phone']}'),
              Text('Email: ${widget.userData['email']}'),
              Text('Vencimiento: $formattedExpirationDate'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedExpirationDate =
        DateFormat('dd/MM/yyyy').format(widget.expirationDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Validacion de Ingreso'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Foto de perfil y nombre
            CircleAvatar(
              backgroundImage: NetworkImage(widget.userData['profile']),
              radius: 50,
            ),
            const SizedBox(height: 10),
            Text(
              widget.userData['name'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.expirationDate.isAfter(DateTime.now())
                      ? Icons.check_circle
                      : Icons.cancel,
                  color: widget.expirationDate.isAfter(DateTime.now())
                      ? Colors.green
                      : Colors.red,
                ),
                const SizedBox(width: 5),
                Text(
                  widget.expirationDate.isAfter(DateTime.now())
                      ? 'Membresía válida hasta $formattedExpirationDate'
                      : 'No activa',
                  style: TextStyle(
                    color: widget.expirationDate.isAfter(DateTime.now())
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Botones de Confirmar y Denegar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    showCommonDialog(
                      acceptText: 'Denegar',
                      context: context,
                      description: '¿Seguro que quieres denegarle el ingreso a la persona?',
                      onAccept: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Ingreso denegado'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      title: 'Denegacion de ingeso',
                    );
                  },
                  icon: const Icon(Icons.cancel),
                  label: const Text('Denegar'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    registerAccess(widget.uid, widget.barrio);
                  },
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Validar'),
                ),
              ],
            ),

            // Flecha para desplegar detalles
            const SizedBox(height: 20),
            IconButton(
              icon: const Icon(Icons.arrow_drop_down_circle, size: 30),
              onPressed: _showUserDetails,
            ),
          ],
        ),
      ),
    );
  }
}
