import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

import 'package:gym_force/utils/common_dialog.dart';

class ConfirmationScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> userData;
  final String uid;
  final String barrio;

  const ConfirmationScreen({
    Key? key,
    required this.userData, required this.uid, required this.barrio,
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
        "timestamp": DateTime.now()
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmación'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.userData['profile']),
              radius: 50,
            ),
            const SizedBox(height: 20),
            Text('Nombre: ${widget.userData['name']}'),
            Text('Rol: ${widget.userData['role']}'),
            const SizedBox(height: 20),

                                Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              showCommonDialog(
                                  acceptText: 'Descartar',
                                  context: context,
                                  description:
                                      'Si no guardas, perderás el progreso.',
                                  onAccept: () {
                                    context.pop();
                                  },
                                  title: '¿Estás seguro?',
                                  buttonTextSize: 14,
                                  buttonWidth: 80);
                            },
                            icon: const Icon(Icons.cancel,
                                color: Colors.black),
                            label: const Text(
                              'Cancelar Ingreso',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              showCommonDialog(
                                  title: '¿Terminar rutina?',
                                  acceptText: 'Terminar',
                                  context: context,
                                  description:
                                      '¿Estás seguro de que querés terminar la rutina?',
                                  onAccept: () {
                                    registerAccess(widget.uid, widget.barrio);
                                  },
                                  buttonTextSize: 14,
                                  buttonWidth: 80);
                            },
                            icon: const Icon(Icons.save, color: Colors.black),
                            label: const Text(
                              'Confirmar ingreso',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),

          ],
        ),
      ),
    );
  }


}


