import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_force/domain/branch_domain.dart';
import 'package:gym_force/services/branch_services.dart';
import 'package:gym_force/presentation/widgets/navigation/drawer_nav_menu.dart';

class HeadquarterScreen extends StatelessWidget {
  final BranchService _branchService = BranchService();
  HeadquarterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: const Text('Sedes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Ícono de retroceso
          onPressed: () {
            context.pop();
          },
        ),
      ),
      drawer: const DrawerNavMenu(),
      body: FutureBuilder<List<BranchData>>(
        future: _branchService.getBranches(),
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
          final branches = snapshot.data!;
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
                  itemCount: branches.length,
                  itemBuilder: (context, index) {
                    final branch = branches[index];
                    return BranchItem(
                      branchData: branch,
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

class BranchItem extends StatelessWidget {
  final BranchData branchData;
  const BranchItem({super.key, required this.branchData});

  bool getIsOpen() {
    final now = TimeOfDay.now();
    final openTime = TimeOfDay.fromDateTime(branchData.apertura!);
    final closingTime = TimeOfDay.fromDateTime(branchData.cierre!);

    // Manejar el caso especial donde closingTime es 00:00
    final adjustedClosingTime =
        closingTime.hour == 0 && closingTime.minute == 0 ? const TimeOfDay(hour: 23, minute: 59) : closingTime;

    if (adjustedClosingTime.hour < openTime.hour ||
        (adjustedClosingTime.hour == openTime.hour && adjustedClosingTime.minute < openTime.minute)) {
      // Caso donde el horario cruza la medianoche
      return (now.hour > openTime.hour ||
              (now.hour == openTime.hour && now.minute >= openTime.minute)) ||
          (now.hour < adjustedClosingTime.hour ||
              (now.hour == adjustedClosingTime.hour && now.minute < adjustedClosingTime.minute));
    } else {
      // Horario normal
      return (now.hour > openTime.hour ||
              (now.hour == openTime.hour && now.minute >= openTime.minute)) &&
          (now.hour < adjustedClosingTime.hour ||
              (now.hour == adjustedClosingTime.hour && now.minute < adjustedClosingTime.minute));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOpen = getIsOpen();
    final openTimeFormatted =
        "${branchData.apertura!.hour.toString().padLeft(2, '0')}:${branchData.apertura!.minute.toString().padLeft(2, '0')}";
    final closingTimeFormatted =
        "${branchData.cierre!.hour.toString().padLeft(2, '0')}:${branchData.cierre!.minute.toString().padLeft(2, '0')}";

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Color.fromARGB(255, 255, 242, 62),
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 3.0, top: 3.0),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromARGB(255, 255, 242, 62),
                    width: 2.0,
                  ),
                ),
              ),
              child: Text(
                branchData.barrio,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Image.network(
                  branchData.outsidePic,
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
                    return const Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 80,
                    );
                  },
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(branchData.ubicacion),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          isOpen ? Icons.check_sharp : Icons.cancel,
                          color: isOpen ? Colors.green : Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isOpen ? 'Abierto' : 'Cerrado',
                          style: TextStyle(
                            color: isOpen ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Apertura: $openTimeFormatted'),
                    Text('Cerrado: $closingTimeFormatted'),
                    const SizedBox(height: 8),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
