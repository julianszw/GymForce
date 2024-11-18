import 'package:gym_force/domain/set_domani.dart';

class Exercise {
  String name;
  List<ExerciseSet> sets;

  Exercise({required this.name, required this.sets});

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'],
      sets: (json['sets'] as List).map((e) => ExerciseSet.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sets': sets.map((e) => e.toJson()).toList(),
    };
  }
}
