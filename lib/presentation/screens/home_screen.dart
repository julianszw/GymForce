import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_force/config/providers/daily_calories_provider.dart';
import 'package:gym_force/config/providers/calories_plan_provider.dart';
import 'package:gym_force/config/providers/payment_provider.dart';
import 'package:gym_force/config/providers/user_provider.dart';
import 'package:gym_force/presentation/widgets/navigation/drawer_nav_menu.dart';
import 'package:gym_force/presentation/widgets/qr/yellow_button.dart';
import 'package:gym_force/utils/choose_dialog.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_force/config/providers/workout_provider.dart';

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Título "Mi Semana"
            const SectionTitle(title: 'Mi Semana'),

            // Calendario bloqueado y con estilo amarillo
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: WeeklyCalendar(              ),
            ),
            const SizedBox(height: 20),

            // Título "Tus Rutinas"
            const SectionTitle(title: 'Tus Rutinas'),

            // Carrusel para las rutinas
            const HomeScreenCarousel(),

            const SizedBox(height: 10),

            // Título "Ingesta Calórica"
            const SectionTitle(title: 'Ingesta Calórica'),

            // Recuadro para las calorías
            const CaloriesSection(),

            const SizedBox(height: 10),

            // Título "Membresía"
            const SectionTitle(title: 'Membresía'),

            // Sección de Membresía rediseñada
            const MembershipSection(),
            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }
}


// Widget para los títulos con subrayado amarillo
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final textPainter = TextPainter(
                text: TextSpan(
                  text: title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                textDirection: TextDirection.ltr,
              )..layout(maxWidth: constraints.maxWidth);

              final textWidth = textPainter.size.width;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.yellow,
                    endIndent: constraints.maxWidth - textWidth, // Subrayado adaptativo
                  ),
                ],
              );
            },
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
    final startOfWeek = _startOfWeek(_focusedDay);
    final endOfWeek = _endOfWeek(startOfWeek);

    return TableCalendar(
      firstDay: startOfWeek,
      lastDay: endOfWeek,
      focusedDay: startOfWeek,
      calendarFormat: CalendarFormat.week,
      headerVisible: false,
      startingDayOfWeek: StartingDayOfWeek.monday,
      daysOfWeekVisible: true,
      eventLoader: (day) {
        final dayKey = DateTime(day.year, day.month, day.day);
        return _events[dayKey]?.keys.toList() ?? [];
      },
      onDaySelected: (selectedDay, focusedDay) {
        context.push('/calendar');
      },
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
        outsideDaysVisible: false,
      ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          final normalizedDate = DateTime(date.year, date.month, date.day);
          final dayEvents = _events[normalizedDate];

          if (dayEvents != null) {
            List<Widget> markers = [];

            if (dayEvents['calories'] == true) {
              markers.add(Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ));
            }

            if (dayEvents['workout'] == true) {
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
    );
  }
}

class HomeScreenCarousel extends ConsumerWidget {
  const HomeScreenCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workouts = ref.watch(workoutProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Tus rutinas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // Rutinas existentes
              ...workouts.take(3).map((workout) {
                return WorkoutCarouselItem(
                  title: workout.name,
                  subtitle: '${workout.exercises.length} ejercicios',
                  icon: Icons.fitness_center,
                  onTap: () {
                    context.push('/train-workout/${workout.id}');
                  },
                );
              }).toList(),
              // Botón "Crear rutina"
              WorkoutCarouselItem(
                title: 'Crear rutina',
                icon: Icons.add_circle_outline,
                onTap: () {
                  showChooseDialog(
                    context: context,
                    onAcceptLeft: () {
                      context.push('/create-manually-workout');
                    },
                    onAcceptRight: () {
                      context.push('/create-ai-workout');
                    },
                    description:
                        '¿Quieres generar rutinas manualmente o con ayuda de la IA?',
                    leftText: 'Ingreso Manual',
                    rightText: 'Generación con IA',
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class WorkoutCarouselItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const WorkoutCarouselItem({
    required this.title,
    required this.icon,
    required this.onTap,
    this.subtitle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        height: 230, // Aumentamos ligeramente el alto total
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Reducimos el tamaño del ícono
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 40, // Antes: 50
            ),
            const SizedBox(height: 8), // Espacio entre ícono y título
            // Título con truncamiento
            Text(
              title.length > 18 ? '${title.substring(0, 18)}...' : title,
              style: const TextStyle(
                color: Colors.yellow,
                fontSize: 15, // Ajuste menor al tamaño de fuente
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            // Espacio adicional entre título y subtítulo
            const SizedBox(height: 10),
            if (subtitle != null) ...[
              Text(
                subtitle!,
                style: const TextStyle(
                  color: Colors.yellow,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5), // Espacio menor aquí
            ],
          ],
        ),
      ),
    );
  }
}



class CaloriesSection extends ConsumerWidget {
  const CaloriesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Consumir los datos del plan de calorías y las calorías diarias
    final caloriesPlan = ref.watch(caloriePlanProvider);
    final dailyCalories = ref.watch(dailyCaloriesProvider);

    // Manejar casos donde no haya un plan de calorías definido
    if (caloriesPlan.calories.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          children: [
            Text(
              "No hay un plan de calorías activo.",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            YellowButton(
              onPressed: () {
                showChooseDialog(
                  context: context,
                  onAcceptLeft: () {
                    context.push('/set-diary-calories');
                  },
                  onAcceptRight: () {
                    context.push('/ai-calories');
                  },
                  description:
                      '¿Sabes cuántas calorías querés consumir o preferis la asistencia de la IA?',
                  leftText: 'Ingreso Manual',
                  rightText: 'Ingreso con IA',
                );
              },
              text: 'Crear Plan',
              isEnabled: true,
            ),

          ],
        ),
      );
    }

    // Cálculo del porcentaje de calorías
    final totalCalories = int.parse(dailyCalories['totalCalories']);
    final goalCalories = int.parse(caloriesPlan.calories);
    final percentage = (totalCalories / goalCalories).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Ingesta Calórica",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$totalCalories / $goalCalories kcal",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Calorías consumidas hoy",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              const Icon(
                Icons.local_fire_department,
                color: Colors.red,
                size: 32,
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearPercentIndicator(
            lineHeight: 14.0,
            percent: percentage,
            backgroundColor: Colors.grey.shade300,
            progressColor: Colors.amber,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              YellowButton(
                onPressed: () {
                  context.push('/set-diary-calories',
                  extra: {'addCalories': 'true'});
                },
                text: "Agregar",
                isEnabled: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}



class MembershipSection extends ConsumerWidget {
  const MembershipSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final paymentState = ref.watch(paymentProvider);

    // Obtención de los datos necesarios
    final isActive = paymentState.isActive;
    final plan = paymentState.title.isNotEmpty
        ? paymentState.title.split(' ')[1]
        : '-';
    final expirationDate = paymentState.expirationDate;
    final expirationDateString = expirationDate != null
        ? '${expirationDate.day}/${expirationDate.month}/${expirationDate.year}'
        : '';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.fitness_center, size: 40, color: Colors.yellow),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userState.name, style: const TextStyle(fontSize: 16)),
                Text(
                  'Activo: ${isActive ? 'Sí' : 'No'}',
                  style: TextStyle(
                    color: isActive ? Colors.green : Colors.red,
                  ),
                ),
                Text('Plan: $plan'),
                if (isActive)
                  Text(
                    'Vencimiento: $expirationDateString',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
