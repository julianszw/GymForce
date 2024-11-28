import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_force/config/providers/user_provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isLoading = false;
  List<Map<String, dynamic>> _dailyEvents = [];
  Map<DateTime, Map<String, bool>> _monthlyPoints = {}; // Puntos para el mes completo

  @override
  void initState() {
    super.initState();
    _fetchDailyData(_focusedDay); // Cargar datos del día actual al iniciar
    _fetchMonthlyData(_focusedDay); // Cargar datos del mes actual al inicio
  }

  Future<void> _fetchMonthlyData(DateTime focusedDay) async {
    setState(() {
      _isLoading = true;
      _monthlyPoints = {}; // Limpiar los puntos antes de cargar nuevos
    });

    final userState = ref.read(userProvider);
    final userId = userState.uid;

    // Determinar el inicio y el final del mes actual
    final startOfMonth = DateTime(focusedDay.year, focusedDay.month, 1);
    final endOfMonth = DateTime(focusedDay.year, focusedDay.month + 1, 0);

    try {
      // Consultar calorías del mes
      final caloriesSnapshot = await FirebaseFirestore.instance
          .collection('daily_calories')
          .where('user_id', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: startOfMonth)
          .where('date', isLessThanOrEqualTo: endOfMonth)
          .get();

      // Consultar entrenamientos del mes
      final workoutsSnapshot = await FirebaseFirestore.instance
          .collection('workout_record')
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: startOfMonth)
          .where('date', isLessThanOrEqualTo: endOfMonth)
          .get();

      Map<DateTime, Map<String, bool>> points = {};

      // Procesar calorías
      for (var doc in caloriesSnapshot.docs) {
        final data = doc.data();
        final date = (data['date'] as Timestamp).toDate();
        final eventDate = DateTime(date.year, date.month, date.day);

        points[eventDate] = points[eventDate] ?? {};
        points[eventDate]!['calories'] = true; // Marcar calorías
      }

      // Procesar entrenamientos
      for (var doc in workoutsSnapshot.docs) {
        final data = doc.data();
        final date = (data['date'] as Timestamp).toDate();
        final eventDate = DateTime(date.year, date.month, date.day);

        points[eventDate] = points[eventDate] ?? {};
        points[eventDate]!['workout'] = true; // Marcar entrenamientos
      }

      setState(() {
        _monthlyPoints = points; // Actualizar puntos para todo el mes
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching monthly data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }


Future<void> _fetchDailyData(DateTime selectedDay) async {
  setState(() {
    _isLoading = true;
    _dailyEvents = []; // Limpiar eventos antes de cargar nuevos
  });

  final userState = ref.read(userProvider);
  final userId = userState.uid;

  final startOfDay = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));

  try {
    // Consultar calorías
    final caloriesSnapshot = await FirebaseFirestore.instance
        .collection('daily_calories')
        .where('user_id', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: startOfDay)
        .where('date', isLessThan: endOfDay)
        .get();

    // Consultar entrenamientos
    final workoutsSnapshot = await FirebaseFirestore.instance
        .collection('workout_record')
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: startOfDay)
        .where('date', isLessThan: endOfDay)
        .get();

    final List<Map<String, dynamic>> events = [];

    // Procesar datos de calorías
    for (var doc in caloriesSnapshot.docs) {
      final data = doc.data();
      final date = (data['date'] as Timestamp).toDate();
      events.add({
        'id': doc.id, // Agregar ID del documento
        'type': 'calories',
        'calories': data['calories'],
        'carbs': data['carbs'],
        'fats': data['fats'],
        'proteins': data['proteins'],
        'time': date, // Guardar la hora del evento
      });
    }

    // Procesar datos de entrenamientos
    for (var doc in workoutsSnapshot.docs) {
      final data = doc.data();
      final date = (data['date'] as Timestamp).toDate();
      events.add({
        'id': doc.id, // Agregar ID del documento
        'type': 'workout',
        'name': data['name'],
        'duration': data['duration'],
        'exercises': data['exercises'],
        'time': date, // Guardar la hora del evento
      });
    }

    setState(() {
      _dailyEvents = events;
      _isLoading = false;
    });
  } catch (e) {
    print('Error fetching data: $e');
    setState(() {
      _isLoading = false;
    });
  }
}


Map<String, dynamic> _calculateTotals() {
  int totalDuration = 0;
  int totalCalories = 0;
  int totalCarbs = 0;
  int totalFats = 0;
  int totalProteins = 0;

  for (var event in _dailyEvents) {
    if (event['type'] == 'calories') {
      // Convertir strings a int de forma segura
      totalCalories += int.tryParse(event['calories'].toString()) ?? 0;
      totalCarbs += int.tryParse(event['carbs'].toString()) ?? 0;
      totalFats += int.tryParse(event['fats'].toString()) ?? 0;
      totalProteins += int.tryParse(event['proteins'].toString()) ?? 0;
    } else if (event['type'] == 'workout') {
      // Convertir strings a int de forma segura
      totalDuration += event['duration'] as int;
    }
  }

  return {
    'totalDuration': totalDuration,
    'totalCalories': totalCalories,
    'totalCarbs': totalCarbs,
    'totalFats': totalFats,
    'totalProteins': totalProteins,
  };
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario de Actividades'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true, // Centrar el mes en el encabezado
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _fetchDailyData(selectedDay); // Cargar datos del día seleccionado
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
              _fetchMonthlyData(focusedDay); // Cargar datos del nuevo mes
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                final normalizedDate = DateTime(date.year, date.month, date.day);
                final dayPoints = _monthlyPoints[normalizedDate];

                if (dayPoints != null) {
                  List<Widget> markers = [];

                  if (dayPoints['calories'] == true) {
                    markers.add(Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ));
                  }

                  if (dayPoints['workout'] == true) {
                    markers.add(Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ));
                  }

                  return Positioned(
                    bottom: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: markers,
                    ),
                  );
                }

                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: _buildEventList(),
                ),
        ],
      ),
    );
  }

Widget _buildEventList() {
  final totals = _calculateTotals();

  return Column(
    children: [
      const Text(
        'Totales del día:',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      Text('Duración total de entrenamientos: ${totals['totalDuration']} mins'),
      Text('Calorías totales: ${totals['totalCalories']} kcal'),
      Text(
          'Carbs: ${totals['totalCarbs']}, Fats: ${totals['totalFats']}, Proteins: ${totals['totalProteins']}'),
      const Divider(thickness: 2, height: 20),
      const Text(
        'Ingresos individuales:',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 8),
      Expanded(
        child: ListView.builder(
          itemCount: _dailyEvents.length,
          itemBuilder: (context, index) {
            final event = _dailyEvents[index];
            final time = (event['time'] as DateTime);
            final formattedTime =
                '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

            if (event['type'] == 'calories') {
              return ListTile(
                leading: const Icon(Icons.local_fire_department, color: Colors.blue),
                title: Text('${event['calories']} kcal'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hora: $formattedTime'),
                    Text(
                        'Carbs: ${event['carbs']}, Fats: ${event['fats']}, Proteins: ${event['proteins']}'),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteConfirmationDialog(
                    context,
                    event,
                    'daily_calories',
                    event['id'],
                  ),
                ),
              );
            } else if (event['type'] == 'workout') {
              return ListTile(
                leading: const Icon(Icons.fitness_center, color: Colors.green),
                title: Text(event['name']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hora: $formattedTime'),
                    Text('Duración: ${event['duration']} mins'),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteConfirmationDialog(
                    context,
                    event,
                    'workout_record',
                    event['id'],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    ],
  );
}


  Future<void> _deleteEvent(BuildContext context, Map<String, dynamic> event, String collectionName, String documentId) async {
  try {
    // Eliminamos el documento en Firebase
    await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(documentId)
        .delete();

    // Mostramos un mensaje de confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('¡Ingreso eliminado!')),
    );
  } catch (e) {
    // Manejo de errores
    print('Error al eliminar el documento: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error al eliminar el ingreso. Intenta de nuevo.'),
      ),
    );
  }
}

void _showDeleteConfirmationDialog(BuildContext context, Map<String, dynamic> event, String collectionName, String documentId) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Confirmar eliminación'),
      content: const Text('¿Estás seguro de que quieres eliminar este registro?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            _deleteEvent(context, event, collectionName, documentId);
          },
          child: const Text(
            'Eliminar',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );
}



}
