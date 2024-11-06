import 'package:flutter/material.dart';
import 'package:gym_force/presentation/widgets/exercise_card.dart';

class CreateManuallyWorkoutScreen extends StatefulWidget {
  const CreateManuallyWorkoutScreen({super.key});

  @override
  CreateManuallyWorkoutScreenState createState() =>
      CreateManuallyWorkoutScreenState();
}

class CreateManuallyWorkoutScreenState
    extends State<CreateManuallyWorkoutScreen> {
  List<List<Map<String, String>>> exercises = [];

  void addExercise() {
    setState(() {
      exercises.add([
        {'name': '', 'kg': '0', 'reps': '0'}
      ]);
      print(exercises);
    });
  }

  void addSet(int index) {
    print(index);
    setState(() {
      exercises[index].add({
        'kg': '0',
        'reps': '0',
      });
    });
    print(exercises);
  }

  void deleteExercise(int index) {
    print(index);
    setState(() {
      exercises.removeAt(index);
    });
    print(exercises);
  }

  void deleteSet(int indexExercise, int indexSet) {
    print(indexExercise);
    print(indexSet);
    setState(() {
      exercises[indexExercise].removeAt(indexSet);
    });
  }

  void updateSetValue(
      int indexExercise, int indexSet, String field, String value) {
    setState(() {
      exercises[indexExercise][indexSet][field] = value;
    });
    print(exercises);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Ingresar Rutina Manualmente',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Nombre',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                hintText: 'Nombre',
                                isDense: true,
                                contentPadding: const EdgeInsets.all(6),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide.none, // Quitar el borde
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide
                                      .none, // Quitar el borde cuando no está enfocado
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide
                                      .none, // Quitar el borde cuando está enfocado
                                ),
                                focusColor: const Color(0xFF7B7B7B),
                                fillColor: const Color(0xFF7B7B7B),
                              ),
                            ),
                          ],
                        ),
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
                                color: Theme.of(context).colorScheme.primary),
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
                                  color: Theme.of(context).colorScheme.primary),
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
                          itemBuilder: (context, index) {
                            return ExerciseCard(
                                index: index,
                                exercise: exercises,
                                deleteExercise: deleteExercise,
                                addSet: addSet,
                                deleteSet: deleteSet,
                                updateSetValue: updateSetValue);
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    label: const Text(
                      'No Guardar',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.save, color: Colors.black),
                    label: const Text(
                      'Guardar Rutina',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
