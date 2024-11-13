import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_force/domain/workout_domain.dart';

class WorkoutService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addWorkout(Workout workoutData) async {
    try {
      final User? user = _auth.currentUser;

      workoutData.userId = user?.uid;

      await _firestore.collection('workouts').add(workoutData.toJson());
    } catch (e) {
      throw Exception('Error al agregar la rutina: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getUserWorkouts() async {
    try {
      final User? user = _auth.currentUser;

      final querySnapshot = await _firestore
          .collection('workouts')
          .where('userId', isEqualTo: user?.uid)
          .get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Error al obtener las rutinas del usuario: $e');
    }
  }

  Future<void> updateWorkout(String id, Workout updatedWorkoutData) async {
    try {
      var snapshot = await _firestore
          .collection('workouts')
          .where('id', isEqualTo: id)
          .get();
      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.update(updatedWorkoutData.toJson());
      } else {
        throw Exception('No se encontró la rutina con el id: $id');
      }
    } catch (e) {
      throw Exception('Error al actualizar la rutina: $e');
    }
  }

  Future<void> deleteWorkout(String id) async {
    try {
      var snapshot = await _firestore
          .collection('workouts')
          .where('id', isEqualTo: id)
          .get();

      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.delete();
      } else {
        throw Exception('No se encontró la rutina con el id: $id');
      }
    } catch (e) {
      throw Exception('Error al eliminar la rutina: $e');
    }
  }
}
