import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_force/config/providers/workout_provider.dart';
import 'package:gym_force/presentation/widgets/navigation/drawer_nav_menu.dart';
import 'package:gym_force/presentation/widgets/yellow_button.dart';
import 'package:gym_force/services/workout_services.dart';
import 'package:gym_force/utils/choose_dialog.dart';
import 'package:gym_force/utils/common_dialog.dart';

class WorkoutsScreen extends ConsumerStatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  ConsumerState<WorkoutsScreen> createState() => WorkoutsScreenState();
}

class WorkoutsScreenState extends ConsumerState<WorkoutsScreen> {
  bool isLoading = false;

  void deleteWorkout(String workoutId) async {
    try {
      setState(() {
        isLoading = true;
      });
      await WorkoutService().deleteWorkout(workoutId);
      ref.read(workoutProvider.notifier).deleteWorkout(workoutId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rutina eliminada con éxito'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar la rutina')),
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final workouts = ref.watch(workoutProvider);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
      ),
      drawer: const DrawerNavMenu(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 2,
                    color: Theme.of(context).colorScheme.primary,
                    margin: const EdgeInsets.only(bottom: 20),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: Color(0xFF5A5A5A),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    width: 350,
                    child: Column(
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 24.0),
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 4,
                            ),
                          ),
                          onPressed: () {
                            showChooseDialog(
                                context: context,
                                onAcceptLeft: () {
                                  context.push('/create-manually-workout');
                                },
                                onAcceptRight: () {
                                  context.push('/create-ai-workout');
                                },
                                description:
                                    '¿Queres generar rutinas manualmente o con ayuda de la IA?',
                                leftText: 'Ingreso Manual',
                                rightText: 'Generación con IA');
                          },
                          icon: Icon(
                            Icons.add,
                            weight: 100,
                            size: 34,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          label: const Text(
                            '',
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Crear rutina con asistencia de IA o de manera personalizada',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Text(
                        'Rutinas (${workouts.length})',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  Container(
                    height: 2,
                    color: Theme.of(context).colorScheme.primary,
                    margin:
                        const EdgeInsets.only(left: 30, right: 30, bottom: 10),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: workouts.length,
                      itemBuilder: (context, index) {
                        final workout = workouts[index];
                        final exerciseNames = workout.exercises
                            .map((exercise) => exercise.name)
                            .join(', ');
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Card(
                            color: Colors.black,
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      workout.name,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  Text(
                                    '${workout.exercises.length} ${workout.exercises.length == 1 ? "ejercicio" : "ejercicios"}',
                                    style: const TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 2,
                                    color: Theme.of(context).colorScheme.primary,
                                    margin: const EdgeInsets.only(top: 5, bottom: 14),
                                  ),
                                  Text(
                                    exerciseNames,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      YellowButton(
                                        onPressed: () {
                                          context.push('/train-workout/${workout.id}');
                                        },
                                        text: 'Entrenar',
                                        width: 80,
                                        fontSize: 14,
                                      ),
                                      YellowButton(
                                        onPressed: () {
                                          context.push('/edit-workout/${workout.id}');
                                        },
                                        text: 'Editar',
                                        width: 80,
                                        fontSize: 14,
                                      ),
                                      YellowButton(
                                        onPressed: () {
                                          showCommonDialog(
                                              context: context,
                                              onAccept: () {
                                                deleteWorkout(workout.id);
                                              },
                                              title: '¿Estás seguro?',
                                              description:
                                                  'Si eliminas, no podrás recuperar la rutina.',
                                              acceptText: 'Eliminar');
                                        },
                                        text: 'Eliminar',
                                        width: 80,
                                        fontSize: 14,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 6),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
