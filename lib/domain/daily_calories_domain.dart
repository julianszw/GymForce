import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_force/domain/calories_domain.dart';

class DailyCalories extends Calories {
  final String planId;

  DailyCalories({
    required this.planId,
    required super.userId,
    super.date,
    required super.calories,
    required super.proteins,
    required super.carbs,
    required super.fats,
  });

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'plan_id': planId,
    });
    return baseMap;
  }

  factory DailyCalories.fromMap(Map<String, dynamic> map) {
    final date =
        map['date'] != null ? (map['date'] as Timestamp).toDate() : null;

    return DailyCalories(
      planId: map['plan_id'] ?? '',
      userId: map['user_id'] ?? '',
      date: date,
      calories: map['calories'] ?? '0',
      proteins: map['proteins'] ?? '0',
      carbs: map['carbs'] ?? '0',
      fats: map['fats'] ?? '0',
    );
  }
}
