import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_force/domain/sucursal_domain.dart';

class SucursalNotifier extends StateNotifier<SucursalState> {
 
  SucursalNotifier() 
      : super(
          SucursalState(
            direccion: '',
            barrio: '',
            geopoint: GeoPoint(latitude: 0.0, longitude: 0.0),
            apertura: DateTime.now(),
            cierre: DateTime.now(),
            capacidad: 0,
          ),
        );
        
  void setSucursal({
    required String direccion,
    required String barrio,
    required GeoPoint geopoint,
    required DateTime apertura,
    required DateTime cierre,
    required int capacidad,
    int? concurrentes,
    String? telefono,
  }) {
    state = SucursalState(
      direccion: direccion,
      barrio: barrio,
      geopoint: geopoint,
      apertura: apertura,
      cierre: cierre,
      capacidad: capacidad,
      concurrentes: concurrentes,
      telefono: telefono,
    );
  }
}

final sucursalProvider = StateNotifierProvider<SucursalNotifier, SucursalState>((ref) {
  return SucursalNotifier();
});