import 'package:flutter/material.dart';
import 'package:gym_force/domain/headquarter_domain.dart';
import 'package:gym_force/domain/currentpeople_domain.dart';
import 'package:gym_force/presentation/widgets/navigation/drawer_nav_menu.dart';

class HeadquarterScreen extends StatelessWidget {
  HeadquarterScreen({super.key});

  final List<Headquarter> headquarters = [
    Headquarter(
      title: "Villa Crespo",
      address: "Av. Corrientes 2553",
      isOpen: true,
      hours: "06:00 | 23:30",
      imageUrl: "https://picsum.photos/200/300",
      status: "Bastante ocupado",
      maxCapacity: 100,
    ),
    Headquarter(
      title: "Caballito",
      address: "Av. Rivadavia 5071",
      isOpen: true,
      hours: "07:00 | 22:00",
      imageUrl: "https://picsum.photos/200/300",
      status: "Poca gente",
      maxCapacity: 80,
    ),
  ];

  final List<CurrentPeople> currentPeopleList = [
    CurrentPeople(peopleCount: 30),
    CurrentPeople(peopleCount: 20),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: const Text('Sedes'),
      ),
      drawer: const DrawerNavMenu(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromARGB(255, 255, 242, 62),
                    width: 2.0,
                  ),
                ),
              ),
              child: const Text(
                "Gimnasios Disponibles",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: headquarters.length,
              itemBuilder: (context, index) {
                final headquarter = headquarters[index];
                final currentPeople = currentPeopleList[index].peopleCount;

                return HeadquarterItem(
                  headquarter: headquarter,
                  currentPeople: currentPeople,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HeadquarterItem extends StatelessWidget {
  final Headquarter headquarter;
  final int currentPeople;

  const HeadquarterItem(
      {super.key, required this.headquarter, required this.currentPeople});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Color.fromARGB(255, 255, 242, 62),
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 3.0, top: 3.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: const Color.fromARGB(255, 255, 242, 62),
                    width: 2.0,
                  ),
                ),
              ),
              child: Text(
                headquarter.title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Image.network(
                  headquarter.imageUrl,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 80,
                    );
                  },
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(headquarter.address),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          headquarter.isOpen ? Icons.check_sharp : Icons.cancel,
                          color: headquarter.isOpen ? Colors.green : Colors.red,
                          size: 20,
                        ),
                        SizedBox(width: 4),
                        Text(
                          headquarter.isOpen ? 'Open' : 'Closed',
                          style: TextStyle(
                            color:
                                headquarter.isOpen ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(headquarter.hours),
                    SizedBox(height: 8),
                    Text(
                      headquarter.status,
                      style: TextStyle(
                        color: headquarter.status == 'Bastante ocupado'
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                    // Thiss and the code below is broken, beacuse reasons?
                    SizedBox(
                      width:
                          200, // Makes the progress bar expand to the full width of its parent
                      child: CapacityProgressIndicator(
                        current: currentPeople,
                        max: headquarter.maxCapacity,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}

class CapacityProgressIndicator extends StatelessWidget {
  final int? current;
  final int? max;

  const CapacityProgressIndicator({super.key, this.current, this.max});

  @override
  Widget build(BuildContext context) {
    if (current == null || max == null) {
      return const Text(
        'Datos no Disponibles',
        style: TextStyle(
          color: Colors.red,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    final int safeCurrent = current ?? 0;
    final int safeMax = max ?? 1;

    double percentage =
        (safeMax == 0) ? 0.0 : (safeCurrent / safeMax).clamp(0.0, 1.0);

    Color progressColor;
    if (percentage <= 0.3) {
      progressColor = Colors.green;
    } else if (percentage <= 0.6) {
      progressColor = Colors.orange;
    } else {
      progressColor = Colors.red;
    }

    return LinearProgressIndicator(
      value: percentage,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      color: progressColor,
    );
  }
}
