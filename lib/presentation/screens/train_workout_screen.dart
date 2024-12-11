import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_force/config/providers/workout_provider.dart';
import 'package:gym_force/domain/exercise_domain.dart';
import 'package:gym_force/domain/set_domani.dart';
import 'package:gym_force/domain/workout_domain.dart';
import 'package:gym_force/presentation/widgets/workout/workout_widget.dart';
import 'package:gym_force/services/workout_record_service.dart';
import 'package:gym_force/utils/common_dialog.dart';

class TrainWorkoutScreen extends ConsumerStatefulWidget {
  final String? workoutId;

  const TrainWorkoutScreen({super.key, this.workoutId});

  @override
  ConsumerState<TrainWorkoutScreen> createState() => TrainWorkoutScreenState();
}

class TrainWorkoutScreenState extends ConsumerState<TrainWorkoutScreen> {
  Workout? workout;
  String name = '';
  bool isLoading = false;
  List<Exercise> exercises = [];
  TextEditingController nameController = TextEditingController();
  List<List<dynamic>> controllers = [];
  ScrollController scrollController = ScrollController();
  List<List<bool>> isCheckedList = [];

  Timer? _timer;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    startTimer();

    try {
      final originalWorkout =
          ref.read(workoutProvider.notifier).getWorkoutById(widget.workoutId!);

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
        var exerciseNameController = TextEditingController(text: exercise.name);

        var setControllers = exercise.sets.map((set) {
          return [
            TextEditingController(text: set.kg.toString()),
            TextEditingController(text: set.reps.toString())
          ];
        }).toList();

        controllers.add([exerciseNameController, ...setControllers]);

        isCheckedList.add(List.generate(exercise.sets.length, (_) => false));
      }
    } catch (e) {
      print('No se encontró la rutina con id: ${widget.workoutId}');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  Future<void> saveRoutine() async {
    try {
      setState(() => isLoading = true);

      if (isCheckedList.any((list) => list.contains(false))) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Completa todos los sets antes de guardar la rutina.'),
          ),
        );
        return;
      }

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

      await WorkoutRecordService()
          .addWorkoutRecord(newRoutine, _elapsedSeconds ~/ 60);

      if (mounted) {
        context.pop();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Entrenamiento guardado!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        await Future.delayed(const Duration(milliseconds: 200));
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
      isCheckedList.add([false]);
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

      isCheckedList.removeAt(index);
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
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 5,
                      ),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF4F4F4F),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 15),
                          width: 320,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  (workout?.name != null &&
                                          workout!.name.length > 8)
                                      ? '${workout!.name.substring(0, 8)}...'
                                      : workout?.name ?? '',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: Text(
                                    formatTime(_elapsedSeconds),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  '${exercises.length} ${exercises.length == 1 ? "ejercicio" : "ejercicios"}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    WorkoutWidget(
                      exercises: exercises,
                      controllers: controllers,
                      scrollController: scrollController,
                      scrollToBottom: scrollToBottom,
                      deleteExercise: deleteExercise,
                      isTraining: true,
                      isCheckedList: isCheckedList,
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
                                      'Si no guardas, perderás el progreso.',
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
                              'Cancelar Rutina',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              showCommonDialog(
                                  title: '¿Terminar rutina?',
                                  acceptText: 'Terminar',
                                  context: context,
                                  description:
                                      '¿Estás seguro de que querés terminar la rutina?',
                                  onAccept: () {
                                    saveRoutine();
                                  },
                                  buttonTextSize: 14,
                                  buttonWidth: 80);
                            },
                            icon: const Icon(Icons.save, color: Colors.black),
                            label: const Text(
                              'Finalizar Rutina',
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
