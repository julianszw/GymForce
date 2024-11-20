import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_force/domain/calories_domain.dart';

class CaloriePlan extends Calories {
  final String? id;

  CaloriePlan({
    this.id,
    required super.userId,
    required DateTime super.date,
    required super.calories,
    required super.proteins,
    required super.carbs,
    required super.fats,
  });

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    if (id != null) {
      baseMap.addAll({
        'id': id,
      });
    }
    return baseMap;
  }

  factory CaloriePlan.fromMap(Map<String, dynamic> map) {
    return CaloriePlan(
      id: map['id'],
      date: map['date'] != null
          ? (map['date'] as Timestamp).toDate()
          : DateTime.now(),
      userId: map['user_id'] ?? '',
      calories: map['calories'] ?? '0',
      proteins: map['proteins'] ?? '0',
      carbs: map['carbs'] ?? '0',
      fats: map['fats'] ?? '0',
    );
  }
}
