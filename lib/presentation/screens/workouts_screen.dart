import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_force/presentation/widgets/navigation/drawer_nav_menu.dart';
import 'package:gym_force/presentation/widgets/yellow_button.dart';
import 'package:gym_force/utils/auth_guard.dart';

class WorkoutsScreen extends StatelessWidget {
  // Lista de rutinas
  static const List<Map<String, String>> routines = [
    {
      'title': 'Pull',
      'duration': '1 hora 10 minutos',
      'number of exercises': '5',
      'exercises':
          'Pull Ups, Single Arm Lat Pulldown, Iso-Lateral Row, Hammer Curl, Bicep Curl'
    },
    {
      'title': 'Push',
      'duration': '1 hora 10 minutos',
      'number of exercises': '5',
      'exercises':
          'Pull Ups, Single Arm Lat Pulldown, Iso-Lateral Row, Hammer Curl, Bicep Curl'
    },
    {
      'title': 'Leg',
      'duration': '1 hora 10 minutos',
      'number of exercises': '5',
      'exercises':
          'Pull Ups, Single Arm Lat Pulldown, Iso-Lateral Row, Hammer Curl, Bicep Curl'
    },
    {
      'title': 'Pull 2',
      'duration': '1 hora 10 minutos',
      'number of exercises': '5',
      'exercises':
          'Pull Ups, Single Arm Lat Pulldown, Iso-Lateral Row, Hammer Curl, Bicep Curl'
    },
    {
      'title': 'Push 2',
      'duration': '1 hora 10 minutos',
      'number of exercises': '5',
      'exercises':
          'Pull Ups, Single Arm Lat Pulldown, Iso-Lateral Row, Hammer Curl, Bicep Curl'
    },
    {
      'title': 'Push 2',
      'duration': '1 hora 10 minutos',
      'number of exercises': '5',
      'exercises':
          'Pull Ups, Single Arm Lat Pulldown, Iso-Lateral Row, Hammer Curl, Bicep Curl'
    },
    {
      'title': 'Push 2',
      'duration': '1 hora 10 minutos',
      'number of exercises': '5',
      'exercises':
          'Pull Ups, Single Arm Lat Pulldown, Iso-Lateral Row, Hammer Curl, Bicep Curl'
    },
  ];

  const WorkoutsScreen({super.key});

  void _showAddWorkoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            '¿Queres generar rutinas manualmente o con ayuda de la IA?',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                YellowButton(
                  onPressed: () {
                    context.push('/create-manually-workout');
                  },
                  text: 'Ingreso Manual',
                  width: 120,
                  fontSize: 12,
                ),
                YellowButton(
                  onPressed: () {},
                  text: 'Generación con IA',
                  width: 120,
                  fontSize: 12,
                )
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
      ),
      drawer: const DrawerNavMenu(),
      body: Padding(
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
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              width: 350,
              child: Column(
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 24.0),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 4,
                      ),
                    ),
                    onPressed: () {
                      _showAddWorkoutDialog(
                          context); // Llama a la función para mostrar el diálogo
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  'Rutinas (${routines.length})',
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
              margin: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: routines.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Card(
                      color: Colors.black,
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              routines[index]['title']!,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              routines[index]['duration']!,
                            ),
                            Text(
                              '${routines[index]['number of exercises']!} ejercicios',
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
                              routines[index]['exercises']!,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                YellowButton(
                                  onPressed: () {},
                                  text: 'Entrenar',
                                  width: 80,
                                  fontSize: 14,
                                ),
                                YellowButton(
                                  onPressed: () {},
                                  text: 'Editar',
                                  width: 80,
                                  fontSize: 14,
                                ),
                                YellowButton(
                                  onPressed: () {},
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
