import 'package:cloud_firestore/cloud_firestore.dart';
// Solo si necesitas un url especifico por foto.
//import 'package:firebase_storage/firebase_storage.dart';

class SucursalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Solo si necesitas un url especifico por foto.
  //final FirebaseStorage _storage = FirebaseStorage.instance;

  final String fotoSucursalBase =
      "https://firebasestorage.googleapis.com/v0/b/gymforce-cde2c.appspot.com/o/users%2Fprofile_pics%2FGimnasio.jpg?alt=media&token=56b713c1-502a-48e0-9a04-2b7c108848d6";

  Future<List<Map<String, dynamic>>> getAllSucursales() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('sucursales').get();

      List<Map<String, dynamic>> sucursales = [];

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        Map<String, dynamic> sucursalData = {
          'photoUrl': fotoSucursalBase,
          'direccion': data['direccion'],
          'zona': data['zona'],
          'apertura': data['apertura'],
          'cierre': data['cierre'],
          'capacidad': data['capacidad'],
          'concurrentes': data['concurrentes'],
        };

        sucursales.add(sucursalData);
      }

      return sucursales;
    } catch (e) {
      throw Exception('Error no se puede recibir datos de las sucursales');
    }
  }
/*
  Future<void> updateConcurrentes(String sucursalDocId, int newConcurrentes) async {
    try {
      await _firestore.collection('sucursales').doc(sucursalDocId).update({
        'concurrentes': newConcurrentes,
      });
    } catch (e) {
      throw Exception('Error al actualizar concurrentes: $e');
    }
  }
*/
}

/*     
 Saca la foto de la firebase.
        String? photoUrl;
        if (data['photoPath'] != null) {
          photoUrl = await _storage.ref(data['photoPath']).getDownloadURL();
        }
*/ 