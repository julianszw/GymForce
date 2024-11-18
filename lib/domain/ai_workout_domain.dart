import 'package:gym_force/domain/workout_domain.dart';

class AIWorkoutData {
  final List<String> selectedGroups;
  final String numberOfExercises;
  final Workout? workout;

  AIWorkoutData({
    required this.selectedGroups,
    required this.numberOfExercises,
    this.workout,
  });
}
