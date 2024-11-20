import 'package:cloud_firestore/cloud_firestore.dart';

class Calories {
  final String userId;
  final DateTime? date;
  final String calories;
  final String proteins;
  final String carbs;
  final String fats;

  Calories({
    required this.userId,
    required this.date,
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fats,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'date': date,
      'calories': calories,
      'proteins': proteins,
      'carbs': carbs,
      'fats': fats,
    };
  }

  factory Calories.fromMap(Map<String, dynamic> map) {
    final date = (map['date'] as Timestamp).toDate();

    return Calories(
      userId: map['user_id'] ?? '',
      date: date,
      calories: map['calories'] ?? 0,
      proteins: map['proteins'] ?? 0,
      carbs: map['carbs'] ?? 0,
      fats: map['fats'] ?? 0,
    );
  }
}
