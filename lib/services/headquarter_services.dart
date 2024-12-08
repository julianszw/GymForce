import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_force/domain/headquarter_domain.dart';

class BranchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<HeadquarterData>> getHeadquarters() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('headquarters').get();
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return HeadquarterData(
          neighborhood: data['neighborhood'] ?? '',
          address: data['address'] ?? '',
          hoursDisplayed: data['hoursDisplayed'] ?? '',
          maxCapacity: data['maxCapacity'] ?? 0,
          outsidePic: data['outsidePic'] ?? '',
          openTime: (data['openTime'] as Timestamp?)?.toDate(),
          closingTime: (data['closingTime'] as Timestamp?)?.toDate(),
          geoPoint: data['geoPoint'],
          remodeling: data['remodeling'] ?? false,
          sectors: List<String>.from(data['sectors'] ?? []),
          cellphone: data['cellphone'] ?? '',
        );
      }).toList();
    } catch (e) {
      throw Exception('Error no se puede recibir datos de las sucursales');
    }
  }
}
