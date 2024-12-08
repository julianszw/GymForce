import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_force/domain/workout_domain.dart';

class WorkoutRecordService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addWorkoutRecord(
      Workout workoutData, int durationInMinutes) async {
    try {
      final User? user = _auth.currentUser;
      final now = DateTime.now();

      final workoutRecordData = {
        'userId': user?.uid,
        'workoutId': workoutData.id,
        'name': workoutData.name,
        'exercises': workoutData.exercises.map((e) => e.toJson()).toList(),
        'duration': durationInMinutes,
        'date': now,
      };

      await _firestore.collection('workout_record').add(workoutRecordData);
    } catch (e) {
      throw Exception('Error al agregar el registro de la rutina');
    }
  }
}
