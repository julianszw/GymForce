import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_force/config/providers/workout_provider.dart';
import 'package:gym_force/domain/exercise_domain.dart';
import 'package:gym_force/domain/set_domani.dart';
import 'package:gym_force/domain/workout_domain.dart';
import 'package:gym_force/presentation/widgets/workout/header.dart';
import 'package:gym_force/presentation/widgets/workout/workout_widget.dart';
import 'package:gym_force/services/workout_services.dart';
import 'package:gym_force/utils/common_dialog.dart';

class CreateManuallyWorkoutScreen extends ConsumerStatefulWidget {
  const CreateManuallyWorkoutScreen({super.key});

  @override
  ConsumerState<CreateManuallyWorkoutScreen> createState() =>
      CreateManuallyWorkoutScreenState();
}

class CreateManuallyWorkoutScreenState
    extends ConsumerState<CreateManuallyWorkoutScreen> {
  Workout? workout;
  String name = '';
  bool isLoading = false;
  List<Exercise> exercises = [];
  TextEditingController nameController = TextEditingController();
  List<List<dynamic>> controllers = [];
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    for (var exercise in exercises) {
      var exerciseNameController = TextEditingController(text: exercise.name);

      var setControllers = exercise.sets.map((set) {
        return [
          TextEditingController(text: set.kg.toString()),
          TextEditingController(text: set.reps.toString())
        ];
      }).toList();

      controllers.add([exerciseNameController, ...setControllers]);
    }
  }

  Future<void> saveRoutine() async {
    try {
      setState(() => isLoading = true);

      if (name.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ingresa el nombre de la rutina'),
          ),
        );
        return;
      }
      if (exercises.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ingresa al menos un ejercicio'),
          ),
        );
        return;
      }

      for (var exercise in exercises) {
        if (exercise.name.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No dejes un ejercicio sin nombre'),
            ),
          );
          return;
        }

        for (var set in exercise.sets) {
          if (set.reps.isEmpty || set.kg.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No dejes sets vacíos.'),
              ),
            );
            return;
          }
        }
      }
      final newRoutine = Workout(
          name: name,
          exercises: exercises,
          id: workout?.id,
          userId: workout?.userId);

      await WorkoutService().addWorkout(newRoutine);
      ref.read(workoutProvider.notifier).createWorkout(newRoutine);

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Rutina guardada!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar la rutina.')),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void addExercise() {
    setState(() {
      exercises.add(Exercise(
        name: '',
        sets: [
          ExerciseSet(kg: '', reps: ''),
        ],
      ));
      controllers.add([
        TextEditingController(),
        [TextEditingController(), TextEditingController()]
      ]);
    });
    scrollToBottom();
  }

  void deleteExercise(int index) {
    setState(() {
      controllers[index][0].dispose();
      for (var controller in controllers[index]) {
        if (controller is List) {
          controller[0].dispose();
          controller[1].dispose();
        }
      }
      controllers.removeAt(index);

      exercises.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Header(
                      title: 'Ingresar Rutina Manualmente',
                      nameController: nameController,
                      numberOfExercises: exercises.length,
                      onNameChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                    ),
                    WorkoutWidget(
                      exercises: exercises,
                      controllers: controllers,
                      scrollController: scrollController,
                      scrollToBottom: scrollToBottom,
                      deleteExercise: deleteExercise,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: addExercise,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                        ),
                        child: const Text(
                          'Nuevo Ejercicio',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              showCommonDialog(
                                  acceptText: 'Descartar',
                                  context: context,
                                  description:
                                      'Si no guardas, los cambios se perderán.',
                                  onAccept: () {
                                    context.pop();
                                  },
                                  title: '¿Estás seguro?',
                                  buttonTextSize: 14,
                                  buttonWidth: 80);
                            },
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.black),
                            label: const Text(
                              'No Guardar',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: saveRoutine,
                            icon: const Icon(Icons.save, color: Colors.black),
                            label: const Text(
                              'Guardar Rutina',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
