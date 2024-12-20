import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_force/domain/branch_domain.dart';

class BranchService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  

Future<List<BranchData>> getBranches() async {
  try {
    QuerySnapshot querySnapshot = await _firestore.collection('branches').get();
    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return BranchData(
        apertura: (data['apertura'] as Timestamp?)?.toDate(),
        barrio: data['barrio'] ?? '',
        capacity: data['capacity'] ?? 0,
        cierre: (data['cierre'] as Timestamp?)?.toDate(),
        geoPoint: data['geoPoint'],
        outsidePic: data['outsidePic'] ?? '',
        remodeling: data['remodeling'] ?? false,
        sectors: List<String>.from(data['sectors'] ?? []),
        telefono: data['telefono'] ?? '',
        ubicacion: data['ubicacion'] ?? '',
      );
    }).toList();
  } catch (e) {
    throw Exception('Error no se puede recibir datos de las sucursales en services: $e');
  }
}
}