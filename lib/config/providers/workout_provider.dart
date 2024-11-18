import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_force/domain/workout_domain.dart';

class WorkoutNotifier extends StateNotifier<List<Workout>> {
  WorkoutNotifier() : super([]);

  void createWorkout(Workout workout) {
    state = [...state, workout];
  }

  void deleteWorkout(String workoutId) {
    state = state.where((routine) => routine.id != workoutId).toList();
  }

  void updateWorkout(Workout updatedWorkout) {
    state = state.map((workout) {
      return workout.id == updatedWorkout.id ? updatedWorkout : workout;
    }).toList();
  }

  void setWorkouts(List<Workout> workouts) {
    state = workouts;
  }

  Workout? getWorkoutById(String id) {
    return state.firstWhere(
      (workout) => workout.id == id,
      orElse: () => throw Exception('No se encontró la rutina.'),
    );
  }
}

final workoutProvider =
    StateNotifierProvider<WorkoutNotifier, List<Workout>>((ref) {
  return WorkoutNotifier();
});
