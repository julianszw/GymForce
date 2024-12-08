import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_force/config/providers/ai_workout_provider.dart';
import 'package:gym_force/main.dart';
import 'package:gym_force/services/workout_services.dart';

class CreateAiWorkoutScreen extends ConsumerStatefulWidget {
  const CreateAiWorkoutScreen({
    super.key,
  });

  @override
  ConsumerState<CreateAiWorkoutScreen> createState() =>
      CreateAiWorkoutScreenState();
}

class CreateAiWorkoutScreenState extends ConsumerState<CreateAiWorkoutScreen> {
  bool isLoading = false;
  final TextEditingController numberOfExercisesController =
      TextEditingController();

  List<String> muscleGroups = [
    'Abdominales',
    'Abductores',
    'Adductores',
    'Antebrazos',
    'Bíceps',
    'Cardio',
    'Cuerpo Completo',
    'Cuádriceps',
    'Dorsales',
    'Espalda Alta',
    'Espalda Baja',
    'Gemelos',
    'Glúteos',
    'Hombros',
    'Isquiotibiales',
    'Pecho',
    'Trapecios',
    'Tríceps'
  ];

  Map<String, bool> selectedMuscleGroups = {};
  List<String> selectedGroups = [];

  @override
  void initState() {
    super.initState();
    for (var muscle in muscleGroups) {
      selectedMuscleGroups[muscle] = false;
    }
  }

  Future<void> showMuscleGroupsModal(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Grupos Musculares'),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView(
                  children: muscleGroups.map((muscle) {
                    return CheckboxListTile(
                      title: Text(muscle),
                      value: selectedMuscleGroups[muscle],
                      onChanged: (bool? value) {
                        modalSetState(() {
                          selectedMuscleGroups[muscle] = value ?? false;
                          setState(() {
                            selectedGroups = selectedMuscleGroups.entries
                                .where((entry) => entry.value)
                                .map((entry) => entry.key)
                                .toList();
                          });
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    modalSetState(() {
                      selectedMuscleGroups.updateAll((key, value) => false);
                    });
                    setState(() {
                      selectedGroups.clear();
                    });
                  },
                  child: Text(
                    'Vaciar',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  child: const Text(
                    'Aceptar',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    generateWorkout() async {
      int? exerciseCount = int.tryParse(numberOfExercisesController.text);

      if (exerciseCount == null || exerciseCount <= 0 || exerciseCount > 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'La cantidad de ejercicios debe ser un número entre 1 y 10'),
          ),
        );
        return;
      }

      bool isAnyMuscleSelected =
          selectedMuscleGroups.values.any((isSelected) => isSelected);

      if (!isAnyMuscleSelected) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Por favor, seleccione al menos un grupo muscular')),
        );
        return;
      }
      try {
        final router = GoRouter.of(context);
        setState(() {
          isLoading = true;
        });

        final numExercises = numberOfExercisesController.text;
        final workout = await WorkoutService()
            .createAIWorkout(selectedGroups, numExercises);
        if (workout != null) {
          ref.read(aiWorkoutProvider.notifier).addAIWorkout(
              selectedGroups: selectedGroups,
              numberOfExercises: numExercises,
              workout: workout);
          if (mounted) {
            await router.push('/ai-workout');
            await Future.delayed(const Duration(milliseconds: 200));
          }
        } else {
          if (mounted) {
            scaffoldMessengerKey.currentState?.showSnackBar(
              const SnackBar(
                content: Text('Ha ocurrido un error al generar la rutina.'),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          scaffoldMessengerKey.currentState?.showSnackBar(
            const SnackBar(
              content: Text('Ha ocurrido un error al generar la rutina.'),
            ),
          );
        }
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: isLoading
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  context.pop();
                },
              ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Generación de Rutina con IA',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Grupos Musculares',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    InkWell(
                      onTap: () => showMuscleGroupsModal(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(),
                        child: Builder(
                          builder: (context) {
                            String displayText;
                            if (selectedGroups.isEmpty) {
                              displayText = 'Seleccionar grupos musculares';
                            } else if (selectedGroups.length <= 3) {
                              displayText = selectedGroups.join(', ');
                            } else {
                              displayText =
                                  '${selectedGroups.take(3).join(', ')} +${selectedGroups.length - 3}';
                            }
                            return Text(
                              displayText,
                              style: TextStyle(
                                fontSize: 16,
                                color: selectedGroups.isEmpty
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          const Text(
                            'Cantidad de Ejercicios ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Tooltip(
                            verticalOffset: 14,
                            exitDuration: const Duration(seconds: 5),
                            preferBelow: false,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            textStyle: const TextStyle(color: Colors.black),
                            triggerMode: TooltipTriggerMode.tap,
                            message:
                                'La IA ajustará la cantidad según crea conveniente',
                            child: const Icon(
                              Icons.info_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextField(
                      controller: numberOfExercisesController,
                      style: const TextStyle(
                          fontSize: 16, height: 1, color: Colors.black),
                      decoration: const InputDecoration(hintText: '5'),
                      keyboardType: const TextInputType.numberWithOptions(),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 130),
                      child: Column(
                        children: [
                          const Text(
                            'Generar Rutina',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
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
                            onPressed: generateWorkout,
                            icon: Icon(
                              Icons.add,
                              weight: 100,
                              size: 50,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            label: const Text(
                              '',
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
