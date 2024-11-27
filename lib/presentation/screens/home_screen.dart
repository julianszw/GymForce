import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_force/config/providers/user_provider.dart';
import 'package:gym_force/presentation/widgets/navigation/drawer_nav_menu.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.fitness_center, size: 28),
            SizedBox(width: 8),
            Text('GymForce', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      drawer: const DrawerNavMenu(),
      body: Column(
        children: [
          // Título "Mi Semana"
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Mi Semana',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // Recuadro para el calendario
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const WeeklyCalendar(),
          ),
        ],
      ),
    );
  }
}

class WeeklyCalendar extends ConsumerStatefulWidget {
  const WeeklyCalendar({Key? key}) : super(key: key);

  @override
  _WeeklyCalendarState createState() => _WeeklyCalendarState();
}

class _WeeklyCalendarState extends ConsumerState<WeeklyCalendar> {
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, Map<String, bool>> _events = {}; // Inicialización corregida

  @override
  void initState() {
    super.initState();
    _fetchWeeklyData(_focusedDay); // Cargar datos de la semana actual
  }

  Future<void> _fetchWeeklyData(DateTime focusedDay) async {
    final userState = ref.read(userProvider);
    final userId = userState.uid;

    // Calcular el inicio y el fin de la semana correctamente
    final startOfWeek = _startOfWeek(focusedDay);
    final endOfWeek = _endOfWeek(startOfWeek);

    try {
      // Consultar Firebase para calorías
      final caloriesSnapshot = await FirebaseFirestore.instance
          .collection('daily_calories')
          .where('user_id', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: startOfWeek)
          .where('date', isLessThanOrEqualTo: endOfWeek)
          .get();

      // Consultar Firebase para entrenamientos
      final workoutsSnapshot = await FirebaseFirestore.instance
          .collection('workout_record')
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: startOfWeek)
          .where('date', isLessThanOrEqualTo: endOfWeek)
          .get();

      // Procesar datos y construir el mapa de eventos
      Map<DateTime, Map<String, bool>> events = {};

      // Procesar calorías
      for (var doc in caloriesSnapshot.docs) {
        final data = doc.data();
        final date = (data['date'] as Timestamp).toDate();
        final eventDate = DateTime(date.year, date.month, date.day);

        events[eventDate] = events[eventDate] ?? {};
        events[eventDate]!['calories'] = true; // Marcar calorías
      }

      // Procesar entrenamientos
      for (var doc in workoutsSnapshot.docs) {
        final data = doc.data();
        final date = (data['date'] as Timestamp).toDate();
        final eventDate = DateTime(date.year, date.month, date.day);

        events[eventDate] = events[eventDate] ?? {};
        events[eventDate]!['workout'] = true; // Marcar entrenamientos
      }

      // Actualizar el estado del calendario
      setState(() {
        _events = events; // Asegurarse de que sea del tipo correcto
      });
    } catch (e) {
      print('Error fetching weekly data: $e');
    }
  }

  DateTime _startOfWeek(DateTime date) {
    return DateTime(date.year, date.month, date.day - (date.weekday - 1)); // Lunes a las 00:00
  }

  DateTime _endOfWeek(DateTime startOfWeek) {
    return startOfWeek.add(const Duration(days: 6, hours: 23, minutes: 59)); // Domingo a las 23:59
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime(1990),
      lastDay: DateTime(2050),
      focusedDay: _focusedDay,
      calendarFormat: CalendarFormat.week,
      headerVisible: false,
      startingDayOfWeek: StartingDayOfWeek.monday,
      daysOfWeekVisible: true,
      eventLoader: (day) {
        // Devolver categorías marcadas para el día
        final dayKey = DateTime(day.year, day.month, day.day);
        return _events[dayKey]?.keys.toList() ?? [];
      },
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
        outsideDaysVisible: false,
      ),
      onDaySelected: (selectedDay, focusedDay) {
        context.push('/calendar'); // Redirige a CalendarScreen
      },
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          // Normalizar la fecha para que coincida con las claves en _events
          final normalizedDate = DateTime(date.year, date.month, date.day);

          // Verificar si hay datos para la fecha normalizada
          final dayEvents = _events[normalizedDate];

          if (dayEvents != null) {
            List<Widget> markers = [];

            // Verificar si hay calorías
            if (dayEvents['calories'] == true) {
              markers.add(Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.blue, // Azul para calorías
                  shape: BoxShape.circle,
                ),
              ));
            } else {
              print("No se encontró 'calories' para la fecha: $normalizedDate");
            }

            // Verificar si hay entrenamientos
            if (dayEvents['workout'] == true) {
              markers.add(Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.green, // Verde para entrenamientos
                  shape: BoxShape.circle,
                ),
              ));
            } else {
              print("No se encontró 'workout' para la fecha: $normalizedDate");
            }

            return Positioned(
              bottom: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: markers,
              ),
            );
          }

          print("No hay eventos para la fecha: $normalizedDate");
          return null;
        },
      ),
    );
  }
}

