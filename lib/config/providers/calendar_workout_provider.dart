import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_force/domain/workout_record_domain.dart';

class WorkoutRecordNotifier extends StateNotifier<List<WorkoutRecord>> {
  WorkoutRecordNotifier() : super([]);

  // Agregar un nuevo registro
  void addWorkoutRecord(WorkoutRecord record) {
    state = [...state, record];
  }

  // Eliminar un registro por ID
  void deleteWorkoutRecord(String recordId) {
    state = state.where((record) => record.id != recordId).toList();
  }

  // Actualizar un registro existente
  void updateWorkoutRecord(WorkoutRecord updatedRecord) {
    state = state.map((record) {
      return record.id == updatedRecord.id ? updatedRecord : record;
    }).toList();
  }
}

// Provider global para acceder a los registros de entrenamiento
final workoutRecordProvider =
    StateNotifierProvider<WorkoutRecordNotifier, List<WorkoutRecord>>((ref) {
  return WorkoutRecordNotifier();
});
