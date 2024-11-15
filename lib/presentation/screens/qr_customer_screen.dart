import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_force/config/providers/branch_provider.dart';
import 'package:gym_force/domain/branch_domain.dart';
import 'package:gym_force/presentation/widgets/qr/branch_card.dart';
import 'package:gym_force/presentation/widgets/yellow_button.dart';
import 'package:gym_force/services/branch_services.dart';
import 'package:geolocator/geolocator.dart';
import 'saludo_screen.dart';

class BranchListScreen extends ConsumerStatefulWidget {
  @override
  _BranchListScreenState createState() => _BranchListScreenState();
}

class _BranchListScreenState extends ConsumerState<BranchListScreen> {
  bool isLocationLoading = false;
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

  Future<bool> isWithinRange(GeoPoint branchGeoPoint, double maxDistanceMeters) async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return false;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return false;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        branchGeoPoint.latitude,
        branchGeoPoint.longitude,
      );

      return distanceInMeters <= maxDistanceMeters;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final branchProviderState = ref.watch(branchProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Generacion de QR"),
      ),
      body: isLocationLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (!showSaludo) Text("Nuestras sucursales"),
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
                            ? () async {
                                setState(() {
                                  isLocationLoading = true;
                                });
                                bool withinRange = await isWithinRange(
                                  selectedBranch!.geoPoint!,
                                  500.0,
                                );
                                setState(() {
                                  isLocationLoading = false;
                                });
                                if (withinRange) {
                                  mostrarSaludoTemporal();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Te encuentras a más de 500 metros del gimnasio. Para acceder al saludo, debes estar más cerca.",
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              }
                            : null,
                        text: "Generar QR",
                        isEnabled: selectedBranch != null,
                      ),
                    ),
                  if (showSaludo)
                    SaludoScreen(
                      barrio: selectedBranch?.barrio ?? "",
                      onCancel: cancelarSaludo,
                    ),
                ],
              ),
            ),
    );
  }
}
