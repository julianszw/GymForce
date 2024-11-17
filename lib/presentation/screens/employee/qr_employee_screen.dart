import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_force/config/providers/payment_provider.dart';
import 'package:gym_force/presentation/screens/employee/confirmation_screen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:gym_force/config/providers/user_provider.dart';

class QrEmployeeScreen extends ConsumerStatefulWidget {
  const QrEmployeeScreen({Key? key}) : super(key: key);

  @override
  _QrEmployeeScreenState createState() => _QrEmployeeScreenState();
}

class _QrEmployeeScreenState extends ConsumerState<QrEmployeeScreen> {
  bool _isProcessing = false;

  Future<void> _handleQrData(String rawValue, String expectedBarrio) async {
    try {
      // Decodificar los datos del QR
      final Map<String, dynamic> qrData = jsonDecode(rawValue);

      // Validar datos esenciales en el QR
      if (!qrData.containsKey('hora') || !qrData.containsKey('barrio') || !qrData.containsKey('uid')) {
        throw Exception("El QR no contiene los campos esperados.");
      }
      if (qrData['barrio'] != expectedBarrio) {
        throw Exception("El barrio no coincide con el esperado.");
      }

      final DateTime qrTime = DateTime.parse(qrData['hora']);
      if (DateTime.now().difference(qrTime).inSeconds > 60) {
        throw Exception("El QR ha expirado.");
      }

      final String uid = qrData['uid'];

      // Obtener datos de usuario y pago
      final userData = await _getUserData(uid);
      final paymentData = await _getPaymentData(uid);

      // Validar estado de pago
      final bool isPaymentValid = _validatePayment(paymentData);
      if (!isPaymentValid) {
        throw Exception("El pago asociado al usuario no es válido o ha expirado.");
      }



      ref.read(paymentProvider.notifier).setPayment(
            amount: paymentData['amount'],
            date: paymentData['date'],
            duration: paymentData['duration'],
            title: paymentData['title'],
            transactionId: paymentData['transactionId'],
            userId: paymentData['userId'],
            expirationDate: paymentData['expirationDate'],
          );

      // Navegar a la pantalla de confirmación
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmationScreen(
            userData: userData,
            uid: uid,
            barrio: qrData['barrio'],
          ),
        ),
      );
    } catch (e) {
      // Mostrar mensaje de error
      _showResultDialog("Error", e.toString());
    }
  }

  Future<Map<String, dynamic>> _getUserData(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (!doc.exists) {
      throw Exception("No se encontró al usuario con el UID proporcionado.");
    }

    final data = doc.data()!;
    if (data['birthdate'] is Timestamp) {
      data['birthdate'] = (data['birthdate'] as Timestamp).toDate();
    }
    return data;
  }

  Future<Map<String, dynamic>> _getPaymentData(String uid) async {
    final query = await FirebaseFirestore.instance
        .collection('payments')
        .where('userId', isEqualTo: uid)
        .orderBy('date', descending: true)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      throw Exception("No se encontró un pago reciente para este usuario.");
    }

    final data = query.docs.first.data();
    if (data['date'] is Timestamp) {
      data['date'] = (data['date'] as Timestamp).toDate();
    }
    if (data['expirationDate'] is Timestamp) {
      data['expirationDate'] = (data['expirationDate'] as Timestamp).toDate();
    }

    return data;
  }

  bool _validatePayment(Map<String, dynamic> paymentData) {
    final DateTime expirationDate = paymentData['expirationDate'];
    return DateTime.now().isBefore(expirationDate);
  }

  void _showResultDialog(String title, String content) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);

    if (userState.barrioAsignado == null) {
      return const Scaffold(
        body: Center(
          child: Text("No tienes un barrio asignado."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Escanear QR"),
      ),
      body: MobileScanner(
        controller: MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates),
        onDetect: (capture) {
          if (_isProcessing) return;
          _isProcessing = true;
          final barcode = capture.barcodes.first;
          if (barcode?.rawValue != null) {
            _handleQrData(barcode!.rawValue!, userState.barrioAsignado!).whenComplete(() {
              _isProcessing = false;
            });
          } else {
            _isProcessing = false;
          }
        },
      ),
    );
  }
}
