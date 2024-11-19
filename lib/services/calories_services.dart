import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_force/domain/calories_plan_domain.dart';

class CaloriesServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<CaloriesPlan?> getCaloriesPlan() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      final querySnapshot = await _firestore
          .collection('caloriesPlans')
          .where('user_id', isEqualTo: userId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return CaloriesPlan.fromMap(doc.data());
      } else {
        print("No se encontró un plan de calorías para este usuario.");
        return null;
      }
    } catch (e) {
      throw Exception("Error al obtener el plan de calorías: $e");
    }
  }

  Future<void> createCaloriesPlan(CaloriesPlan caloriesPlan) async {
    try {
      await _firestore.collection('caloriesPlans').add(caloriesPlan.toMap());

      print("Plan de calorías guardado exitosamente.");
    } catch (e) {
      throw Exception("Error al guardar el plan de calorías: $e");
    }
  }
}
