import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_force/config/providers/branch_provider.dart';
import 'package:gym_force/domain/branch_domain.dart';
import 'package:gym_force/presentation/widgets/qr/branch_card.dart';
import 'package:gym_force/presentation/widgets/yellow_button.dart';
import 'package:gym_force/services/branch_services.dart';

import 'saludo_screen.dart';

class BranchListScreen extends ConsumerStatefulWidget {
  @override
  _BranchListScreenState createState() => _BranchListScreenState();
}

class _BranchListScreenState extends ConsumerState<BranchListScreen> {
  List<BranchData> branches = [];
  BranchData? selectedBranch;
  bool showSaludo = false;

  @override
  void initState() {
    super.initState();
    _loadBranches();
  }

  Future<void> _loadBranches() async {
    try {
      BranchService branchService = BranchService();
      List<BranchData> fetchedBranches = await branchService.getBranches();
      setState(() {
        branches = fetchedBranches;
      });
    } catch (e) {
      print("Error al cargar sucursales: $e");
    }
  }

  void mostrarSaludoTemporal() {
    setState(() {
      showSaludo = true;
    });

    Future.delayed(Duration(seconds: 30), () {
      if (mounted) {
        setState(() {
          showSaludo = false;
        });
      }
    });
  }

  void cancelarSaludo() {
    setState(() {
      showSaludo = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final branchProviderState = ref.watch(branchProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Sucursales"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (!showSaludo)
              Expanded(
                child: ListView.builder(
                  itemCount: branches.length,
                  itemBuilder: (context, index) {
                    final branch = branches[index];
                    return BranchCard(
                      branch: branch,
                      isSelected: selectedBranch == branch,
                      onTap: () {
                        ref.read(branchProvider.notifier).setBranch(
                          apertura: branch.apertura ?? DateTime.now(),
                          barrio: branch.barrio,
                          capacity: branch.capacity ?? 0,
                          cierre: branch.cierre ?? DateTime.now(),
                          geoPoint: branch.geoPoint ?? GeoPoint(0, 0),
                          outsidePic: branch.outsidePic,
                          remodeling: branch.remodeling,
                          sectors: branch.sectors ?? [],
                          telefono: branch.telefono,
                          ubicacion: branch.ubicacion,
                        );
                        setState(() {
                          selectedBranch = branch;
                        });
                      },
                    );
                  },
                ),
              ),
            if (!showSaludo)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 200.0),
                child: YellowButton(
                  onPressed: selectedBranch != null
                      ? () {
                          mostrarSaludoTemporal();
                        }
                      : null,
                  text: "Mostrar saludo",
                  isEnabled: selectedBranch != null,
                ),
              ),
            if (showSaludo)
              SaludoScreen(
                barrio: branchProviderState.barrio,
                onCancel: cancelarSaludo,
              ),
          ],
        ),
      ),
    );
  }
}
