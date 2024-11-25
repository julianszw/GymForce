import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DailyDetailsModal extends StatefulWidget {
  final DateTime selectedDate;
  final String userId;

  const DailyDetailsModal({
    Key? key,
    required this.selectedDate,
    required this.userId,
  }) : super(key: key);

  @override
  _DailyDetailsModalState createState() => _DailyDetailsModalState();
}

class _DailyDetailsModalState extends State<DailyDetailsModal> {
  List<Map<String, dynamic>> dailyCalories = [];
  List<Map<String, dynamic>> workouts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      // Consultar calorías
      QuerySnapshot calorieSnapshot = await FirebaseFirestore.instance
          .collection('daily_calories')
          .where('user_id', isEqualTo: widget.userId)
          .where('date',
              isEqualTo: Timestamp.fromDate(
                DateTime(widget.selectedDate.year, widget.selectedDate.month,
                    widget.selectedDate.day),
              ))
          .get();

      // Consultar entrenamientos
      QuerySnapshot workoutSnapshot = await FirebaseFirestore.instance
          .collection('workout_record')
          .where('userId', isEqualTo: widget.userId)
          .where('date',
              isEqualTo: Timestamp.fromDate(
                DateTime(widget.selectedDate.year, widget.selectedDate.month,
                    widget.selectedDate.day),
              ))
          .get();

      setState(() {
        dailyCalories = calorieSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        workouts = workoutSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error al obtener datos: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Viernes ${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView(
                      children: [
                        const Text(
                          'Ingresos',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        ...dailyCalories.map((entry) => _buildCalorieEntry(entry)),
                        ...workouts.map((entry) => _buildWorkoutEntry(entry)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Salir'),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildCalorieEntry(Map<String, dynamic> entry) {
    final calories = entry['calories'] ?? '0';
    final proteins = entry['proteins'] ?? '0';
    final carbs = entry['carbs'] ?? '0';
    final fats = entry['fats'] ?? '0';

    return ListTile(
      title: Text('$calories kcal'),
      subtitle: Text('Proteínas: $proteins, Carbs: $carbs, Grasas: $fats'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Implementar funcionalidad de edición
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Implementar funcionalidad de eliminación
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutEntry(Map<String, dynamic> entry) {
    final name = entry['name'] ?? 'Sin nombre';
    final duration = entry['duration'] ?? 0;

    return ListTile(
      title: Text(name),
      subtitle: Text('Duración: ${duration}min'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Implementar funcionalidad de edición
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Implementar funcionalidad de eliminación
            },
          ),
        ],
      ),
    );
  }
}
