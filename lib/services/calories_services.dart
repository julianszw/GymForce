import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_force/domain/calories_domain.dart';

class CaloriesServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Calories?> getCaloriesPlan() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      final querySnapshot = await _firestore
          .collection('caloriesPlans')
          .where('user_id', isEqualTo: userId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return Calories.fromMap(doc.data());
      } else {
        return null;
      }
    } catch (e) {
      throw Exception("Error al obtener el plan de calorías: $e");
    }
  }

  Future<void> createCaloriesPlan(Calories caloriesPlan) async {
    try {
      await _firestore.collection('caloriesPlans').add(caloriesPlan.toMap());
    } catch (e) {
      throw Exception("Error al guardar el plan de calorías: $e");
    }
  }
}
