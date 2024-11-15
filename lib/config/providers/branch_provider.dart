import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_force/domain/branch_domain.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BranchNotifier extends StateNotifier<BranchData> {
 
  BranchNotifier() 
      : super(
          BranchData(
            apertura: null,
            barrio: '',
            capacity: null,
            cierre: null,
            geoPoint: null,
            outsidePic: '',
            remodeling: false,
            sectors: null,
            telefono: '',
            ubicacion: '',
          ),
        );
        
  void setBranch({
    required DateTime apertura,
    required String barrio,
    required int capacity,
    required DateTime cierre,
    required GeoPoint geoPoint,
    required String outsidePic,
    required bool remodeling,
    required List<String> sectors,
    required String telefono,
    required String ubicacion,
  }) {
    state = BranchData(
            apertura: apertura,
            barrio: barrio,
            capacity: capacity,
            cierre: cierre,
            geoPoint: geoPoint,
            outsidePic: outsidePic,
            remodeling: remodeling,
            sectors: sectors,
            telefono: telefono,
            ubicacion: ubicacion,
    );
  }
}

final branchProvider = StateNotifierProvider<BranchNotifier, BranchData>((ref) {
  return BranchNotifier();
});