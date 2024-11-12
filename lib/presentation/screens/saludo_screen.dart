import 'dart:async';
import 'package:flutter/material.dart';

class SaludoScreen extends StatefulWidget {
  final String barrio;
  final VoidCallback onCancel;

  const SaludoScreen({
    required this.barrio,
    required this.onCancel,
  });

  @override
  _SaludoScreenState createState() => _SaludoScreenState();
}

class _SaludoScreenState extends State<SaludoScreen> {
  late int _remainingTime; // Tiempo en segundos
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingTime = 30; // Iniciamos con 30 segundos
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
          Text(
            "Hola, ${widget.barrio}",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            "Volviendo en $_remainingTime segundos", // Mostramos el tiempo restante
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _timer?.cancel(); // Cancelamos el temporizador al presionar cancelar
              widget.onCancel();
            },
            child: Text("Cancelar saludo"),
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
