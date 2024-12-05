import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_force/domain/calories_domain.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class DailyCalories extends Calories {
  final String planId;
  final String? id;

  DailyCalories({
    String? id,
    required this.planId,
    required super.userId,
    super.date,
    required super.calories,
    required super.proteins,
    required super.carbs,
    required super.fats,
  }) : id = id ?? uuid.v4();

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({'plan_id': planId, 'id': id});
    return baseMap;
  }

  factory DailyCalories.fromMap(Map<String, dynamic> map) {
    final date =
        map['date'] != null ? (map['date'] as Timestamp).toDate() : null;

    return DailyCalories(
      id: map['id'] ?? '',
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
