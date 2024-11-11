/*
1) Falta hacer un domain y creo que un service (no provider) para reemplazar concurrentes.
2) Cambiar los nombres de las variables de español a ingles.
3) Agregar un link a la imagen de sucursal similar al usuario, tambien cambiarlo en firebase.
Buena Suerte! Cuando tenga el ui terminado te mensajeo.
*/ 
class GeoPoint {
  final double latitude;
  final double longitude;
  
  GeoPoint({
    required this.latitude,
    required this.longitude,
  });
}

class SucursalState {
   final String direccion;
   final String barrio;
   final GeoPoint geopoint;
   DateTime apertura;
   DateTime cierre;
   int capacidad;
   int? concurrentes; 
   String? telefono;

  SucursalState({
    required this.direccion,
    required this.barrio,
    required this.geopoint,
    required this.apertura,
    required this.cierre,
    required this.capacidad,
    this.concurrentes,
    this.telefono
     });
}

