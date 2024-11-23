import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MembershipService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Cualquier cosa se vuelve al backend anterior por si falla el nuevo
  // final String _baseUrl = 'https://prfinal-backend.onrender.com/api'
  final String _baseUrl = 'https://backend-8zgw.onrender.com/api';

  Future<List<Map<String, dynamic>>> getMemberships() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('memberships').get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception('Error al obtener los datos de las membresías.');
    }
  }

  Future<String?> createMembershipTransaction(String userId, String title,
      double price, int quantity, String duration) async {
    final url = Uri.parse('$_baseUrl/mercadopago/create_preference');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'title': title,
          'unit_price': 20,
          'quantity': quantity,
          'userId': userId,
          'duration': duration
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['id'];
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  Future<void> handlePaymentSuccess(String transactionId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/mercadopago/payment_success'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'transactionId': transactionId,
        'userId': 'user_id_here',
        'membershipTitle': 'Título de Membresía',
        'price': 20,
      }),
    );

    if (response.statusCode == 200) {
      print('Pago registrado correctamente.');
    } else {
      print('Error al registrar el pago: ${response.body}');
    }
  }
}
