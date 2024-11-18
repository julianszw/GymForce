class ExerciseSet {
  String kg;
  String reps;

  ExerciseSet({required this.kg, required this.reps});

  factory ExerciseSet.fromJson(Map<String, dynamic> json) {
    return ExerciseSet(
      kg: json['kg'],
      reps: json['reps'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kg': kg,
      'reps': reps,
    };
  }
}
