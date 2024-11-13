import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_force/config/providers/workout_provider.dart';
import 'package:gym_force/domain/exercise_domain.dart';
import 'package:gym_force/domain/set_domani.dart';
import 'package:gym_force/domain/workout_domain.dart';
import 'package:gym_force/presentation/widgets/exercise_card.dart';
import 'package:gym_force/services/workout_services.dart';
import 'package:gym_force/utils/common_dialog.dart';

class WorkoutFormScreen extends ConsumerStatefulWidget {
  final String? workoutId;

  const WorkoutFormScreen({super.key, this.workoutId});

  @override
  ConsumerState<WorkoutFormScreen> createState() => WorkoutFormScreenState();
}

class WorkoutFormScreenState extends ConsumerState<WorkoutFormScreen> {
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
    if (widget.workoutId != null) {
      try {
        final originalWorkout = ref
            .read(workoutProvider.notifier)
            .getWorkoutById(widget.workoutId!);

        workout = Workout(
          userId: originalWorkout?.userId,
          id: originalWorkout!.id,
          name: originalWorkout.name,
          exercises: originalWorkout.exercises
              .map((e) => Exercise(
                    name: e.name,
                    sets: e.sets
                        .map((s) => ExerciseSet(
                              kg: s.kg,
                              reps: s.reps,
                            ))
                        .toList(),
                  ))
              .toList(),
        );

        name = workout!.name;
        exercises = workout!.exercises;
        nameController.text = name;

        for (var exercise in exercises) {
          var exerciseNameController =
              TextEditingController(text: exercise.name);

          var setControllers = exercise.sets.map((set) {
            return [
              TextEditingController(text: set.kg.toString()),
              TextEditingController(text: set.reps.toString())
            ];
          }).toList();

          controllers.add([exerciseNameController, ...setControllers]);
        }
      } catch (e) {
        print('No se encontró la rutina con id: ${widget.workoutId}');
      }
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
      if (widget.workoutId == '1') {
        await WorkoutService().addWorkout(newRoutine);
        ref.read(workoutProvider.notifier).createWorkout(newRoutine);
      } else {
        await WorkoutService().updateWorkout(widget.workoutId!, newRoutine);
        ref.read(workoutProvider.notifier).updateWorkout(newRoutine);
      }

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.workoutId == '1'
                ? '¡Rutina guardada!'
                : '¡Rutina actualizada!'),
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

  void addSet(int index) {
    setState(() {
      exercises[index].sets.add(ExerciseSet(kg: '', reps: ''));

      controllers[index].add([
        TextEditingController(),
        TextEditingController(),
      ]);
    });
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

  void deleteSet(int indexExercise, int indexSet) {
    setState(() {
      exercises[indexExercise].sets.removeAt(indexSet);
      controllers[indexExercise][indexSet + 1][0].dispose();
      controllers[indexExercise][indexSet + 1][1].dispose();
      controllers[indexExercise].removeAt(indexSet + 1);
    });
  }

  void updateSetValue(
      int indexExercise, int indexSet, String field, String value) {
    setState(() {
      if (field == 'kg') {
        exercises[indexExercise].sets[indexSet].kg = value;
      } else if (field == 'reps') {
        exercises[indexExercise].sets[indexSet].reps = value;
      }
    });
  }

  void updateExerciseName(int index, String name) {
    setState(() {
      exercises[index].name = name;
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
                    Center(
                      child: Text(
                        widget.workoutId == null
                            ? 'Ingresar Rutina Manualmente'
                            : 'Editar Rutina',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Nombre',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: nameController,
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                    hintText: 'Nombre',
                                    isDense: true,
                                    contentPadding: const EdgeInsets.all(6),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusColor: const Color(0xFF7B7B7B),
                                    fillColor: const Color(0xFF7B7B7B),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      name = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Cant. Ejercicios',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                      color: const Color(0xFF7B7B7B),
                                      borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.all(8),
                                  width: double.infinity,
                                  child: Text(
                                    '${exercises.length}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    exercises.isEmpty
                        ? const Expanded(
                            child: Center(
                              child: Text('Ingresa un ejercicio para comenzar'),
                            ),
                          )
                        :
                        // Card de Ejercicio
                        Expanded(
                            child: ListView.builder(
                                itemCount: exercises.length,
                                controller: scrollController,
                                itemBuilder: (context, index) {
                                  return ExerciseCard(
                                      index: index,
                                      exercise: exercises[index],
                                      deleteExercise: deleteExercise,
                                      addSet: addSet,
                                      deleteSet: deleteSet,
                                      updateSetValue: updateSetValue,
                                      updateExerciseName: updateExerciseName,
                                      controllers: controllers[index]);
                                })),
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
                            label: Text(
                              widget.workoutId == '1'
                                  ? 'Guardar Rutina'
                                  : 'Actualizar Rutina',
                              style: const TextStyle(
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
