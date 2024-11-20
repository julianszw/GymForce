import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_force/domain/headquarter_domain.dart';
import 'package:gym_force/services/headquarter_services.dart';
import 'package:gym_force/domain/currentpeople_domain.dart';
import 'package:gym_force/presentation/widgets/navigation/drawer_nav_menu.dart';

class HeadquarterScreen extends StatelessWidget {
  final BranchService _branchService = BranchService();
  HeadquarterScreen({super.key});
  final List<CurrentPeople> currentPeopleList = [
    CurrentPeople(peopleCount: 5),
    CurrentPeople(peopleCount: 80),
    CurrentPeople(peopleCount: 100),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: const Text('Calendario'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Ícono de retroceso
          onPressed: () {
            context.pop();
          },
        ),
      ),
      drawer: const DrawerNavMenu(),
      body: FutureBuilder<List<HeadquarterData>>(
        future: _branchService.getHeadquarters(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No hay gimnasios disponibles.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          final headquarters = snapshot.data!;
          return Column(
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
                    final currentPeople = index < currentPeopleList.length
                        ? currentPeopleList[index].peopleCount
                        : null;
                    return HeadquarterItem(
                      headquarterData: headquarter,
                      currentPeople: currentPeople ?? -1,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class HeadquarterItem extends StatelessWidget {
  final HeadquarterData headquarterData;
  final int currentPeople;
  const HeadquarterItem(
      {super.key, required this.headquarterData, required this.currentPeople});
  bool getIsOpen() {
    final now = DateTime.now();
    final openTime = headquarterData.openTime ?? now;
    final closingTime = headquarterData.closingTime ?? now;
    // Compare current time with open and closing times
    return now.isAfter(openTime) && now.isBefore(closingTime);
  }

  @override
  Widget build(BuildContext context) {
    final isOpen = getIsOpen();
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
                headquarterData.neighborhood,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Image.network(
                  headquarterData.outsidePic,
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
                    Text(headquarterData.address),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          isOpen ? Icons.check_sharp : Icons.cancel,
                          color: isOpen ? Colors.green : Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isOpen ? 'Open' : 'Closed',
                          style: TextStyle(
                            color: isOpen ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(headquarterData.hoursDisplayed),
                    SizedBox(height: 8),
                    SizedBox(
                      width: 160,
                      child: CapacityProgressIndicator(
                        current: currentPeople,
                        max: headquarterData.maxCapacity,
                        isOpen: isOpen,
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
  final bool isOpen;

  const CapacityProgressIndicator({
    super.key,
    this.current,
    this.max,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    if (!isOpen) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cerrado',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          LinearProgressIndicator(
            value: 0,
            backgroundColor: Colors.grey[300],
            color: Colors.grey,
          ),
        ],
      );
    }

    if (current == null || max == null || current == -1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Datos no Disponibles',
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          LinearProgressIndicator(
            value: 0,
            backgroundColor: Colors.grey[300],
            color: Colors.grey,
          ),
        ],
      );
    }

    final int safeCurrent = current ?? 0;
    final int safeMax = max ?? 1;

    double percentage =
        (safeMax == 0) ? 0.0 : (safeCurrent / safeMax).clamp(0.0, 1.0);

    Color progressColor;
    String statusText;

    if (percentage <= 0.3) {
      statusText = "Poco ocupado";
      progressColor = Colors.green;
    } else if (percentage <= 0.6) {
      statusText = "Moderadamente ocupado";
      progressColor = Colors.orange;
    } else if (percentage < 1.0) {
      statusText = "Muy ocupado";
      progressColor = Colors.red;
    } else {
      statusText = "Lleno";
      progressColor = Colors.red;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          statusText,
          style: TextStyle(
            color: progressColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: Colors.grey[300],
          color: progressColor,
        ),
      ],
    );
  }
}
