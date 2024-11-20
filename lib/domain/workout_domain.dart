import 'package:gym_force/domain/exercise_domain.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Workout {
  String id;
  String? userId;
  final String name;
  final List<Exercise> exercises;

  Workout(
      {required this.name, required this.exercises, this.userId, String? id})
      : id = id ?? uuid.v4();

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      name: json['name'],
      exercises:
          (json['exercises'] as List).map((e) => Exercise.fromJson(e)).toList(),
      id: '',
    )
      ..id = json['id'] ?? uuid.v4()
      ..userId = json['userId'];
  }

  factory Workout.backendFromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'] ?? uuid.v4(),
      userId: json['userId'] ?? '',
      name: json['name'],
      exercises: (json['exercises'] as List)
          .map((exerciseJson) => Exercise.fromJson(exerciseJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId ?? '',
      'name': name,
      'exercises': exercises.map((e) => e.toJson()).toList(),
    };
  }
}
