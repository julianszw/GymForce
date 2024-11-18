import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_force/domain/ai_workout_domain.dart';
import 'package:gym_force/domain/workout_domain.dart';

class IAWorkoutNotifier extends StateNotifier<AIWorkoutData> {
  IAWorkoutNotifier()
      : super(AIWorkoutData(
          selectedGroups: [],
          numberOfExercises: '',
          workout: null,
        ));

  void addAIWorkout(
      {required List<String> selectedGroups,
      required String numberOfExercises,
      required Workout workout}) {
    state = AIWorkoutData(
        selectedGroups: selectedGroups,
        numberOfExercises: numberOfExercises,
        workout: workout);
  }

  void deleteAIWorkout() {
    state = AIWorkoutData(
      selectedGroups: [],
      numberOfExercises: '',
      workout: null,
    );
  }
}

final aiWorkoutProvider =
    StateNotifierProvider<IAWorkoutNotifier, AIWorkoutData>((ref) {
  return IAWorkoutNotifier();
});
