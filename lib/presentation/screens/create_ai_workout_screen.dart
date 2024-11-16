import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateAiWorkoutScreen extends ConsumerStatefulWidget {
  const CreateAiWorkoutScreen({
    super.key,
  });

  @override
  ConsumerState<CreateAiWorkoutScreen> createState() =>
      CreateAiWorkoutScreenState();
}

class CreateAiWorkoutScreenState extends ConsumerState<CreateAiWorkoutScreen> {
  Duration _selectedDuration = Duration.zero;
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

  Future<void> _selectDuration(BuildContext context) async {
    final Duration? picked = await showDialog<Duration>(
      context: context,
      builder: (BuildContext context) {
        int hours = _selectedDuration.inHours;
        int minutes = _selectedDuration.inMinutes % 60;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Seleccione el tiempo '),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<int>(
                    value: hours,
                    items: List.generate(4, (index) => index).map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value h'),
                      );
                    }).toList(),
                    onChanged: (int? newHours) {
                      setState(() {
                        hours = newHours ?? 0;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<int>(
                    value: minutes,
                    items: [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55]
                        .map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value m'),
                      );
                    }).toList(),
                    onChanged: (int? newMinutes) {
                      setState(() {
                        minutes = newMinutes ?? 0;
                      });
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text(
                    'Aceptar',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(Duration(hours: hours, minutes: minutes));
                  },
                ),
              ],
            );
          },
        );
      },
    );

    if (picked != null && picked.inMinutes > 0) {
      setState(() {
        _selectedDuration = picked;
      });
    }
  }

  Future<void> showMuscleGroupsModal(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return AlertDialog(
              title: const Text('Grupos Musculares'),
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
    generateWorkout() {
      if (_selectedDuration.inMinutes == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Por favor, seleccione un tiempo total')),
        );
        return;
      }

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
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Padding(
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
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tiempo Total',
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
                onTap: () => _selectDuration(context),
                child: InputDecorator(
                  decoration: const InputDecoration(),
                  child: _selectedDuration == Duration.zero
                      ? const Text(
                          '1h 10m',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        )
                      : Text(
                          '${_selectedDuration.inHours}h ${_selectedDuration.inMinutes % 60}m',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Cantida de Ejercicios',
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
              TextField(
                controller: numberOfExercisesController,
                style: const TextStyle(
                    fontSize: 16, height: 1, color: Colors.black),
                decoration: const InputDecoration(hintText: '5'),
                keyboardType: const TextInputType.numberWithOptions(),
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
