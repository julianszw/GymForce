import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CaloriesServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createCaloriesPlan({
    required String calories,
    required String proteins,
    required String carbs,
    required String fats,
  }) async {
    try {
      final User? user = _auth.currentUser;

      await _firestore.collection('caloriesPlans').add({
        'user_id': user?.uid,
        'date': DateTime.now(),
        'calories': calories,
        'proteins': proteins,
        'carbs': carbs,
        'fats': fats,
      });

      print("Plan de calorías guardado exitosamente.");
    } catch (e) {
      print("Error al guardar el plan de calorías: $e");
      throw e;
    }
  }
}
