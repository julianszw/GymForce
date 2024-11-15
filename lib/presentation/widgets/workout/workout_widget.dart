import 'package:flutter/material.dart';
import 'package:gym_force/domain/exercise_domain.dart';
import 'package:gym_force/domain/set_domani.dart';
import 'package:gym_force/presentation/widgets/exercise_card.dart';

class WorkoutWidget extends StatefulWidget {
  final List<Exercise> exercises;
  final List<List<dynamic>> controllers;
  final ScrollController scrollController;
  final Function scrollToBottom;
  final dynamic Function(int) deleteExercise;
  final bool isTraining;
  final List<List<bool>>? isCheckedList;

  const WorkoutWidget(
      {super.key,
      required this.exercises,
      required this.controllers,
      required this.scrollController,
      required this.scrollToBottom,
      required this.deleteExercise,
      this.isTraining = false,
      this.isCheckedList});

  @override
  State<WorkoutWidget> createState() => _WorkoutStateWidget();
}

class _WorkoutStateWidget extends State<WorkoutWidget> {
  void addSet(int index) {
    setState(() {
      widget.exercises[index].sets.add(ExerciseSet(kg: '', reps: ''));

      widget.controllers[index].add([
        TextEditingController(),
        TextEditingController(),
      ]);
      widget.isCheckedList?[index].add(false);
    });
    print('Lista luego de agregar set ${widget.isCheckedList}');
  }

  void deleteSet(int indexExercise, int indexSet) {
    setState(() {
      widget.exercises[indexExercise].sets.removeAt(indexSet);
      widget.controllers[indexExercise][indexSet + 1][0].dispose();
      widget.controllers[indexExercise][indexSet + 1][1].dispose();
      widget.controllers[indexExercise].removeAt(indexSet + 1);
    });
    widget.isCheckedList?[indexExercise].removeAt(indexSet);
  }

  void updateSetValue(
      int indexExercise, int indexSet, String field, String value) {
    setState(() {
      if (field == 'kg') {
        widget.exercises[indexExercise].sets[indexSet].kg = value;
      } else if (field == 'reps') {
        widget.exercises[indexExercise].sets[indexSet].reps = value;
      }
    });
  }

  void updateExerciseName(int index, String name) {
    setState(() {
      widget.exercises[index].name = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.exercises.isEmpty
        ? const Expanded(
            child: Center(
              child: Text('Ingresa un ejercicio para comenzar'),
            ),
          )
        : Expanded(
            child: ListView.builder(
                itemCount: widget.exercises.length,
                controller: widget.scrollController,
                itemBuilder: (context, index) {
                  return ExerciseCard(
                    index: index,
                    exercise: widget.exercises[index],
                    deleteExercise: widget.deleteExercise,
                    addSet: addSet,
                    deleteSet: deleteSet,
                    updateSetValue: updateSetValue,
                    updateExerciseName: updateExerciseName,
                    controllers: widget.controllers[index],
                    isTraining: widget.isTraining,
                    isCheckedList: widget.isCheckedList,
                  );
                }));
  }
}
