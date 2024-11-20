import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_force/domain/calorie_plan_domain.dart';
import 'package:gym_force/domain/calories_domain.dart';
import 'package:gym_force/domain/daily_calories_domain.dart';

class CaloriesServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<CaloriePlan?> getCaloriesPlan() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      final querySnapshot = await _firestore
          .collection('calories_plans')
          .where('user_id', isEqualTo: userId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return CaloriePlan.fromMap(doc.data());
      } else {
        return null;
      }
    } catch (e) {
      throw Exception("Error al obtener el plan de calorías: $e");
    }
  }

  Future<void> createCaloriesPlan(Calories caloriesPlan) async {
    try {
      final docRef = await _firestore
          .collection('calories_plans')
          .add(caloriesPlan.toMap());
      await docRef.update({'id': docRef.id});
    } catch (e) {
      throw Exception("Error al guardar el plan de calorías: $e");
    }
  }

  Future<void> addDailyCalories(DailyCalories dailyCalories) async {
    try {
      await _firestore.collection('daily_calories').add(dailyCalories.toMap());
    } catch (e) {
      throw Exception("Error al agregar DailyCalories: $e");
    }
  }

  //Agregar que traiga por fecha
  Future<List<DailyCalories>> getDailyCaloriesList(
      DateTime selectedDate) async {
    try {
      // Establecer el inicio del día (00:00:00) y el final del día (23:59:59)
      final userId = FirebaseAuth.instance.currentUser?.uid;
      DateTime startOfDay = DateTime(
          selectedDate.year, selectedDate.month, selectedDate.day, 0, 0, 0);
      DateTime endOfDay = DateTime(
          selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59);

      final querySnapshot = await _firestore
          .collection('daily_calories')
          .where('user_id', isEqualTo: userId)
          // Filtramos las fechas, asegurándonos de que la fecha esté entre `startOfDay` y `endOfDay`
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThanOrEqualTo: endOfDay)
          .get();

      return querySnapshot.docs
          .map((doc) => DailyCalories.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception("Error al obtener las Calorías Diarias: $e");
    }
  }
}
