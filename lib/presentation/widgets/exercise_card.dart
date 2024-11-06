import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExerciseCard extends StatelessWidget {
  final int index;
  final List<dynamic> exercise;
  final Function(int) deleteExercise;
  final Function(int) addSet;
  final Function(int, int) deleteSet;
  final Function(int, int, String, String) updateSetValue;

  const ExerciseCard(
      {super.key,
      required this.index,
      required this.exercise,
      required this.deleteExercise,
      required this.addSet,
      required this.deleteSet,
      required this.updateSetValue});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF4F4F4F),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ejercicio ${index + 1}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  iconSize: 26,
                  icon: Icon(Icons.delete_outline,
                      color: Theme.of(context).colorScheme.primary),
                  onPressed: () {
                    deleteExercise(index);
                  },
                ),
              ],
            ),
            TextField(
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                isDense: true,
                hintText: 'Nombre',
                fillColor: Colors.grey[200],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 18),
            exercise[index].isNotEmpty
                ? Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: Table(
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: [
                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0),
                                  child: TableCell(
                                    child: Text(
                                      'Set',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    'Kg',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    'Reps',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Text(
                                    '',
                                  ),
                                )
                              ],
                            ),
                            ...exercise[index].asMap().entries.map((entry) {
                              int setIndex = entry.key;
                              var set = entry.value;
                              return TableRow(
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(30)),
                                      color: (setIndex % 2 == 0)
                                          ? const Color(0xFF6E6E6E)
                                          : const Color(0xFF333333)),
                                  children: [
                                    TableCell(
                                        child: Text(
                                      '${exercise[index].indexOf(set) + 1}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    )),
                                    TableCell(
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d*\.?\d*')),
                                        ],
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                        decoration: const InputDecoration(
                                          hintText: '-',
                                          hintStyle: TextStyle(fontSize: 16),
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                          filled: false,
                                        ),
                                        onChanged: (value) {
                                          updateSetValue(
                                              index, setIndex, 'kg', value);
                                        },
                                      ),
                                    ),
                                    TableCell(
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d*\.?\d*')),
                                        ],
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                        decoration: const InputDecoration(
                                          hintText: '-',
                                          hintStyle: TextStyle(fontSize: 16),
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                          filled: false,
                                        ),
                                        onChanged: (value) {
                                          updateSetValue(
                                              index, setIndex, 'reps', value);
                                        },
                                      ),
                                    ),
                                    TableCell(
                                      child: IconButton(
                                        icon: Icon(Icons.delete_outline,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                        onPressed: () {
                                          deleteSet(index, setIndex);
                                        },
                                      ),
                                    ),
                                  ]);
                            })
                          ]),
                    ),
                  )
                : Container(),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    addSet(index);
                  },
                  icon: const Icon(Icons.add, color: Colors.black),
                  label: const Text(
                    'Agregar Set',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
