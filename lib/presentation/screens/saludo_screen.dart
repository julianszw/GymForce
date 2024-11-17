import 'dart:async';
import 'dart:convert'; // Para manejar JSON
import 'package:flutter/material.dart';
import 'package:gym_force/config/providers/user_provider.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SaludoScreen extends ConsumerStatefulWidget {
  final String barrio;
  final VoidCallback onCancel;

  const SaludoScreen({
    required this.barrio,
    required this.onCancel,
  });

  @override
  _SaludoScreenState createState() => _SaludoScreenState();
}

class _SaludoScreenState extends ConsumerState<SaludoScreen> {
  late int _remainingTime; // Tiempo en segundos
  Timer? _timer;
  late String _qrData; // Datos del QR generados una sola vez

  @override
  void initState() {
    super.initState();
    _remainingTime = 30; // Iniciamos con 30 segundos

    // Recuperar el estado del usuario desde el provider
    final userState = ref.read(userProvider);

    if (!userState.isLoggedIn) {
      // Si el usuario no está logueado, volvemos automáticamente
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onCancel();
      });
      return;
    }

    // Generar datos en formato JSON, incluyendo el `uid`
    final qrContent = {
      "hora": DateTime.now().toIso8601String(),
      "barrio": widget.barrio,
      "uid": userState.uid, // Agregamos el UID al QR
    };

    // Convertir a String para el QR
    _qrData = jsonEncode(qrContent);
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancelamos el temporizador si se sale de la pantalla
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        timer.cancel(); // Detenemos el temporizador al llegar a cero
        widget.onCancel(); // Volvemos a la pantalla anterior
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Mostra tu QR",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 20),
          Container(
            color: Colors.white, // Fondo blanco para el QR
            padding: const EdgeInsets.all(10), // Espacio alrededor del QR
            child: PrettyQr(
              data: _qrData, // Usamos los datos generados en formato JSON
              size: 200, // Ajusta el tamaño del QR aquí
              roundEdges: true,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Te quedan $_remainingTime segundos...",
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _timer?.cancel(); // Cancelamos el temporizador al presionar cancelar
              widget.onCancel();
            },
            child: const Text("Cancelar QR"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            ),
          ),
        ],
      ),
    );
  }
}
