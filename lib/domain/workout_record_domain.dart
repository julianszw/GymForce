import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutRecord {
  final String id;
  final String name;
  final int duration;
  final List<Map<String, dynamic>> exercises;
  final String userId;
  final DateTime date;

  WorkoutRecord({
    required this.id,
    required this.name,
    required this.duration,
    required this.exercises,
    required this.userId,
    required this.date,
  });

  factory WorkoutRecord.fromMap(String id, Map<String, dynamic> data) {
    return WorkoutRecord(
      id: id,
      name: data['name'],
      duration: data['duration'],
      exercises: List<Map<String, dynamic>>.from(data['exercises']),
      userId: data['user_id'],
      date: (data['date'] as Timestamp).toDate(),
    );
  }
}
