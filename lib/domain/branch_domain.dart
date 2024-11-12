import 'package:cloud_firestore/cloud_firestore.dart';

class BranchData {
  DateTime? apertura;
  String barrio;
  int? capacity;
  DateTime? cierre;
  GeoPoint? geoPoint;
  String outsidePic;
  bool remodeling;
  List<String>? sectors;
  String telefono;
  String ubicacion;

  BranchData({
    required this.apertura,
    required this.barrio,
    required this.capacity,
    required this.cierre,
    required this.geoPoint,
    required this.outsidePic,
    required this.remodeling,
    required this.sectors,
    required this.telefono,
    required this.ubicacion,
  });

}
