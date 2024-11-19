import 'package:cloud_firestore/cloud_firestore.dart';

class HeadquarterData {
  String neighborhood;
  String address;
  String hoursDisplayed;
  int maxCapacity;
  String outsidePic;
  DateTime? openTime;
  DateTime? closingTime;
  GeoPoint? geoPoint;
  bool remodeling;
  List<String>? sectors;
  String cellphone;

  HeadquarterData({
    required this.neighborhood,
    required this.address,
    required this.hoursDisplayed,
    required this.maxCapacity,
    required this.outsidePic,
    required this.openTime,
    required this.closingTime,
    required this.geoPoint,
    required this.remodeling,
    required this.sectors,
    required this.cellphone,
  });
}
