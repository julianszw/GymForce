import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getLatestPaymentForUser(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('payments')
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var data = snapshot.docs.first.data() as Map<String, dynamic>;

        if (data['date'] is Timestamp) {
          data['date'] = (data['date'] as Timestamp).toDate();
        }

        if (data['expirationDate'] is Timestamp) {
          data['expirationDate'] =
              (data['expirationDate'] as Timestamp).toDate();
        }

        return data;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(
          'Error al obtener el pago más reciente para el usuario. $e');
    }
  }
}
