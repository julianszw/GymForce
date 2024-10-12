import 'package:flutter/material.dart';

class WorkoutsScreen extends StatelessWidget {
  // Lista de rutinas
  final List<Map<String, String>> routines = [
    {'title': 'Pull', 'exercises': 'Pull Ups, Single Arm Lat Pulldown, Iso-Lateral Row, Hammer Curl, Bicep Curl'},
    {'title': 'Push', 'exercises': 'Pull Ups, Single Arm Lat Pulldown, Iso-Lateral Row, Hammer Curl, Bicep Curl'},
    {'title': 'Leg', 'exercises': 'Pull Ups, Single Arm Lat Pulldown, Iso-Lateral Row, Hammer Curl, Bicep Curl'},
    {'title': 'Pull 2', 'exercises': 'Pull Ups, Single Arm Lat Pulldown, Iso-Lateral Row, Hammer Curl, Bicep Curl'},
    {'title': 'Push 2', 'exercises': 'Pull Ups, Single Arm Lat Pulldown, Iso-Lateral Row, Hammer Curl, Bicep Curl'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo negro
      appBar: AppBar(
        title: Text('Rutinas'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Botón para crear una nueva rutina
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                ),
                onPressed: () {
                  // Acción para crear rutina
                },
                icon: Icon(Icons.add, size: 32),
                label: Text(
                  'Crear rutina con asistencia de IA o de manera personalizada',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Encabezado de las rutinas
            Text(
              'Rutinas (${routines.length})',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Divider(color: Colors.yellow, thickness: 2),
            Expanded(
              child: ListView.builder(
                itemCount: routines.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.grey[900],
                    child: ListTile(
                      title: Text(
                        routines[index]['title']!,
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        routines[index]['exercises']!,
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () {
                          // Acción para comenzar a entrenar
                        },
                        child: Text('Entrenar'),
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
